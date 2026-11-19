# omp

omp is installed from prebuilt GitHub release binaries via
`nix/.config/nix/omp-bin.nix` (not a flake input, so `nix flake update` does
not touch it).

## Update omp

`~/.dotfiles/update --upgrade` runs `nix/.config/nix/omp-bin.update` along with
the other upgrades. To bump only omp on this machine:

```sh
~/.dotfiles/nix/.config/nix/omp-bin.update
sudo darwin-rebuild switch --flake ~/.dotfiles/nix/.config/nix#$HOST
```

The updater sets the latest release's version and per-platform hashes (from
`SHA256SUMS.txt`); the switch downloads the asset for the current system,
verifies its hash, and runs `omp --version`. Re-running on the latest version
is a no-op.
