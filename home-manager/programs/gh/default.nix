{ pkgs, ... }:
{
  programs = {
    gh = {
      enable = true;
      extensions = with pkgs; [
        gh-dash
        gh-markdown-preview
      ];
      settings = {
        editor = "nano";
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };
  };
}
