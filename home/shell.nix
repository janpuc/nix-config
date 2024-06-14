{...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    # bashrcExtra = ''
    #   export PATH="$PATH:$HOME/bin:$HOME/.local/bin"
    # '';
    envExtra = ''
      export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
    '';

    zsh-abbr = {
      enable = true;

      abbreviations = {
        f = "flux";
      };
    };
  };

  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };

  home.shellAliases = {
    reload = "exec $SHELL -l";

    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    "......" = "cd ../../../../..";

    egrep = "grep -E";
    fgrep = "grep -F";

    du = "du -c";
    dud = "du -d 1 -h";
    duf = "du -sh *";
    h = "history";
    sortnr = "sort -n -r";
    unexport = "unset";
    rm = "rm -i";
    cp = "cp -i";
    mv = "mv -i";

    cat = "bat -pp";
    less = "bat --paging=always";

    code = "codium";

    k = "kubectl";
    kx = "kubectx";
    ku = "kubectx -u";
  };
}
