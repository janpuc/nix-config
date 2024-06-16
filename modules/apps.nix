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
      # "keepingyouawake" # don't need it for now
      "messenger"
      "microsoft-teams"
    ];
  };
}
