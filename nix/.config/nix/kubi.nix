{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kevincolyar";
  home.homeDirectory = "/home/kevincolyar";

  home.packages = with pkgs; [
    signal-desktop
    j4-dmenu-desktop
    protonvpn-gui
    networkmanagerapplet
    unixtools.netstat
  ];

  # programs.zsh = {
  #   shellAliases = {
  #     signal="signal-desktop --no-sandbox";
  #   };
  # };

  imports = [
    ./home.nix
  ];
}
