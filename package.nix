{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
}: let
  pname = "hayase";
  version = "6.4.37";

  src = fetchurl {
    url = "https://github.com/hayase-app/docs/releases/download/v${version}/linux-hayase-${version}-linux.AppImage";
    hash = "3baa989487a08f3777cf3e3455402c24dc7c689f";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/hayase.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/hayase.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'

      install -Dm444 ${appimageContents}/hayase.png \
        $out/share/icons/hicolor/512x512/apps/hayase.png
    '';

    meta = with lib; {
      description = "Stream anime torrents instantly, real-time with no waiting for downloads to finish";
      homepage = "https://hayase.watch";
      license = licenses.bsl11;
      mainProgram = "hayase";
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
  }
