# {
#   lib,
#   config,
#   user,
#   ...
# }:
# let
#   sshPub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKxcKV1Iao/IzHzbHUGaUKocgDR6WG3w5SA64U6cd8Nk";
# in
# {
#   # `programs.git` will generate the config file: ~/.config/git/config
#   # to make git use this config file, `~/.gitconfig` should not exist!
#   #
#   #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
#   # home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
#   #   rm -f ~/.gitconfig
#   # '';

#   home.file.".ssh/allowed_signers".text = "${user.email} ${sshPub}\n";

#   programs.gh = {
#     enable = true;
#     settings = {
#       git_protocol = "ssh";
#     };
#   };

#   programs.git = {
#     enable = true;
#     userName = user.github;
#     userEmail = user.email;
#     lfs = {
#       enable = true;
#     };

#     signing = {
#       key = sshPub;
#       signByDefault = true;
#     };

#     extraConfig = {
#       gpg = {
#         format = "ssh";

#         ssh = {
#           allowedSignersFile = "~/.ssh/allowed_signers";
#           program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
#         };
#       };

#       commit = {
#         gpgsign = true;
#       };

#       tag = {
#         gpgsign = true;
#         forceSignAnnotated = true;
#       };

#       core = {
#         autocrlf = "input";
#         editor = "nvim";
#         eol = "lf";
#       };

#       fetch = {
#         prune = true;
#         pruneTags = true;
#       };

#       pull = {
#         rebase = true;
#       };

#       rebase = {
#         autoStash = true;
#       };

#       init = {
#         defaultBranch = "main";
#       };

#       push = {
#         autoSetupRemote = true;
#       };

#       difftool = {
#         prompt = false;
#         vscode.cmd = "code -dnw --diff --new-window --wait $LOCAL $REMOTE";
#       };

#       diff = {
#         tool = "vscode";
#       };

#       mergetool = {
#         prompt = false;
#         vscode.cmd = "code --merge --new-window --wait $REMOTE $LOCAL $BASE $MERGED";
#       };

#       merge = {
#         tool = "vscode";
#         trustExitCode = true;
#       };
#     };

#     aliases = {
#       # common aliases
#       a = "add -A";
#       br = "branch";
#       co = "checkout";
#       st = "status";
#       c = "commit";
#       cm = "commit -m";
#       ca = "commit -am";
#       p = "push";
#       d = "diff";
#       dc = "diff --cached";
#       ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
#       ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
#       amend = "commit --amend -m";

#       # aliases for submodule
#       update = "submodule update --init --recursive";
#       foreach = "submodule foreach";
#     };

#     ignores = [
#       # nix
#       "/.direnv/"
#       "/.devenv/"
#       ".envrc"
#       ".env"
#       "/result"
#       # mac
#       ".DS_Store"
#       ".AppleDouble"
#       ".LSOverride"
#       "Icon"
#       "._*"
#       ".DocumentRevisions-V100"
#       ".fseventsd"
#       ".Spotlight-V100"
#       ".TemporaryItems"
#       ".Trashes"
#       ".VolumeIcon.icsn"
#       "com.apple.timemachine.donotpresent"
#       ".AppleDB"
#       ".AppleDesktop"
#       "Network Trash Folder"
#       "Temporary Items"
#       ".apdisk"
#       "*.icloud"
#       # linux
#       "*~"
#       ".fuse_hidden*"
#       ".directory"
#       ".Trash-*"
#       ".nfs*"
#       # windows
#       "Thumbs.db"
#       "Thumbs.db:encryptable"
#       "ehthumbs.db"
#       "ehthumbs_vista.db"
#       "*.stackdump"
#       "[Dd]esktop.ini"
#       # vscode
#       ".vscode/*"
#       "!.vscode/settings.json"
#       "!.vscode/tasks.json"
#       "!.vscode/launch.json"
#       "!.vscode/extensions.json"
#       "!.vscode/*.code-snippets"
#     ];
#   };
# }
