{ ... }:
{
  programs = {
    atuin = {
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
        sync_address = "https://atuin.janpuc.com";
        search_mode = "prefix";
      };
    };
  };
}
