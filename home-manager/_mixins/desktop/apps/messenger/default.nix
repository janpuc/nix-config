{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      (brewCasks.messenger.overrideAttrs (o: {
        src = pkgs.fetchurl {
          url = builtins.head o.src.urls;
          hash = "sha256-4gtIYqYYqOGL9rTzwX86JRx0TCrqC6skCWmpclUeczc=";
        };
      }))
    ];
  };
}
