{ hostname, user, ... }:
{
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  users.users."${user}" = {
    home = "/Users/${user}";
    description = user;
  };

  nix.settings.trusted-users = [ user ];
}
