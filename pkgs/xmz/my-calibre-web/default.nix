{ lib
, python3
, fetchFromGitHub
#, nixosTests 
}:

python3.pkgs.buildPythonApplication rec {
  pname = "my-calibre-web";
  version = "0.6.18";

  src = fetchFromGitHub {
    owner = "janeczku";
    repo = "calibre-web";
    rev = version;
    sha256 = "sha256-KjmpFetNhNM5tL34e/Pn1i3hc86JZglubSMsHZWu198=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    iso-639
    lxml
    werkzeug
    Wand
    unidecode
    backports_abc
    chardet
    flask_principal
    pypdf3
    tornado
    flask-wtf
    advocate
    flask_login
    flask
    requests
    sqlalchemy
    flask-babel
    /*
    
    */
  ];

  patches = [
    ./default-logger.patch
    ./db-migrations.patch
  ];

  postPatch = ''
    mkdir -p src/calibreweb
    mv cps.py src/calibreweb/__init__.py
    mv cps src/calibreweb
    substituteInPlace setup.cfg \
      --replace "cps = calibreweb:main" "my-calibre-web = calibreweb:main" \
      --replace "lxml>=3.8.0,<4.9.0" "lxml>=3.8.0" \
      --replace "werkzeug<2.1.0" "" \
      --replace "unidecode>=0.04.19,<1.4.0" "unidecode>=0.04.19" \
      --replace "Flask-Login>=0.3.2,<0.5.1" "Flask-Login>=0.3.2" \
      --replace "Flask>=1.0.2,<2.1.0" "Flask>=1.0.2" \
      --replace "requests>=2.11.1,<2.28.0" "requests" \
      --replace "chardet>=3.0.0,<4.1.0" "chardet>=3.0.0" \
      --replace "tornado>=4.1,<6.2" "tornado>=4.1" \
  '';

  doCheck = false;

#  passthru.tests.my-calibre-web = nixosTests.calibre-web;

  meta = with lib; {
    description = "Calibre Web";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xmzlyw ];
#    platforms = platforms.all;
  };
}
