{ lib, stdenv, fetchFromGitHub, cmake
, zlib, boost, openssl, python, ncurses, SystemConfiguration
}:

let
  version = "2.0.5";

  # Make sure we override python, so the correct version is chosen
  boostPython = boost.override { enablePython = true; inherit python; };

in stdenv.mkDerivation {
  pname = "libtorrent-rasterbar";
  inherit version;

  src = fetchFromGitHub {
    owner = "arvidn";
    repo = "libtorrent";
    rev = "61ab0eb94fcf2f5cb0253312ae9515dd84ba26a1";
    sha256 = "sha256-T32QLQ2TL83r7h4e4VqOUVs/ItWyUcTlik5VD9uX35Y=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boostPython openssl zlib python ncurses ]
    ++ lib.optionals stdenv.isDarwin [ SystemConfiguration ];

  postInstall = ''
    moveToOutput "include" "$dev"
    moveToOutput "lib/${python.libPrefix}" "$python"
  '';

  outputs = [ "out" "dev" "python" ];

  cmakeFlags = [
    "-Dpython-bindings=on" "-Dwebtorrent=on"
  ];

  meta = with lib; {
    homepage = "https://libtorrent.org/";
    description = "A C++ BitTorrent implementation focusing on efficiency and scalability";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
