{
  config,
  pkgs,
  ...
}: let
  # Stream raw feed from dSLR to virtual cam using, e.g:
  # gphoto2 --stdout autofocusdrive=1 --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video2
  dSlr = {
    enable = false;
    name = "SLR";
  };
in {
  config = {
    environment.systemPackages = with pkgs;
      [
        (wrapOBS {
          plugins = with obs-studio-plugins; [
          ];
        })
        v4l-utils
      ]
      ++ (
        if dSlr.enable
        then [
          ffmpeg
          gphoto2
        ]
        else []
      );

    boot = {
      extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
      extraModprobeConfig =
        if dSlr.enable
        then ''
          options v4l2loopback devices=2 video_nr=1,2 card_label="OBS Cam, ${dSlr.name}" exclusive_caps=1
        ''
        else ''
          options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
        '';
      kernelModules = ["v4l2loopback"];
    };

    security.polkit.enable = true;
  };
}
