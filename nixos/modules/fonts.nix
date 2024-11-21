{pkgs, ...}: with pkgs; {
  config = {
    fonts = {
      packages = [
        noto-fonts-emoji
        noto-fonts-cjk-sans
        font-awesome
        material-icons
      ] ++ [
        (mkFontPkg "BerkeleyMono Nerd Font" {
          regular.source = ./BerkeleyMonoNF-Regular.ttf;
          italic.source = ./BerkeleyMonoNF-Italic.ttf;
          bold.source = ./BerkeleyMonoNF-Bold.ttf;
          boldItalic.source = ./BerkeleyMonoNF-BoldItalic.ttf;
        })
      ];
    };
  };
}
