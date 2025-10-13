{...}: {
  programs = {
    aria2 = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      daemon = {
        enable = true;
      };

      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "https://api.atuin.sh";
        search_mode = "prefix";
      };

      # themes = {};
    };
  };
}
