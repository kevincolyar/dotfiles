{ config, pkgs, lib, inputs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Turn off nix-darwin's management of the Nix installation
  nix.enable = false;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    pkgs.llama-cpp
    # pkgs.llama-swap
    pkgs.opencode

    # Docker stuff
    pkgs.docker
    pkgs.colima
  ];

  # Colima CA Cert Fix
  #  cat /etc/nix/macos-keychain.crt | \
  #  colima ssh -- sudo tee /etc/nix/macos-keychain.crt && \
  #  colima ssh -- sudo update-ca-certificates
    
  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # Fixes tools like curl
  security.pki.certificateFiles = [
    "/etc/nix/macos-keychain.crt"
    # "/etc/ssl/certs/dcpud-ca.crt"
  ];

  # Restarts nix daemon
  # sudo launchctl kickstart -k system/systems.determinate.nix-daemon

  # Setup pam-reattached to enable touchid & sudo inside tmux
  environment = {
    etc."pam.d/sudo_local".text = '' 
      # Managed by Nix Darwin
      auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
      auth       sufficient     pam_tid.so
    '';

    # Required for emacs native compiling. Fixes 'libgccjit.so: error: error invoking gcc driver' error.
    variables = {
        LIBRARY_PATH = "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib";
        SSL_CERT_FILE = "/etc/nix/macos-keychain.crt";
        NIX_SSL_CERT_FILE = "/etc/nix/macos-keychain.crt";
    };
  };

  system.primaryUser = "kevin.colyar";

  users.users."kevin.colyar" = {
    name = "kevin.colyar";
    home = "/Users/kevin.colyar";
    shell = pkgs.zsh;
  };

  # Add your user in order for devenv to work
  nix.settings.trusted-users = ["root" "kevin.colyar"];

  home-manager = {
    users = {
      "kevin.colyar" = {
        home.username = "kevin.colyar";
        home.homeDirectory = "/Users/kevin.colyar";

        imports = [
          ./home.nix
        ];
      };
    };
  };

  # services.skhd.enable = true;
  
  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # MacOS Settings
  # https://macos-defaults.com
  system.defaults.dock.appswitcher-all-displays = true;
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 9;
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.NSWindowShouldDragOnGesture = true;

  # Setup fonts
  fonts.packages = [
    pkgs.nerd-fonts.fira-code
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    casks = [
      "brave-browser"
      "cyberduck"
      "dbeaver-community"
      # "docker-desktop"
      "freecad"
      "ghostty"
      "little-snitch"
      "prosys-opc-ua-browser"
      # "ricoh-ps-printers-vol4-exp-driver"
      "rustdesk"
      "timemachineeditor"
      "vlc"
      "wezterm"
      "windows-app"
      "microsoft-teams"
      "microsoft-outlook"
      "postman"
      "wireshark-app"
      # "ollama"
    ];
  };
}
