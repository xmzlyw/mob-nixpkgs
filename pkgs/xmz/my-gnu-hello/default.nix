{ stdenv, fetchurl, lib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "my-gnu-hello";
  version = "2.12.1";

  src = fetchurl {
    url = "https://mirror.freedif.org/GNU/hello/hello-${finalAttrs.version}.tar.gz";
    sha256 = "086vqwk2wl8zfs47sq2xpjc9k066ilmb8z6dn0q6ymwjzlm196cd";
  };

  # doCheck = true;

  meta = with lib; {
    description = "a gnu hello world packaging test";
    longDescription = ''
      i dont have anything to write here
      but lets write something anyway
      since this is a long longDescription
    '';
    homepage = "https://savannah.gnu.org/projects/hello/";
    changelog = "";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.justme ];
    platforms = platforms.x86_64;
  };

})
