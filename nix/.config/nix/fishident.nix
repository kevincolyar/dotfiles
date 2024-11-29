{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kevin.colyar";
  home.homeDirectory = "/home/kevin.colyar";

  imports = [
    ./home.nix
  ];
}
