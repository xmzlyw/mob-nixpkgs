{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "jump";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "gsamokovarov";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nI4n1WxgdGGP822APBOLZ5lNkjwL1KfP5bKUxfvXdnE=";
  };

  vendorSha256 = null;

  doCheck = false;

  outputs = [ "out" "man"];
  postInstall = ''
    install -D --mode=444 man/j.1 man/jump.1 -t $man/man/man1/

    # generate completion scripts for jump
    export HOME="$NIX_BUILD_TOP"
    mkdir -p $out/share/{bash-completion/completions,fish/vendor_completions.d,zsh/site-functions}
    $out/bin/jump shell bash > "$out/share/bash-completion/completions/jump"
    $out/bin/jump shell fish > $out/share/fish/vendor_completions.d/jump.fish
    $out/bin/jump shell zsh > $out/share/zsh/site-functions/_jump
  '';

  meta = with lib; {
    description = "Navigate directories faster by learning your habits";
    longDescription = ''
      Jump integrates with the shell and learns about your
      navigational habits by keeping track of the directories you visit. It
      strives to give you the best directory for the shortest search term.
    '';
    homepage = "https://github.com/gsamokovarov/jump";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
