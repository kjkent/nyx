{
  config,
  lib,
  nixosUser,
  pkgs,
  ...
}: {
  options = with lib; {
    virtualisation.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable virtualisation configuration.";
    };
  };

  config = lib.mkIf config.virtualisation.enable {
    environment.systemPackages = with pkgs; [
      virt-viewer
    ];
    programs = {
      virt-manager.enable = true;
      dconf.profiles.user.databases = [
        {
          settings = {
            "org/virt-manager/virt-manager/connections" = {
              autoconnect = ["qemu:///system"];
              uris = ["qemu:///system"];
            };
          };
        }
      ];
    };

    users.users.${nixosUser.username}.extraGroups = ["kvm" "libvirtd" "render"];

    virtualisation = {
      libvirtd.enable = true;
      podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      docker = {
        enable = true;
        # rootless = {   # Maybe another time... See: https://github.com/moby/moby/issues/43019
        #   enable = true;
        #   setSocketVariable = true;
        # };
      };
    };
  };
}
