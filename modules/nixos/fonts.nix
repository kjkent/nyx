{ assetsPath, pkgs, ... }:
with pkgs;
{
  config = {
    nixpkgs.overlays = [
      (_: _: {
        nyx-berkeley-mono = mkFontPkg "Berkeley Mono (inc Nerd Fonts)" {
          source = "${assetsPath}/fonts/berkeley-mono.gitcrypt.tar.xz";
        };
      })
    ];
    fonts = {
      fontDir.enable = true; # Links all fonts to /run/current-system/sw/share/X11/fonts
      enableDefaultPackages = true;
      fontconfig = {
        defaultFonts = {
          emoji = [
            "Blobmoji"
            "Noto Color Emoji"
          ];
          monospace = [
            "Berkeley Mono"
            "BerkeleyMono Nerd Font"
          ];
        };
      };
      packages = [
        noto-fonts-emoji-blob-bin
        noto-fonts-emoji
        noto-fonts-cjk-sans
        font-awesome
        material-icons
        nyx-berkeley-mono
      ];
    };
  };
}
