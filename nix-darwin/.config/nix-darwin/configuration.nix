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

  home-manager = {
    users = {
      "kevin.colyar" = import "/Users/kevin.colyar/.config/home-manager/is-kevinc.nix";
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Setup fonts
  fonts.packages = [ pkgs.fira-code pkgs.fira-code-nerdfont ];

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
  ];
}
