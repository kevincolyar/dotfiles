{ lib, stdenvNoCC, fetchurl }:

let
  version = "17.4.0";

  # Prebuilt, self-contained Bun executables from GitHub Releases. Upstream's
  # flake advertises nix-community.cachix.org but its CI only runs
  # `nix flake check --no-build`, so nothing is ever pushed there and
  # oh-my-pi.packages.*.omp always builds rust natives + bun deps from source.
  #
  # Bumping: update `version`, then for each asset
  #   nix hash convert --hash-algo sha256 --to sri <hex-from-SHA256SUMS.txt>
  assets = {
    aarch64-darwin = {
      asset = "omp-darwin-arm64";
      hash = "sha256-hhrD16dkmdvDbm7IdptYthqWLarCtHdc5UVHTZAw5ro=";
    };
    x86_64-darwin = {
      asset = "omp-darwin-x64";
      hash = "sha256-Hv02lUMN/d2CTkMfm5aL3hUaGIDqnZtYcONjHVjU2Sc=";
    };
    # musl builds are static, so they need no autoPatchelfHook.
    aarch64-linux = {
      asset = "omp-linux-musl-arm64";
      hash = "sha256-wRdXoHUjOk5prHTUTBGBUpj5/nmY+DQEgK2u7WftnTM=";
    };
    x86_64-linux = {
      asset = "omp-linux-musl-x64";
      hash = "sha256-0dTqnU5ToXTS6xroEZ5XSbhN3EwHa/WZEGy/mHuI7OA=";
    };
  };

  system = stdenvNoCC.hostPlatform.system;

  selected =
    assets.${system}
      or (throw "omp-bin: no prebuilt release asset for ${system}");
in
stdenvNoCC.mkDerivation {
  pname = "omp-bin";
  inherit version;

  src = fetchurl {
    url = "https://github.com/can1357/oh-my-pi/releases/download/v${version}/${selected.asset}";
    inherit (selected) hash;
  };

  dontUnpack = true;
  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src" "$out/bin/omp"
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    HOME="$(mktemp -d)" "$out/bin/omp" --version
    runHook postInstallCheck
  '';

  meta = {
    description = "AI coding agent for the terminal (prebuilt release binary)";
    homepage = "https://github.com/can1357/oh-my-pi";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = lib.attrNames assets;
    mainProgram = "omp";
  };
}
