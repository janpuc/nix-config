{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git
  ];

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
      "keepingyouawake"
      "messenger"
      "microsoft-teams"
    ];
  };
}
