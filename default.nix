{ pkgs, stdenv, ... }: stdenv.mkDerivation {
  name = "tl";
  pname = "tl";
  src = ./.;

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = with pkgs; [ makeWrapper ];

  postFixup = with pkgs; ''
    for bin in $out/bin/*; do
      wrapProgram $bin \
        --set PATH ${lib.makeBinPath [
          coreutils
          util-linux
          jq
          curl
        ]}
    done
  '';
}
