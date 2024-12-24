{ assetsPath, pkgs, ... }:
with pkgs;
{
  config = {
    # Allows bat/less to print unicode glyphs (https://github.com/sharkdp/bat/issues/2578#issuecomment-1598332705)
    environment.sessionVariables.LESSUTFCHARDEF = "E000-F8FF:p,F0000-FFFFD:p,100000-10FFFD:p";
    nixpkgs.overlays = [
      (_: _: {
        berkeley-mono = mkFontPkg "Berkeley Mono (inc Nerd Fonts)" {
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
        berkeley-mono
        font-awesome
        material-icons
        noto-fonts-emoji-blob-bin
        noto-fonts-emoji
        noto-fonts-cjk-sans
      ];
    };
  };
}
