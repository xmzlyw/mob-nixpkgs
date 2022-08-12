{ lib
, stdenv
, pkgs
, fetchFromGitHub
, nodejs-14_x
#, nodePackages
, runtimeShell }:

let
  nodejs = nodejs-14_x;

  nodePackages = import ./node-packages.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
stdenv.mkDerivation rec {
  pname = "etherpad-lite";
  version = "1.8.18";
  src = fetchFromGitHub {
    owner = "ether";
    repo = "etherpad-lite";
    rev = version;
    sha256 = "sha256-FziTdHmZ7DgWlSd7AhRdZioQNEPmiGZFHjc8pwnpKIo="; # lib.fakeSha256;
  };

  #dontNpmInstall = true;
  
  # Install root seems to be ./src instead of root
  postPatch = ''
      echo postPatch
      cd ./src
    '';

  # # Attempt at resolving old verison of npm used to generate package-lock.json
  # postPatch = ''
  #     echo postPatch
  #     find . -name "package-lock.json" -type f
  #     find . -name "package-lock.json" -type f -delete
  #     cd ./src
  #     npm shrinkwrap --package-lock
  #     mv npm-shrinkwrap.json package-lock.json 
  #     cd bin/doc
  #     npm shrinkwrap --package-lock
  #     mv npm-shrinkwrap.json package-lock.json
  #     cd ../../
  #     find . -name "package-lock.json" -type f
  #   '';
  
  buildInputs = [ 
    nodejs 
  ];

  # create the executable etherpad in $out/bin and make it executable
  postInstall = ''
      mkdir $out/bin
      cat <<EOF > $out/bin/etherpad
      #!${runtimeShell}
      exec ${nodejs}/bin/node $out/src/node/server.js
      EOF
      chmod +x $out/bin/etherpad
    '';

  doCheck = false;

  meta = with lib; {
    description = "Etherpad-Lite";
    #license = licenses.apache20;
    maintainers = with maintainers; [ yawar1 xmzlyw ];
  };

}
