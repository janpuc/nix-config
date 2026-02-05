{ pkgs, ... }:

let
  _awsx = pkgs.writeShellScriptBin "_awsx" ''
    INVENTORY="$HOME/.aws/inventory.json"

    if [ ! -f "$INVENTORY" ]; then
        echo "echo 'Error: Inventory missing. Run 'aws-sync' first.'"
        exit 1
    fi

    if [[ -n "$1" ]]; then
        MATCH=$(${pkgs.jq}/bin/jq -r --arg input "$1" '.[] | select("\(.org)/\(.account_name)/\(.role_name)" == $input) | "\(.org)/\(.account_name)/\(.role_name)"' "$INVENTORY" | head -n 1)
        if [[ -n "$MATCH" ]]; then
            echo "export AWS_PROFILE=\"$MATCH\""
            echo "export AWS_REGION=\"us-east-1\""
            echo "assume \"$MATCH\""
            exit 0
        else
            echo "echo 'Error: Profile \"$1\" not found.'"
            exit 1
        fi
    fi

    ACCOUNT_ROW=$(${pkgs.jq}/bin/jq -r '
        .[] | 
        "\(.org) | \(if .account_name == "" or .account_name == null then .account_id else .account_name end) | \(.account_id)"
    ' "$INVENTORY" | sort -u | column -t -s '|' | ${pkgs.fzf}/bin/fzf \
        --ansi --prompt="Account> " --height=40% --layout=default)

    [ -z "$ACCOUNT_ROW" ] && exit 0

    SEL_ORG=$(echo "$ACCOUNT_ROW" | awk '{print $1}')
    SEL_NAME=$(echo "$ACCOUNT_ROW" | awk '{print $2}')
    SEL_ID=$(echo "$ACCOUNT_ROW" | awk '{print $NF}')

    SELECTED_ROLE=$(${pkgs.jq}/bin/jq -r --arg org "$SEL_ORG" --arg id "$SEL_ID" '
        .[] | select(.org == $org and .account_id == $id) | .role_name
    ' "$INVENTORY" | ${pkgs.fzf}/bin/fzf --ansi --layout=default --prompt="Role for $SEL_NAME> " --height=20%)

    [ -z "$SELECTED_ROLE" ] && exit 0

    FINAL_PROFILE="$SEL_ORG/$SEL_NAME/$SELECTED_ROLE"

    echo "export AWS_PROFILE=\"$FINAL_PROFILE\""
    echo "export AWS_REGION=\"us-east-1\""
    echo "assume \"$FINAL_PROFILE\""
  '';
in
{
  home.packages = [
    _awsx
    pkgs.fzf
    pkgs.jq
    pkgs.granted
  ];

  programs.zsh = {
    enable = true;
    initExtra = ''
      awsx() {
        local result
        result=$(_awsx "$@")
        [ -n "$result" ] && eval "$result"
      }

      _awsx_completion() {
        if [ -f "$HOME/.aws/inventory.json" ]; then
          compadd $(${pkgs.jq}/bin/jq -r '.[] | "\(.org)/\(.account_name)/\(.role_name)"' "$HOME/.aws/inventory.json")
        fi
      }
      compdef _awsx_completion awsx
    '';
  };

  programs.fish = {
    enable = true;
    functions = {
      awsx = {
        description = "AWS Context Switcher";
        body = ''
          set -l result (_awsx $argv)
          if test -n "$result"
              printf "%s\n" $result | source
          end
        '';
      };
    };
    interactiveShellInit = ''
      complete -c awsx -f -a "(${pkgs.jq}/bin/jq -r '.[] | \"\(.org)/\(.account_name)/\(.role_name)\"' $HOME/.aws/inventory.json 2>/dev/null)"
    '';
  };
}
