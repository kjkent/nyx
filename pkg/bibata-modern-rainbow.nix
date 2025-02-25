{
  pkgs,
  stdenv,
  ...
}:
stdenv.mkDerivation rec {
  pname = "bibata-modern-rainbow";
  version = "1.1.2";

  src = pkgs.fetchzip {
    url = "https://github.com/ful1e5/Bibata_Cursor_Rainbow/releases/download/v${version}/Bibata-Rainbow-Modern.tar.gz";
    hash = "sha256-Ps+IKPwQoRwO9Mqxwc/1nHhdBT2R25IoeHLKe48uHB8=";
  };

  installPhase = ''
    runHook preInstall

    install -dm 0755 "$out/share/icons/Bibata-Modern-Rainbow"
    cp -rf ./* "$out/share/icons/Bibata-Modern-Rainbow/"

    runHook postInstall
  '';
}
