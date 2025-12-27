{ ... }:
{
  programs = {
    difftastic = {
      enable = true;
      git = {
        enable = true;
      };
      options = {
        display = "side-by-side-show-both";
      };
    };
  };
}
