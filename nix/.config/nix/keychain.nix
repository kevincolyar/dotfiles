{ config, pkgs, ... }:
{
  # Keychain used for cron+ssh
  # Only use on machines that have "id_rsa" locally, or it will break agent forwarding
  programs.keychain = {
    enable = true;
    keys = [ "id_rsa" ];
  };
}
