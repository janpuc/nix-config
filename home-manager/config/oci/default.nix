{ ... }:
let
  vault = "Private";
in
{
  home.file.".config/oci/op.env".text = ''
    OCI_CLI_KEY_CONTENT="op://${vault}/oci_api_key/private key"
    OCI_CLI_FINGERPRINT="op://${vault}/oci/fingerprint"
    OCI_CLI_TENANCY="op://${vault}/oci/tenancy"
    OCI_CLI_USER="op://${vault}/oci/user"
    OCI_CLI_REGION="op://${vault}/oci/region"
  '';

  # home.file.".config/oci/config.tpl".text = ''
  #   [DEFAULT]
  #   user=
  #   fingerprint=
  #   key_file=
  #   tenancy=
  #   region=
  # '';

  # home.activation.ociInjectSecrets = lib.hm.dag.entryAfter ["writeBoundary" "installPackages"] ''
  #   set -e
  #   set -o pipefail
  #   ${lib.getExe pkgs._1password-cli} account list | grep "my.1password.com"
  # '';
}
