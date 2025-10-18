{ ... }:
{
  programs = {
    starship = {
      enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;

      enableTransience = true;

      settings = {
        add_newline = true;
      };
    };
  };
}
