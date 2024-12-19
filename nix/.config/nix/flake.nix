{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows= "nixpkgs";
  };


  outputs = { self, nixpkgs, nix-darwin, home-manager, ...}@inputs:
    let
      configuration = { pkgs, ... }: {

        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;
        # nix.package = pkgs.nix;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Add your user in order for devenv to work
        # nix.settings.trusted-users = ["root" "${username}"];

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 4;

        # The platform the configuration will be used on.
        # nixpkgs.hostPlatform = "aarch64-darwin";
      };
    in
      {
        # Build darwin flake using:
        # $ darwin-rebuild switch --flake ~/.dotfiles/nix/.config/nix#is-kevinc
        darwinConfigurations.is-kevinc = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs;};

          modules = [
            configuration
            ./is-kevinc.nix
            inputs.home-manager.darwinModules.default
          ];
        };

        # darwin-rebuild switch --flake ~/.dotfiles/nix/.config/nix#mini
        darwinConfigurations.mini = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs;};

          modules = [
            configuration
            ./mini.nix
            inputs.home-manager.darwinModules.default
          ];
        };

        # home-manager switch --flake ~/.dotfiles/nix/.config/nix#fishident
        homeConfigurations.fishident = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          modules = [
            ./fishident.nix
          ];
        };

        homeConfigurations.kubi = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          modules = [
            ./kubi.nix
          ];
        };

        # Expose the package set, including overlays, for convenience.
        # darwinPackages = self.darwinConfigurations.${hostname}.pkgs;
      };
}
