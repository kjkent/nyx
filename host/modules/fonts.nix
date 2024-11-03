{ pkgs, ... }:
{
  config = {
    fonts = {
      packages = with pkgs; [
        noto-fonts-emoji
        noto-fonts-cjk-sans
        font-awesome
        material-icons
      ];
    };
  };
}
