{ pkgs, ... }:

let
  _kubectx = pkgs.writeShellScriptBin "_kubectx" ''
    K8S_INV="$HOME/.kube/inventory.json"
    KUBE_CLUSTER_DIR="$HOME/.kube/clusters"

    if [ ! -f "$K8S_INV" ]; then
        echo "echo 'Error: Inventory missing. Run k8s-sync first.'"
        exit 1
    fi

    if [[ "$1" == "-u" ]]; then
        echo "unset KUBECONFIG"
        echo "unset AWS_PROFILE"
        echo "echo '✘ Context unset.'"
        exit 0
    fi

    if [[ -n "$1" ]]; then
        MATCH=$(${pkgs.jq}/bin/jq -r --arg input "$1" '.[] | select(.cluster_name == $input)' "$K8S_INV")
        if [[ -z "$MATCH" ]]; then
            echo "echo 'Error: Cluster \"$1\" not found in inventory.'"
            exit 1
        fi
    else
        SELECTED_ROW=$(${pkgs.jq}/bin/jq -r '
            .[] | "\(.cluster_name) | \(.account_name) | \(.account_id)"
        ' "$K8S_INV" | sort | ${pkgs.util-linux}/bin/column -t -s '|' | ${pkgs.fzf}/bin/fzf \
            --ansi --prompt="Cluster> " --height=40% --layout=default)

        [ -z "$SELECTED_ROW" ] && exit 0

        CLUSTER_NAME=$(echo "$SELECTED_ROW" | awk '{print $1}')
        MATCH=$(${pkgs.jq}/bin/jq -r --arg name "$CLUSTER_NAME" '.[] | select(.cluster_name == $name)' "$K8S_INV")
    fi

    FIN_CLUSTER=$(echo "$MATCH" | ${pkgs.jq}/bin/jq -r '.cluster_name')
    FIN_PROFILE=$(echo "$MATCH" | ${pkgs.jq}/bin/jq -r '.aws_profile')
    KUBE_PATH="$KUBE_CLUSTER_DIR/''${FIN_CLUSTER}.yaml"

    if [ ! -f "$KUBE_PATH" ]; then
        echo "echo 'Error: Kubeconfig file not found at $KUBE_PATH. Run k8s-sync again.'"
        exit 1
    fi

    echo "export KUBECONFIG=\"$KUBE_PATH\""
    echo "export AWS_PROFILE=\"$FIN_PROFILE\""
    echo "echo '✔ Context: $FIN_CLUSTER ($FIN_PROFILE)'"
    echo "assume \"$FIN_PROFILE\""
  '';
in
{
  home.packages = [
    _kubectx
    pkgs.fzf
    pkgs.jq
    pkgs.util-linux
    pkgs.granted
  ];

  programs.zsh.initExtra = ''
    kubectx() {
      local result
      result=$(_kubectx "$@")
      [ -n "$result" ] && eval "$result"
    }

    _kubectx_completion() {
      if [ -f "$HOME/.kube/inventory.json" ]; then
        compadd $(${pkgs.jq}/bin/jq -r '.[] | .cluster_name' "$HOME/.kube/inventory.json")
      fi
    }
    compdef _kubectx_completion kubectx
  '';

  programs.fish = {
    enable = true;
    functions.kubectx = {
      description = "Kubernetes Context Switcher";
      body = ''
        set -l result (_kubectx $argv)
        if test -n "$result"
            printf "%s\n" $result | source
        end
      '';
    };
    interactiveShellInit = ''
      complete -c kubectx -f -a "(${pkgs.jq}/bin/jq -r '.[] | .cluster_name' $HOME/.kube/inventory.json 2>/dev/null)"
    '';
  };
}
