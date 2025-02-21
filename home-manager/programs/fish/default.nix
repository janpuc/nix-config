{pkgs, ...}: {
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting ""
      '';
      shellAbbrs = {
        g = "git";
      };
      shellAliases = {
        cat = "${pkgs.bat}/bin/bat --paging=never";
        less = "${pkgs.bat}/bin/bat";
        reload = "exec $SHELL -l";
        tree = "${pkgs.eza}/bin/eza --tree";
        awsu = "set -e AWS_PROFILE";
        unset = "set -e";
        unexport = "set -e";

        # banner = lib.mkIf isLinux "${pkgs.figlet}/bin/figlet";
        # banner-color = lib.mkIf isLinux "${pkgs.figlet}/bin/figlet $argv | ${pkgs.dotacat}/bin/dotacat";
        # brg = "${pkgs.bat-extras.batgrep}/bin/batgrep";
        # code = "codium";
        #clock = ''${pkgs.tty-clock}/bin/tty-clock -B -c -C 4 -f "%a, %d %b"'';
        # dadjoke = ''${pkgs.curlMinimal}/bin/curl --header "Accept: text/plain https://icanhazdadjoke.com/"'';
        # dmesg = "${pkgs.util-linux}/bin/dmesg --human --color=always";
        # neofetch = "${pkgs.fastfetch}/bin/fastfetch";
        #glow = "${pkgs.glow}/bin/glow --pager";
        # hr = ''${pkgs.hr}/bin/hr "─━"'';
        # htop = "${pkgs.bottom}/bin/btm --basic --tree --hide_table_gap --dot_marker --mem_as_value";
        # ip = lib.mkIf isLinux "${pkgs.iproute2}/bin/ip --color -brief";
        #lm = "${pkgs.lima-bin}/bin/limactl";
        # lolcat = "${pkgs.dotacat}/bin/dotacat";
        # moon = "${pkgs.curlMinimal}/bin/curl -s wttr.in/Moon";
        # more = "${pkgs.bat}/bin/bat";
        # parrot = "${pkgs.terminal-parrot}/bin/terminal-parrot -delay 50 -loops 7";
        # ruler = ''${pkgs.hr}/bin/hr "╭─³⁴⁵⁶⁷⁸─╮"'';
        # screenfetch = "${pkgs.fastfetch}/bin/fastfetch";
        # speedtest = "${pkgs.speedtest-go}/bin/speedtest-go";
        # store-path = "${pkgs.coreutils-full}/bin/readlink (${pkgs.which}/bin/which $argv)";
        # top = "${pkgs.bottom}/bin/btm --basic --tree --hide_table_gap --dot_marker --mem_as_value";
        # wormhole = "${pkgs.wormhole-william}/bin/wormhole-william";
        # weather = "${lib.getExe pkgs.girouette} --quiet";
        # weather-home = "${lib.getExe pkgs.girouette} --quiet --location Krakow";
        # where-am-i = "${pkgs.geoclue2}/libexec/geoclue-2.0/demos/where-am-i";
      };
    };
  };
}
