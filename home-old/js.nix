# { lib, user, ... }:
# {
#   home.file.".npmrc".text = lib.generators.toINIWithGlobalSection { } {
#     globalSection = {
#       prefix = "/Users/${user.name}/.npm-packages";
#     };
#   };
# }
