{ pkgs, ... }:

let
  k8s-sync = pkgs.writeShellScriptBin "k8s-sync" ''
    set -e

    AWS_INV="$HOME/.aws/inventory.json"
    K8S_INV="$HOME/.kube/inventory.json"
    PREFS="$HOME/.kube/role-preferences.json"
    KUBE_CLUSTER_DIR="$HOME/.kube/clusters"

    OP_BASE_PATH="op://Work/K8S"
    SOURCES=(
        "bolt_eks.json" 
        "disco_eks.json" 
        "hbo_eks.json"
    )

    ROLE_PRIORITY=(
        "GtSustainingEngineering"
    )

    mkdir -p "$KUBE_CLUSTER_DIR"
    [ ! -f "$PREFS" ] && echo "{}" > "$PREFS"
    echo "[]" > "$K8S_INV"

    echo "Starting K8s Discovery & Config Generation..."

    for FILENAME in "''${SOURCES[@]}"; do
        echo "Fetching ''${FILENAME} from 1Password..."
        RAW_FILE_DATA=$(${pkgs._1password-cli}/bin/op read "$OP_BASE_PATH/''${FILENAME}" 2>/dev/null || echo "")
        
        if [ -z "$RAW_FILE_DATA" ] || [ "$RAW_FILE_DATA" == "[]" ]; then
            echo "  ! Skipping ''${FILENAME} (empty or not found)"
            continue
        fi
        
        TYPE="eks"
        [[ "''${FILENAME}" == *"anthos"* ]] && TYPE="anthos"
        [[ "''${FILENAME}" == *"metal"* ]] && TYPE="bare-metal"

        while read -r row; do
            ACC_ID=$(echo "''${row}" | ${pkgs.jq}/bin/jq -r '.account_id')
            EKS_NAME=$(echo "''${row}" | ${pkgs.jq}/bin/jq -r '.eks_name')
            REGION=$(echo "''${row}" | ${pkgs.jq}/bin/jq -r '.region')

            PROFILES=$(${pkgs.jq}/bin/jq -r --arg id "$ACC_ID" '.[] | select(.account_id == $id) | "\(.org)/\(.account_name)/\(.role_name)"' "$AWS_INV")
            COUNT=$(echo "$PROFILES" | grep -v "^$" | wc -l | xargs || echo 0)

            if [ "$COUNT" -eq 0 ]; then continue; fi

            if [ "$COUNT" -eq 1 ]; then
                SELECTED_PROFILE="$PROFILES"
            else
                PREF=$(${pkgs.jq}/bin/jq -r --arg eks "$EKS_NAME" '.[$eks]' "$PREFS")
                if [ "$PREF" != "null" ]; then
                    SELECTED_PROFILE="$PREF"
                else
                    MATCH_FOUND=""
                    for priority_role in "''${ROLE_PRIORITY[@]}"; do
                        MATCH=$(echo "$PROFILES" | grep "/''${priority_role}$" | head -n 1 || true)
                        if [ -n "$MATCH" ]; then
                            MATCH_FOUND="$MATCH"
                            break
                        fi
                    done

                    if [ -n "$MATCH_FOUND" ]; then
                        SELECTED_PROFILE="$MATCH_FOUND"
                    else
                        echo "  ? No tiered match for ''${EKS_NAME} (''${ACC_ID}). Select role:"
                        SELECTED_PROFILE=$(echo "$PROFILES" | ${pkgs.fzf}/bin/fzf --height 15% --reverse --header "Role for ''${EKS_NAME}" < /dev/tty)
                    fi

                    if [ -n "$SELECTED_PROFILE" ]; then
                        ${pkgs.jq}/bin/jq --arg eks "$EKS_NAME" --arg prof "$SELECTED_PROFILE" '.[$eks] = $prof' "$PREFS" > tmp.json && mv tmp.json "$PREFS"
                    fi
                fi
            fi

            [ -z "$SELECTED_PROFILE" ] && continue

            ALIAS=$(echo "''${row}" | ${pkgs.jq}/bin/jq -r '.alias')
            if [ "$ALIAS" == "NA" ] || [ -z "$ALIAS" ]; then
                ALIAS=$(${pkgs.jq}/bin/jq -r --arg id "$ACC_ID" '.[] | select(.account_id == $id) | .account_name' "$AWS_INV" | head -n 1)
                [ -z "$ALIAS" ] && ALIAS="$ACC_ID"
            fi

            NEW_ENTRY=$(${pkgs.jq}/bin/jq -n \
                --arg eks "$EKS_NAME" --arg prof "$SELECTED_PROFILE" --arg reg "$REGION" \
                --arg name "$ALIAS" --arg id "$ACC_ID" --arg type "$TYPE" \
                '{cluster_name: $eks, aws_profile: $prof, region: $reg, account_name: $name, account_id: $id, cluster_type: $type}')
            
            ${pkgs.jq}/bin/jq --argjson entry "$NEW_ENTRY" '. += [$entry]' "$K8S_INV" > tmp.json && mv tmp.json "$K8S_INV"

            KUBE_PATH="$KUBE_CLUSTER_DIR/''${EKS_NAME}.yaml"
            if [ "$TYPE" == "eks" ]; then
                if [ ! -f "$KUBE_PATH" ]; then
                    echo "  > Creating config for ''${EKS_NAME}..."
                    ${pkgs.awscli2}/bin/aws eks update-kubeconfig --name "''${EKS_NAME}" --region "''${REGION}" --profile "''${SELECTED_PROFILE}" --kubeconfig "''${KUBE_PATH}" < /dev/null || echo "    FAILED to create config for ''${EKS_NAME}"
                fi
            fi
        done <<< "$(echo "$RAW_FILE_DATA" | ${pkgs.jq}/bin/jq -c '.[]')"
    done

    echo "----------------------------------------------------"
    echo "K8s Sync Complete! Total: $(${pkgs.jq}/bin/jq 'length' "$K8S_INV") clusters."
  '';
in
{
  home.packages = [
    k8s-sync
    pkgs.jq
    pkgs._1password-cli
    pkgs.fzf
    pkgs.awscli2
  ];
}
