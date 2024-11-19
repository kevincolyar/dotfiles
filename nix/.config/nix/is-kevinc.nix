{ config, pkgs, lib, inputs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.CoreServices
  ];

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

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

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # MacOS Settings
  # https://macos-defaults.com
  system.defaults.dock.appswitcher-all-displays = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
  
  # Setup fonts
  fonts.packages = [ pkgs.fira-code-nerdfont ];

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
      "docker"
      "lapce"
      "little-snitch"
      "lm-studio"
      "prosys-opc-ua-browser"
      "qlstephen"
      "ricoh-ps-printers-vol4-exp-driver"
      "screenfocus"
      "sourcetree"
      "timemachineeditor"
      "vlc"
      "wezterm"
      "windows-app"
      "wireshark"
    ];
  };
}
