{
  config,
  pkgs,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      #ardour           # audio editing software
      alsa-utils
      audacity
      easyeffects
      ffmpeg
      imv
      mpv
      pavucontrol
      playerctl
      spotify
      vlc
    ];

    nixpkgs.overlays = [
      (
        _post: pre:
          with pre; let
            spotx = fetchFromGitHub {
              owner = "SpotX-Official";
              repo = "SpotX-Bash";
              rev = "d38a66e98dfa1289b4c0752ef40488aac07c9484";
              hash = "sha256-k04RQzP7+RGgtQyvuKiFCFBARynYWrGSYdgCMCvTpc0=";
            };
          in {
            spotify = spotify.overrideAttrs (pkg: {
              buildInputs = [perl unzip zip];
              postInstall =
                (pkg.postInstall or "")
                + ''
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
