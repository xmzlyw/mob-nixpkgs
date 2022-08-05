{ lib, stdenv, fetchurl, file, zlib, libgnurx }:

# Note: this package is used for bootstrapping fetchurl, and thus
# cannot use fetchpatch! All mutable patches (generated by GitHub or
# cgit) that are needed here should be included directly in Nixpkgs as
# files.

stdenv.mkDerivation rec {
  pname = "file";
  version = "5.42";

  src = fetchurl {
    urls = [
      "https://astron.com/pub/file/${pname}-${version}.tar.gz"
      "https://distfiles.macports.org/file/${pname}-${version}.tar.gz"
    ];
    sha256 = "sha256-wHb7TQKcdAc/FcQzYe9XLPuGhAfTRxkLqDSvOxY5sOQ=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) file;
  buildInputs = [ zlib ]
    ++ lib.optional stdenv.hostPlatform.isWindows libgnurx;

  doCheck = true;

  makeFlags = lib.optional stdenv.hostPlatform.isWindows "FILE_COMPILE=file";

  meta = with lib; {
    homepage = "https://darwinsys.com/file";
    description = "A program that shows the type of files";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}