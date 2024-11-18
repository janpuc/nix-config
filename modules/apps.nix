{pkgs, ...}: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    casks = [
      "1password"
      "arc"
      "orbstack"
      "obsidian"
      "whisky"
      "messenger"
      "microsoft-teams"
      "microsoft-auto-update"
      "steam"
    ];
  };
}
