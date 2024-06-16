{
  hostname,
  user,
  ...
}: {
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  users.users."${user.name}" = {
    home = "/Users/${user.name}";
    description = user.name;
  };

  nix.settings.trusted-users = [user.name];
}
