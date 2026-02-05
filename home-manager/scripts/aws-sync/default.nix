{ pkgs, ... }:

let
  aws-sync = pkgs.writeShellScriptBin "aws-sync" ''
    set -e

    INVENTORY="$HOME/.aws/inventory.json"
    CONFIG_FILE="$HOME/.aws/config"
    SSO_OP_PATH="op://Work/AWS/WBD"

    mkdir -p "$HOME/.aws"
    echo "[]" > "$INVENTORY"

    add_entry() {
      local new_entry
      new_entry=$(${pkgs.jq}/bin/jq -n \
        --arg org "$1" --arg type "$2" --arg name "$3" --arg id "$4" --arg role "$5" \
        --arg arn "''${6:-}" --arg sso_url "''${7:-}" --arg sso_reg "''${8:-}" \
        '{org: $org, type: $type, account_name: $name, account_id: $id, role_name: $role, role_arn: $arn, sso_start_url: $sso_url, sso_region: $sso_reg}')

      ${pkgs.jq}/bin/jq --argjson entry "$new_entry" '. += [$entry]' "$INVENTORY" > tmp.json && mv tmp.json "$INVENTORY"
    }

    echo "Starting discovery across all organizations..."

    echo "Fetching SSO configuration from 1Password..."
    SSO_START_URL=$(${pkgs._1password-cli}/bin/op read "$SSO_OP_PATH")

    if [ -z "$SSO_START_URL" ]; then
        echo "Error: Could not fetch SSO Start URL from 1Password path: $SSO_OP_PATH"
        exit 1
    fi

    for ORG in "DSC" "DTC" "WB"; do
      echo "Scanning SAML Org: ''${ORG}..."
      
      RAW=$(${pkgs._1password-cli}/bin/op run --env-file="$HOME/.aws/saml2aws/''${ORG}/.env" -- ${pkgs.saml2aws}/bin/saml2aws --skip-prompt list-roles -a "''${ORG}" 2>/dev/null || echo "")
      
      if [ -z "$RAW" ]; then 
        echo "Warning: No data returned for ''${ORG}"
        continue 
      fi

      echo "$RAW" | awk -v org="''${ORG}" '
        /^Account: / {
            line = $0; sub(/^Account: /, "", line);
            if (line ~ /\(/) {
                acc_name = substr(line, 1, index(line, " (") - 1);
                acc_id = substr(line, index(line, "(") + 1);
                sub(/\)/, "", acc_id);
            } else {
                acc_name = line; acc_id = line;
            }
        }
        /^arn:aws:iam/ {
            arn = $1;
            n = split(arn, p, "/");
            role_name = p[n];
            gsub(/\r/, "", acc_name); gsub(/\r/, "", acc_id); gsub(/\r/, "", role_name);
            print acc_name "|" acc_id "|" role_name "|" arn
        }
      ' | while IFS='|' read -r name id role arn; do
        add_entry "''${ORG}" "saml" "$name" "$id" "$role" "$arn"
      done
    done

    echo "Scanning SSO Org: WBD..."
    SSO_RAW=$(${pkgs.granted}/bin/granted sso generate --sso-region us-east-1 "$SSO_START_URL" 2>/dev/null)

    echo "$SSO_RAW" | awk -v org="WBD" '
        /^\[profile / {
            p_str = $0; gsub(/\[profile |\]/, "", p_str);
            split(p_str, p_parts, "/");
            acc_name = p_parts[1];
        }
        /granted_sso_start_url/  { sso_url = $3 }
        /granted_sso_region/     { sso_reg = $3 }
        /granted_sso_account_id/ { acc_id = $3 }
        /granted_sso_role_name/  { role_name = $3 }
        /credential_process/ {
            if (acc_name != "") {
                gsub(/\r/, "", acc_name); gsub(/\r/, "", acc_id); gsub(/\r/, "", role_name);
                print acc_name "|" acc_id "|" role_name "|" sso_url "|" sso_reg
            }
        }
    ' | while IFS='|' read -r name id role url reg; do
        add_entry "WBD" "sso" "$name" "$id" "$role" "" "$url" "$reg"
    done

    echo "Discovery Complete. Found $(${pkgs.jq}/bin/jq 'length' "$INVENTORY") roles."
    echo "----------------------------------------------------"

    echo "Generating $CONFIG_FILE..."

    {
        echo "# Generated AWS Config - $(date)"
        echo "[default]"
        echo "region = us-east-1"
        echo "output = json"
    } > "$CONFIG_FILE"

    ${pkgs.jq}/bin/jq -c '.[]' "$INVENTORY" | while read -r row; do
        ORG=$(echo "$row" | ${pkgs.jq}/bin/jq -r '.org')
        TYPE=$(echo "$row" | ${pkgs.jq}/bin/jq -r '.type')
        NAME=$(echo "$row" | ${pkgs.jq}/bin/jq -r '.account_name')
        ID=$(echo "$row" | ${pkgs.jq}/bin/jq -r '.account_id')
        ROLE=$(echo "$row" | ${pkgs.jq}/bin/jq -r '.role_name')
        
        PROFILE="''${ORG}/''${NAME}/''${ROLE}"

        echo "" >> "$CONFIG_FILE"
        echo "[profile ''${PROFILE}]" >> "$CONFIG_FILE"

        if [ "$TYPE" == "sso" ]; then
            URL=$(echo "$row" | ${pkgs.jq}/bin/jq -r '.sso_start_url')
            REG=$(echo "$row" | ${pkgs.jq}/bin/jq -r '.sso_region')
            
            {
                echo "granted_sso_start_url = ''${URL}"
                echo "granted_sso_region = ''${REG}"
                echo "granted_sso_account_id = ''${ID}"
                echo "granted_sso_role_name = ''${ROLE}"
                echo "common_fate_generated_from = aws-sso"
                echo "credential_process = granted credential-process --auto-login --profile ''${PROFILE}"
            } >> "$CONFIG_FILE"
        else
            ARN=$(echo "$row" | ${pkgs.jq}/bin/jq -r '.role_arn')
            ENV_FILE="$HOME/.aws/saml2aws/''${ORG}/.env"
            
            {
                echo "region = us-east-1"
                echo "credential_process = ${pkgs._1password-cli}/bin/op run --env-file=''${ENV_FILE} -- ${pkgs.saml2aws}/bin/saml2aws login --credential-process --idp-account=''${ORG} --role=''${ARN} 2>/dev/null"
            } >> "$CONFIG_FILE"
        fi
    done

    echo "Success! Config generated with $(${pkgs.jq}/bin/jq 'length' "$INVENTORY") profiles."
  '';
in
{
  home.packages = [
    aws-sync
    pkgs.jq
    pkgs.granted
    pkgs.saml2aws
    pkgs._1password-cli
  ];
}
