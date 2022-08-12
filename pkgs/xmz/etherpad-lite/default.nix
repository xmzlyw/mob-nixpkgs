{ lib
, stdenv
, pkgs
, fetchFromGitHub
, nodejs-14_x
#, nodePackages
, runtimeShell
}:

let
  nodejs = nodejs-14_x;

  nodePackages = import ./node-packages.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

  etherpad-lite = lib.head (lib.attrValues nodePackages);

  combined = etherpad-lite.override {

    # == from postPatch ==
    #    echo postPatch
    #    cd ./src
    postPatch = ''
    '';

    # == from postInstall ==
    # mkdir $out/bin
    #
    # cat <<EOF > $out/bin/etherpad
    # #!${runtimeShell}
    # exec ${nodejs}/bin/node $out/lib/node_modules/ep_etherpad-lite/node/server.js
    # EOF
    # chmod +x $out/bin/etherpad

    postInstall = ''
      echo | pwd
      echo | dir
      find . -name "AbsolutePaths.js" -type f
      substituteInPlace node/utils/AbsolutePaths.js \
        --replace "if ((maybeEtherpadRoot === false) && (process.platform === 'win32')) {" "if ((maybeEtherpadRoot === false) && (process.platform === 'linux')) {" 
      cat <<EOF > $out/bin/etherpad
      #!/usr/bin/env bash
      DIR=cwd
      newStoreHash="$out"
      newWorkingDir="\$HOME/.etherpad"
      if [ -d "\$newWorkingDir" ]; then
        ### Take action if \$DIR exists ###
        curStoreHash=\$( cat \$newWorkingDir/storeHash )
        if [ "\$curStoreHash" != "\$newStoreHash" ]; then
          cp -R "$out/lib/node_modules" "\$newWorkingDir/"
          echo "\$newStoreHash" >| \$newWorkingDir/storeHash
          chmod +w -R \$newWorkingDir
        fi
        cd \$newWorkingDir
        ./node_modules/ep_etherpad-lite/node/server.js
      else
        ###  Control will jump here if $DIR does NOT exists ###
        mkdir \$newWorkingDir
        cp -R "$out/lib/node_modules" "\$newWorkingDir/"
        echo "\$newStoreHash" >| \$newWorkingDir/storeHash
        cd \$newWorkingDir
        ./node_modules/ep_etherpad-lite/node/server.js
        chmod +w -R \$newWorkingDir
      fi
      EOF
      chmod +x $out/bin/etherpad
    '';
    meta = with lib; {
      description = "Etherpad: A modern really-real-time collaborative document editor.";
      license = licenses.asl20;
      homepage = "https://etherpad.org";
      #maintainers = with maintainers; [ yawar1 xmzlyw ];
      platforms = platforms.unix;
    };
  };
in
  combined
