{ config, pkgs, ... }:
let
  generateFontPackage = font: pkgs.stdenv.mkDerivation {
    pname = font.fontFamily;
    version = "1.0.0";

    src = font.src;

    installPhase = with font; ''
      # Create a directory for the font family
      mkdir -p $out/share/fonts/ttf/${fontFamily}

      # Copy the specified font file
      cp ${src} $out/share/fonts/ttf/${fontFamily}/${fontFamily}-${variant}.ttf

      # Set appropriate permissions
      chmod 644 $out/share/fonts/truetype/${fontFamily}/*
    '';

    meta = with pkgs.lib; {
      description = "Font package for ${font.fontFamily}";
      platforms = platforms.all;
    };
  };
in {
  options = {
    fonts.customFonts = with pkgs.lib.types; listOf (attrsOf str);
  };

  config = let
    # Create packages for each custom font
    fontPackages = map generateFontPackage config.fonts.customFonts;
  in {
    # Add generated font packages to systemPackages
    environment.systemPackages = fontPackages;
  };
}

