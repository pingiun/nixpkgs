{ stdenv
, buildPythonPackage
, fetchPypi
, python
}:
buildPythonPackage rec {
  pname = "plac";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c16cfa7422a76b7525fc93d0be5c9c9a2d5250083e80ddac6621edb395dc081";
  };

  checkPhase = ''
      cd doc
      ${python.interpreter} -m unittest discover -p "*test_plac*"
    '';
  
  meta = with stdenv.lib; {
    description = "Parsing the Command Line the Easy Way";
    homepage = https://github.com/micheles/plac;
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ sdll ];
    };
}
