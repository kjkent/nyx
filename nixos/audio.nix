{
  config,
  pkgs,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      #ardour           # audio editing software
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
              rev = "e0fd4704b043941b4ddc0f24bc2b7614a6db23f1";
              hash = "sha256-C5YUPvnjkRS3tcZwrGKKtQkmmvX7fvh9zQt8a+0nc74=";
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
