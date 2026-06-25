{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kevincolyar";
  home.homeDirectory = "/home/kevincolyar";

  home.packages = with pkgs; [
  ];

  imports = [
    ./home.nix
  ];
}
