{ lib
, fetchurl
, fetchpatch
, intltool
, libtorrent-rasterbar
, pythonPackages
, gtk3
, glib
, gobject-introspection
, librsvg
, wrapGAppsHook
, fetchFromGitHub
}:

let
libtorrent-rasterbar-master = libtorrent-rasterbar.overrideAttrs (old: {
  version = "master";
  src = fetchFromGitHub {
    owner = "arvidn";
    repo = "libtorrent";
    rev = "61ab0eb94fcf2f5cb0253312ae9515dd84ba26a1";
    sha256 = "sha256-T32QLQ2TL83r7h4e4VqOUVs/ItWyUcTlik5VD9uX35Y=";
    fetchSubmodules = true;
  };
  cmakeFlags = old.cmakeFlags ++ [
    "-Dwebtorrent=on"
  ];
});
in

pythonPackages.buildPythonPackage rec {
  pname = "deluge";
  version = "2.0.5";

  src = fetchurl {
    url = "http://download.deluge-torrent.org/source/2.0/${pname}-${version}.tar.xz";
    sha256 = "sha256-xL0Eq/0hG2Uhi+A/PEbSb0QCSITeEOAYWfuFb91vJdg=";
  };

  propagatedBuildInputs = with pythonPackages; [
    twisted
    Mako
    chardet
    pyxdg
    pyopenssl
    service-identity
    libtorrent-rasterbar-master.dev
    libtorrent-rasterbar-master.python
    setuptools
    setproctitle
    pillow
    rencode
    six
    zope_interface
    dbus-python
    pygobject3
    pycairo
    gtk3
    gobject-introspection
    librsvg
  ];

  nativeBuildInputs = [ intltool wrapGAppsHook glib ];

  checkInputs = with pythonPackages; [
    pytestCheckHook
    pytest-twisted
    pytest-cov
    mock
    mccabe
    pylint
  ];

  doCheck = false; # until pytest-twisted is packaged

  postInstall = ''
    mkdir -p $out/share
    cp -R deluge/ui/data/{icons,pixmaps} $out/share/
    install -Dm444 -t $out/share/applications deluge/ui/data/share/applications/deluge.desktop
  '';

  meta = with lib; {
    homepage = "https://deluge-torrent.org";
    description = "Torrent client";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ domenkozar ebzzry ];
    platforms = platforms.all;
  };
}
