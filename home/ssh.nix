{ ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
    # matchBlocks = {
    #   "github.com" = {
    #     hostname = "github.com";
    #     user = "git";
    #     forwardAgent = false;
    #     extraOptions = {
    #       preferredAuthentications = "publickeys";
    #     };
    #   };
    # };
  };
}
