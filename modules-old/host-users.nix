# {
#   hostname,
#   user,
#   pkgs,
#   ...
# }:
# {
#   networking.hostName = hostname;
#   networking.computerName = hostname;
#   networking.knownNetworkServices = [
#     "Wi-Fi"
#     "USB 10/100/1000 LAN"
#   ];
#   system.defaults.smb.NetBIOSName = hostname;

#   users.users."${user.name}" = {
#     home = "/Users/${user.name}";
#     description = user.name;
#     shell = pkgs.fish;
#   };

#   nix.settings.trusted-users = [ user.name ];
# }
