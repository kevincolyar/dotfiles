{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kevin.colyar";
  home.homeDirectory = "/Users/kevin.colyar";

  imports = [
    ./home.nix
  ];
}
