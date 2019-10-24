{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
, pytest-flake8
, glibcLocales
, packaging
, isPy27
, backports_os
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "path.py";
  version = "12.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f2169633403aa0423f6ec000e8701dd1819526c62465f5043952f92527fea0f";
  };

  checkInputs = [ pytest pytest-flake8 glibcLocales packaging ];
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [
    importlib-metadata
  ] ++ lib.optional isPy27 backports_os
  ;

  LC_ALL = "en_US.UTF-8";

  meta = {
    description = "A module wrapper for os.path";
    homepage = https://github.com/jaraco/path.py;
    license = lib.licenses.mit;
  };

  checkPhase = ''
    # ignore performance test which may fail when the system is under load
    py.test -v -k 'not TestPerformance'
  '';
}
