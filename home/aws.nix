{
  lib,
  pkgs,
  user,
  ...
}: let
  vault = "Work";
  envs = "DSC DTC WB";
in {
  home.file.".saml2aws".text = ''
    [default]
    name                    = default
    provider                = Okta
    mfa                     = TOTP
    skip_verify             = false
    aws_urn                 = urn:amazon:webservices
    aws_session_duration    = 3600
    saml_cache              = true
    disable_remember_device = false
    disable_sessions        = false
  '';

  home.file.".aws/env/DSC.env".text = ''
    SAML2AWS_USERNAME="op://${vault}/WBD/username"
    SAML2AWS_PASSWORD="op://${vault}/WBD/password"
    SAML2AWS_MFA_TOKEN="op://${vault}/WBD/one-time password?attribute=otp"
    SAML2AWS_URL="op://${vault}/AWS-DSC/url"
    SAML2AWS_SAML_CACHE_FILE="/Users/${user.name}/.aws/saml2aws/cache_DSC"
  '';

  home.file.".aws/env/DTC.env".text = ''
    SAML2AWS_USERNAME="op://${vault}/WBD/username"
    SAML2AWS_PASSWORD="op://${vault}/WBD/password"
    SAML2AWS_MFA_TOKEN="op://${vault}/WBD/one-time password?attribute=otp"
    SAML2AWS_URL="op://${vault}/AWS-DTC/url"
    SAML2AWS_SAML_CACHE_FILE="/Users/${user.name}/.aws/saml2aws/cache_DTC"
  '';

  home.file.".aws/env/WB.env".text = ''
    SAML2AWS_USERNAME="op://${vault}/WBD/username"
    SAML2AWS_PASSWORD="op://${vault}/WBD/password"
    SAML2AWS_MFA_TOKEN="op://${vault}/WBD/one-time password?attribute=otp"
    SAML2AWS_URL="op://${vault}/AWS-WB/url"
    SAML2AWS_SAML_CACHE_FILE="/Users/${user.name}/.aws/saml2aws/cache_WB"
  '';

  # home.file.".aws/env/WBD.env".text = ''
  #   SAML2AWS_USERNAME="op://${vault}/WBD/username"
  #   SAML2AWS_PASSWORD="op://${vault}/WBD/password"
  #   SAML2AWS_MFA_TOKEN="op://${vault}/WBD/one-time password?attribute=otp"
  #   SAML2AWS_URL="op://${vault}/AWS-WBD/url"
  #   SAML2AWS_SAML_CACHE_FILE="/Users/${user.name}/.aws/saml2aws/cache_WBD"
  # '';

  home.activation.genAWSConfig = lib.hm.dag.entryAfter ["linkGeneration"] ''
    # Path to AWS config file
    AWS_CONFIG_FILE="/Users/${user.name}/.aws/config"

    # Check if the AWS config file already exists
    if [[ -f "$AWS_CONFIG_FILE" ]]; then
      echo "AWS config file found, skipping gen."
    else
      # Path to awk, retry, saml2aws and op
      AWK=${lib.getExe pkgs.gawk}
      RETRY=${lib.getExe pkgs.retry}
      SAML2AWS=${lib.getExe pkgs.saml2aws}
      OP=${lib.getExe pkgs._1password-cli}

      if [[ -n "$AWK" && -n "$RETRY" && -n "$SAML2AWS" && -n "$OP" ]]; then
        # Check if op is logged in
        if $OP account list 2>&1 | grep -q '^URL'; then

          # Set masked envs in the script
          export SAML2AWS_USERNAME="op://${vault}/WBD/username"
          export SAML2AWS_PASSWORD="op://${vault}/WBD/password"
          export SAML2AWS_MFA_TOKEN="op://${vault}/WBD/one-time password?attribute=otp"

          # Path to saml2aws cache file
          CACHE_FILE="/Users/${user.name}/.aws/saml2aws/cache"

          # Path to the env files
          ENV_PATH="/Users/${user.name}/.aws/env"

          # Create the AWS config directory if it doesn't exist
          mkdir -p "/Users/${user.name}/.aws"

          for env in ${envs}; do
            {
              echo "### Env: $env ###"
              echo ""
            } >> "$AWS_CONFIG_FILE"
            # Get roles from saml2aws and generate the config entries
            $RETRY -d 30 -t 2 $OP run --env-file="$ENV_PATH/$env.env" -- $SAML2AWS list-roles --skip-prompt 2>/dev/null| while IFS= read -r line; do
              case "$line" in
                Account:\ *\ \(*\))
                  account_name=$(echo "$line" | $AWK -F '[()]' '{print $1}' | $AWK '{print $2}')
                  account_id=$(echo "$line" | $AWK -F '[()]' '{print $2}')
                  ;;
                Account:\ [0-9]*)
                  account_id=$(echo "$line" | $AWK '{print $2}')
                  account_name=""
                  ;;
                arn:aws:iam::*:role/*)
                  role_arn="$line"
                  role_name=$(echo "$line" | $AWK -F '/' '{print $NF}')
                  if [ -n "$account_name" ]; then
                    profile_name="''${account_name}-/''${role_name}"
                  else
                    profile_name="''${account_id}-/''${role_name}"
                  fi
                  {
                    echo "[profile $profile_name]"
                    echo "credential_process = op run --env-file=\"$ENV_PATH/$env.env\" -- saml2aws login --profile $profile_name --role $role_arn --skip-prompt --credential-process --credentials-file=$CACHE_FILE"
                    echo ""
                  } >> "$AWS_CONFIG_FILE"
                  ;;
              esac
            done
          done

          echo "AWS config file generated at $AWS_CONFIG_FILE"
        else
          echo "op account not found, please log in (and enable CLI integration)."
        fi
      else
        echo "aws, retry, saml2aws or op not found, please install them first."
      fi
    fi
  '';

  programs.awscli = {
    enable = true;
  };
}
