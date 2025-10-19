{
  config,
  lib,
  pkgs,
  ...
}:
let
  op = lib.getExe pkgs._1password-cli;
  vault = "Kubernetes";
  yaml = pkgs.formats.yaml { };
in
{
  home = {
    activation.kubeconfigInjectSecrets = lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" ] ''
      set -e
      set -o pipefail
      ${op} account list | grep "my.1password.com"
      ${op} inject -i "${config.home.homeDirectory}/.kube/tpl/config.tpl" -o "${config.home.homeDirectory}/.kube/config" --force
    '';
    file = {
      "${config.home.homeDirectory}/.kube/tpl/config.tpl" = {
        source = yaml.generate "kubeconfig.yaml" {
          apiVersion = "v1";
          kind = "Config";
          clusters = [
            {
              name = "aether";
              cluster = {
                server = "op://${vault}/kubeconfig-aether/server";
                "certificate-authority-data" = "op://${vault}/kubeconfig-aether/certificate_authority_data";
              };
            }
            {
              name = "gaia";
              cluster = {
                server = "op://${vault}/kubeconfig-gaia/server";
                "certificate-authority-data" = "op://${vault}/kubeconfig-gaia/certificate_authority_data";
              };
            }
          ];
          contexts = [
            {
              name = "aether";
              context = {
                cluster = "aether";
                user = "aether";
              };
            }
            {
              name = "gaia";
              context = {
                cluster = "gaia";
                user = "gaia";
              };
            }
          ];
          "current-context" = "";
          users = [
            {
              name = "aether";
              user = {
                "client-certificate-data" = "op://${vault}/kubeconfig-aether/client_certificate_data";
                "client-key-data" = "op://${vault}/kubeconfig-aether/client_key_data";
              };
            }
            {
              name = "gaia";
              user = {
                "client-certificate-data" = "op://${vault}/kubeconfig-gaia/client_certificate_data";
                "client-key-data" = "op://${vault}/kubeconfig-gaia/client_key_data";
              };
            }
          ];
        };
      };
    };
  };
}
