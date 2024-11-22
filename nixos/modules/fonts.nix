{pkgs, self, ...}: with pkgs; {
  config = {
    fonts = {
      packages = [
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
