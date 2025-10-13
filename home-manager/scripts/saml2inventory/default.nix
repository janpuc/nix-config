{
  pkgs,
  username,
  ...
}: {
  home = {
    packages = with pkgs; [
      (
        writeShellScriptBin "saml2inventory" ''
          #!/usr/bin/env bash

          op run --env-file=/Users/${username}/.aws/saml2aws/$1/.env -- saml2aws list-roles --skip-prompt 2>/dev/null | saml2yaml
        ''
      )
    ];
  };
}
