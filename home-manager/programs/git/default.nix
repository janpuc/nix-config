{ ... }:
{
  programs = {
    git = {
      enable = true;
      settings = {
        aliases = {
          a = "add -A";
          br = "branch";
          c = "commit";
          cm = "commit -m";
          ca = "commit -am";
          cl = "clone";
          co = "checkout";
          st = "status";
          p = "push";
          pu = "pull";
          d = "diff";
          dc = "diff --cached";
          dlog = "!f() { GIT_EXTERNAL_DIFF=difft git log -p --ext-diff $@ }; f";
          dshow = "!f() { GIT_EXTERNAL_DIFF=difft git show --ext-diff $@ }; f";
          fucked = "reset --hard";
          graph = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        };
        advice = {
          statusHints = false;
        };
        color = {
          branch = false;
          diff = false;
          interactive = true;
          log = false;
          status = true;
          ui = false;
        };
        commit = {
          gpgsign = true;
        };
        core = {
          autocrlf = "input";
          editor = "nano";
          eol = "lf";
          pager = "bat";
        };
        fetch = {
          prune = true;
          pruneTags = true;
        };
        gpg = {
          format = "ssh";
          ssh = {
            program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          };
        };
        push = {
          autoSetupRemote = true;
          default = "matching";
        };
        pull = {
          rebase = true;
        };
        init = {
          defaultBranch = "main";
        };
        rebase = {
          autoStash = true;
        };
        tag = {
          gpgsign = true;
          forceSignAnnotated = true;
        };
        user = {
          name = "janpuc";
          email = "janpuc@proton.me";
        };
      };
      ignores = [
        "*.log"
        "*.out"
        ".DS_Store"
        "bin/"
        "dist/"
        "result"
      ];
      signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKxcKV1Iao/IzHzbHUGaUKocgDR6WG3w5SA64U6cd8Nk";
        signByDefault = true;
      };
    };
  };
}
