## Using with nix-darwin

home.nix is referenced through nix-darwin flake.nix

    darwin-rebuild switch --flake  ~/.config/nix-darwin\#HOSTNAME

## Using with home-manager install on linux

home.nix is references through home-manager flake.nix

    home-manager switch --flake ~/.config/home-manager#HOSTNAME

## TODO: Using with home-manager install on NixOS
