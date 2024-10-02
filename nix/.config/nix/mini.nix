{ config, pkgs, lib, inputs, ... }:

{

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
  ];

  users.users."kevincolyar" = {
    name = "kevincolyar";
    home = "/Users/kevincolyar";
    shell = pkgs.zsh;
  };

  # Add your user in order for devenv to work
  nix.settings.trusted-users = ["root" "kevincolyar"];

  home-manager = {
    users = {
      "kevincolyar" = {
        home.username = "kevincolyar";
        home.homeDirectory = "/Users/kevincolyar";

        imports = [
          ./home.nix
        ];
      };
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # MacOS Settings
  system.defaults.dock.appswitcher-all-displays = true;
    
  # Setup fonts
  fonts.packages = [ pkgs.fira-code-nerdfont ];

  homebrew.enable = true;
  homebrew.casks = [
    "adobe-creative-cloud"
    "airfoil"
    "alfred"
    "app-tamer"
    "backblaze"
    "blender"
    "brave-browser"
    "carbon-copy-cloner"
    "font-fira-code-nerd-font"
    "microsoft-remote-desktop"
    "minecraft"
    "openemu"
    "protonmail-bridge"
    "signal"
    "steam"
    "thunderbird"
    "vlc"
    "wezterm"
  ];
}
