{pkgs, ...}: let
in {
  home = {
    packages = with pkgs; [
      (
        writeShellScriptBin "saml2yaml" ''
          #!/usr/bin/env bash

          echo "inventory:"

          account_id=""
          account_alias=""
          roles=()

          output_account() {
            echo "  - id: $account_id"
            if [[ -n "$account_alias" ]]; then
              echo "    alias: $account_alias"
            fi
            echo "    roles:"
            for role in "''${roles[@]}"; do
              echo "      - $role"
            done
          }

          while IFS= read -r line; do
            if [[ "$line" =~ ^Account:\ ([^[:space:]]+)[[:space:]]+\(([0-9]+)\)$ ]]; then
              if [[ -n "$account_id" ]]; then
                output_account
              fi
              account_alias="''${BASH_REMATCH[1]}"
              account_id="''${BASH_REMATCH[2]}"
              roles=()

            elif [[ "$line" =~ ^Account:\ ([0-9]+)$ ]]; then
              if [[ -n "$account_id" ]]; then
                output_account
              fi
              account_id="''${BASH_REMATCH[1]}"
              account_alias=""
              roles=()

            elif [[ "$line" =~ ^arn:aws:iam::[0-9]+:role/(.+)$ ]]; then
              roles+=("''${BASH_REMATCH[1]}")
            fi
          done

          if [[ -n "$account_id" ]]; then
            output_account
          fi
        ''
      )
    ];
  };
}
