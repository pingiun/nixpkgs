{ lib, fetchPypi, buildPythonPackage
, lazy-object-proxy, six, wrapt, enum34, singledispatch, backports_functools_lru_cache
, pytest
}:

buildPythonPackage rec {
  pname = "astroid";
  version = "2.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09a3fba616519311f1af8a461f804b68f0370e100c9264a035aa7846d7852e33";
  };

  # From astroid/__pkginfo__.py
  propagatedBuildInputs = [
    lazy-object-proxy
    six
    wrapt
    enum34
    singledispatch
    backports_functools_lru_cache
  ];

  checkInputs = [ pytest ];

  checkPhase = ''
    # test_builtin_help is broken
    pytest -k "not test_builtin_help and not test_namespace_and_file_mismatch and not test_namespace_package_pth_support and not test_nested_namespace_import" astroid
  '';

  meta = with lib; {
    description = "An abstract syntax tree for Python with inference support";
    homepage = https://github.com/PyCQA/astroid;
    license = licenses.lgpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ nand0p ];
  };
}
