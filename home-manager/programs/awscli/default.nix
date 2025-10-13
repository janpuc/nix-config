{username, ...}: let
  vault = "Work";
in {
  programs = {
    awscli = {
      enable = true;
    };
  };

  # home.file.".saml2aws".text = ''
  #   [default]
  #   name                    = default
  #   provider                = Okta
  #   mfa                     = TOTP
  #   skip_verify             = false
  #   aws_urn                 = urn:amazon:webservices
  #   aws_session_duration    = 3600
  #   saml_cache              = true
  #   disable_remember_device = false
  #   disable_sessions        = false
  # '';

  # home.file.".aws/saml2aws/DSC/.env".text = ''
  #   SAML2AWS_USERNAME="op://${vault}/WBD/username"
  #   SAML2AWS_PASSWORD="op://${vault}/WBD/password"
  #   SAML2AWS_MFA_TOKEN="op://${vault}/WBD/one-time password?attribute=otp"
  #   SAML2AWS_URL="op://${vault}/AWS/DSC"
  #   SAML2AWS_SAML_CACHE_FILE="/Users/${username}/.aws/saml2aws/DSC/cache"
  # '';

  # home.file.".aws/saml2aws/DTC/.env".text = ''
  #   SAML2AWS_USERNAME="op://${vault}/WBD/username"
  #   SAML2AWS_PASSWORD="op://${vault}/WBD/password"
  #   SAML2AWS_MFA_TOKEN="op://${vault}/WBD/one-time password?attribute=otp"
  #   SAML2AWS_URL="op://${vault}/AWS/DTC"
  #   SAML2AWS_SAML_CACHE_FILE="/Users/${username}/.aws/saml2aws/DTC/cache"
  # '';

  # home.file.".aws/saml2aws/WB/.env".text = ''
  #   SAML2AWS_USERNAME="op://${vault}/WBD/username"
  #   SAML2AWS_PASSWORD="op://${vault}/WBD/password"
  #   SAML2AWS_MFA_TOKEN="op://${vault}/WBD/one-time password?attribute=otp"
  #   SAML2AWS_URL="op://${vault}/AWS/WB"
  #   SAML2AWS_SAML_CACHE_FILE="/Users/${username}/.aws/saml2aws/WB/cache"
  # '';
}
