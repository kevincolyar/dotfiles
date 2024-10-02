{ config, pkgs, lib, inputs, ... }:

{

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
  ];

  users.users."kevin.colyar" = {
    name = "kevin.colyar";
    home = "/Users/kevin.colyar";
    shell = pkgs.zsh;
  };

  # Add your user in order for devenv to work
  nix.settings.trusted-users = ["root" "kevin.colyar"];

  home-manager = {
    users = {
      # "kevin.colyar" = import "/Users/kevin.colyar/.config/home-manager/is-kevinc.nix";
      "kevin.colyar" = {
        home.username = "kevin.colyar";
        home.homeDirectory = "/Users/kevin.colyar";

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
    "alacritty"
    "alfred"
    "brave-browser"
    "cyberduck"
    "dbeaver-community"
    "docker"
    "lapce"
    "little-snitch"
    "lm-studio"
    "microsoft-remote-desktop"
    "prosys-opc-ua-browser"
    "qlstephen"
    "ricoh-ps-printers-vol4-exp-driver"
    "timemachineeditor"
    "vlc"
    "wezterm"
    "wireshark"
    "screenfocus"
  ];
}
