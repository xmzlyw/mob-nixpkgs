{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.digitalbitbox;
in

{
  options.hardware.digitalbitbox = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enables udev rules for Digital Bitbox devices.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.digitalbitbox;
      defaultText = literalExpression "pkgs.digitalbitbox";
      description = lib.mdDoc "The Digital Bitbox package to use. This can be used to install a package with udev rules that differ from the defaults.";
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ cfg.package ];
  };
}
