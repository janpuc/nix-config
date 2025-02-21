{...}: {
  programs = {
    powerline-go = {
      enable = true;
      settings = {
        cwd-max-depth = 5;
        cwd-max-dir-size = 12;
        theme = "gruvbox";
        max-width = 60;
      };
    };
  };
}
