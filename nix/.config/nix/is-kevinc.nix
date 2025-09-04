{ config, pkgs, lib, inputs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # Deprecated?
    # darwin.apple_sdk.frameworks.Security
    # darwin.apple_sdk.frameworks.CoreServices
    # pkgs.aider-chat
  ];

    
  # Add ability to used TouchID for sudo authentication
  # security.pam.enableSudoTouchIdAuth = true;
  security.pam.services.sudo_local.touchIdAuth = true;

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

  services.skhd.enable = true;
  
  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # MacOS Settings
  # https://macos-defaults.com
  system.defaults.dock.appswitcher-all-displays = true;

  system.defaults.NSGlobalDomain.NSWindowShouldDragOnGesture = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

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
      "alfred"
      "brave-browser"
      "cyberduck"
      "dbeaver-community"
      "docker-desktop"
      "freecad"
      "ghostty"
      "lapce"
      "little-snitch"
      "lm-studio"
      "prosys-opc-ua-browser"
      "qlstephen"
      "ricoh-ps-printers-vol4-exp-driver"
      "rustdesk"
      "screenfocus"
      "sourcetree"
      "timemachineeditor"
      "vlc"
      "wezterm"
      "windows-app"
      "wireshark-app"
    ];
  };
}
