{
  assetsPath,
  config,
  pkgs,
  ...
}:
with pkgs; {
  config = {
    # Allows bat/less to print unicode glyphs (https://github.com/sharkdp/bat/issues/2578#issuecomment-1598332705)
    environment.sessionVariables.LESSUTFCHARDEF = "E000-F8FF:p,F0000-FFFFD:p,100000-10FFFD:p";

    nixpkgs.overlays = [
      (_: _: {
        berkeley-mono = mkFontPkg "Berkeley Mono (v2.002)" {
          source = ../assets/fonts/berkeley-mono.gitcrypt.tar.xz; 
        };
      })
      (_: _: {
        ms-fonts = mkFontPkg "MS fonts" {
          source = ../assets/fonts/ms.gitcrypt.tar.xz; 
        };
      })
      (_: _: {
        symbols-nerd-font = mkFontPkg "Nerd Fonts icons" {
          source = ../assets/fonts/symbols-nerd-font.gitcrypt.tar.xz; 
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
            "Symbols Nerd Font"
          ];
        };
      };
      packages = [
        berkeley-mono
        font-awesome
        material-icons
        ms-fonts
        noto-fonts-emoji-blob-bin
        noto-fonts-emoji
        noto-fonts-cjk-sans
        symbols-nerd-font 
      ];
    };
  };
}
