{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      (brewCasks.steam.overrideAttrs (o: {
        src = pkgs.fetchurl {
          url = builtins.head o.src.urls;
          hash = "sha256-X1VnDJGv02A6ihDYKhedqQdE/KmPAQZkeJHudA6oS6M=";
        };
      }))
    ];
  };
}
