{pkgs, self, ...}: with pkgs; {
  config = {
    fonts = {
      enableDefaultPackages = true;
      fontconfig = {
        defaultFonts = {
          emoji = [ "Blobmoji" "Noto Color Emoji" ];
        };
      };
      packages = with pkgs; [
        noto-fonts-emoji-blob-bin
        noto-fonts-emoji
        noto-fonts-cjk-sans
        font-awesome
        material-icons

        (mkFontPkg "Berkeley Mono (inc Nerd Fonts)" {
          source = "${self}/assets/fonts/berkeleymono.gitcrypt.tar.xz";
        })
      ];
    };
  };
}
