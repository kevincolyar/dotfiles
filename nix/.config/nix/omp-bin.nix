{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  glibc,
}:

let
  version = "19.0.0";

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
      hash = "sha256-pe6Qsv/MDB8DHb1L7dT/jgyITsjmm3APTF12oerona8=";
    };
    x86_64-darwin = {
      asset = "omp-darwin-x64";
      hash = "sha256-u7PpMzwx+luJLONT3GeOemfCVmcwf1QA6ge9koFj+yk=";
    };
    # Linux release assets are dynamically linked (the musl ones against
    # /lib/ld-musl-x86_64.so.1, which does not exist under Nix), so the glibc
    # assets are used and autoPatchelfHook rewrites their interpreter. They
    # need nothing beyond glibc; the C++ runtime is linked statically.
    aarch64-linux = {
      asset = "omp-linux-arm64";
      hash = "sha256-YwEEEwnZuybBlXarEW2CjbqcdGVFB8+jWU1i0xCGRiY=";
    };
    x86_64-linux = {
      asset = "omp-linux-x64";
      hash = "sha256-x8xcjVBQU8j/rxgEF+XVx4EjW52TbyhoEFYBURIBCb8=";
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

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [ glibc ];

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
