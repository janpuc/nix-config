{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      (writeShellScriptBin {
        name = "awsx";
        text = import ./awsx.sh;
      })
    ];
  };
}
