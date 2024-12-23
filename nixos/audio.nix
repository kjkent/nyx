{ config, pkgs, ... }:
{
  config = {
    boot = {
      extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      kernelModules = [ "v4l2loopback" ];
    };

    environment.systemPackages = with pkgs; [
      ardour
      audacity
      easyeffects
      ffmpeg
      imv
      mpv
      pavucontrol
      playerctl
      spotify
      v4l-utils
      vlc
    ];

    hardware.pulseaudio.enable = false;

    nixpkgs.overlays = [
      (post: pre: with pre; let
        spotx = fetchFromGitHub {
          owner = "SpotX-Official";
          repo = "SpotX-Bash";
          rev = "fa0ea870b878fa38d6aa33d61d4191d3854d0e71";
          hash = "sha256-/KGH8pKG2KNfo8m49bEk0PKYAS21YdCVUeMHunZH4fA=";
        };
        in {
          spotify = spotify.overrideAttrs (pkg: {
            buildInputs = [perl unzip zip];
            postInstall = (pkg.postInstall or "") + ''
              bash ${spotx}/spotx.sh -P $out/share/spotify/ -c
            '';
          });
        }
      )
    ];

    programs = {
      dconf.enable = true;
    };

    services = {
      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };
    };
  };
}
