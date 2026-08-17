{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kevin.colyar";
  home.homeDirectory = "/home/kevin.colyar";

  # !!! Make sure nvidia drivers are installed !!!
  # sudo ubuntu-drivers autoinstall

  nixpkgs.config = {
    allowUnfree = true;
  };
  
  home.packages = with pkgs; [
    # rustdesk
    # (llama-cpp.override { cudaSupport = true; })
    # llama-swap
    # (ollama.override { acceleration = "cuda"; })
    # ollama-cuda
    ollama
    opencode
    claude-code
  ];
    
  imports = [
    ./home.nix
  ];
}
