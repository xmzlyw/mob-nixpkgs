{
  inputs = {
    dream2nix.url =
      "github:tinybeachthor/dream2nix/fix-nodejs-link-direct-bins";
    src.url = "github:ether/etherpad-lite/develop";
    src.flake = false;
  };
  outputs = { self, dream2nix, src }@inputs:
    (dream2nix.lib.makeFlakeOutputs {
      systems = [ "x86_64-linux" ];
      config.projectRoot = ./.;
      packageOverrides = { 
      };
      source = "${src}/src";
      packageOverrides = {
        # name of the package
        "ep_etherpad-lite" = {
          # name the override
          add-pre-build-steps = {
            # override attributes
            postBuild = ''
              echo | pwd
              echo | dir
              find . -name "AbsolutePaths.js" -type f
              substituteInPlace node/utils/AbsolutePaths.js \
                --replace "if ((maybeEtherpadRoot === false) && (process.platform === 'win32')) {" "if ((maybeEtherpadRoot === false) && (process.platform === 'linux')) {" 
              '';
            # update attributes
            #buildInputs = old: old ++ [pkgs.hello];
          };
        };
      };
    }) // {
#      nixosModules.etherpad = { config, lib, pkgs }: {
#        options.services.etherpad = {
#          enable = mkEnableOption "Enable etherpad server";
#          statePath = mkOption {
#            default = "/var/lib/etherpad";
#            description =
#              "Folder to store runtime data (Database, uploads, etc)";
#            type = types.str;
#          };
#          config = mkOption {
#            default = "";
#            description = "Etherpad configuration";
#          };
#        };
# 
#        config = mkIf cfg.enable {
#          systemd.tmpfile.rules = [
# 
#          ];
# 
#        config = { };
#      };
    };
}
