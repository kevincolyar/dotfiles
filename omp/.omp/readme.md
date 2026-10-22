# omp

omp is installed from prebuilt GitHub release binaries via
`nix/.config/nix/omp-bin.nix` (not a flake input, so `nix flake update` does
not touch it).

## Update omp

Bump `omp-bin.nix` to the latest release (version + per-platform hashes from
`SHA256SUMS.txt`), build it, then switch:

```sh
cd ~/.dotfiles/nix/.config/nix && bash -euo pipefail <<'EOF'
v=$(curl -fsSL https://api.github.com/repos/can1357/oh-my-pi/releases/latest | jq -r .tag_name)
sums=$(curl -fsSL "https://github.com/can1357/oh-my-pi/releases/download/$v/SHA256SUMS.txt")
perl -pi -e "s/version = \"[^\"]*\";/version = \"${v#v}\";/" omp-bin.nix
for a in omp-darwin-arm64 omp-darwin-x64 omp-linux-arm64 omp-linux-x64; do
  h=$(nix hash convert --hash-algo sha256 --to sri "$(awk -v a="$a" '$2 == a { print $1 }' <<<"$sums")")
  perl -0pi -e "s|(asset = \"$a\";\s*hash = \")[^\"]*|\${1}$h|" omp-bin.nix
done
nix build --no-link --impure --expr 'with import (builtins.getFlake "nixpkgs") {}; callPackage ./omp-bin.nix {}'
EOF
sudo darwin-rebuild switch --flake ~/.dotfiles/nix/.config/nix#$HOST
```

The build fetches the asset for the current system, verifies its hash, and
runs `omp --version`. Re-running on the latest version is a no-op.
