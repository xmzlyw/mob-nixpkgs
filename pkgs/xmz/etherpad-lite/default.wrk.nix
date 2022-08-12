let
  pkgs = import <nixpkgs> {};
in 
with pkgs;
stdenv.mkDerivation rec {
  pname = "etherpad-lite";
  version = "1.8.18";
  buildInputs = [ 
    pkgs.nodejs
    #pkgs.async
    #pkgs.nodePackages.clean-css-cli
    #pkgs.cookie-parser
    #pkgs.cross-spawn
    #pkgs.ejs
    #pkgs.etherpad-require-kernel
    #pkgs.etherpad-yajsml
    #pkgs.express
    #pkgs.express-rate-limit
    #pkgs.express-session
    #pkgs.fast-deep-equal
    #pkgs.find-root
    #pkgs.formidable
    #pkgs.http-errors
    #pkgs.js-cookie
    #pkgs.jsdom
    #pkgs.jsonminify
    #pkgs.languages4translatewiki
    #pkgs.lodash.clonedeep
    #pkgs.log4js
    #pkgs.measured-core
    #pkgs.mime-types
    #pkgs.npm
    #pkgs.openapi-backend
    #pkgs.proxy-addr
    #pkgs.rate-limiter-flexible
    #pkgs.rehype
    #pkgs.rehype-minify-whitespace
    #pkgs.request
    #pkgs.resolve
    #pkgs.security
    #pkgs.semver
    #pkgs.socket.io
    #pkgs.superagent
    #pkgs.terser
    #pkgs.threads
    #pkgs.tinycon
    #pkgs.ueberdb2
    #pkgs.underscore
    #pkgs.unorm
    #pkgs.wtfnode
  ];
  src = fetchFromGitHub {
    owner = "ether";
    repo = "etherpad-lite";
    rev = version;
    sha256 = "sha256-FziTdHmZ7DgWlSd7AhRdZioQNEPmiGZFHjc8pwnpKIo="; # lib.fakeSha256;
  };


  doCheck = false;



  meta = with lib; {
    description = "Etherpad-Lite";
    #license = licenses.apache20;
    maintainers = with maintainers; [ yawar1 xmzlyw ];
  };

}
