{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "my-minetest";
  version = "5.5.1";
  src = fetchFromGitHub {
    owner = "minetest";
    repo = "minetest";
    rev = version;
    sha256 = "sha256-ssaDy6tYxhXGZ1+05J5DwoKYnfhKIKtZj66DOV84WxA=" ;#lib.fakeSha256; 
  };

  buildInputs = [
  ];

  nativeBuildInputs = [
  ];

  meta = with lib; {
    description = "my minetest";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ xmzlyw ];
    platforms = platforms.all;
  };

}
