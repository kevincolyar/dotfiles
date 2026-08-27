{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # home.username = "kevin.colyar";
  # home.homeDirectory = "/Users/kevin.colyar";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [

    (aspellWithDicts
      (dicts: with dicts; [ en en-computers ]))
    tree
    curl
    wget
    snitch
    dust
    eza
    emacs31
    # emacs-lsp-booster
    emacs.pkgs.jinx
    starship
    tmux
    fzf
    ripgrep
    bat
    bottom
    gnupg
    pinentry-tty
    dua
    fd
    witr
    tailspin
    htop
    btop
    hl-log-viewer
    most
    gnugrep
    neovim
    mprocs
    autossh
    stow
    serie
    delta
    yazi
    nmap
    iperf
    rsync
    lazydocker
    proxychains-ng
    wireproxy
    ttyd
    rmlint
    zoxide

    zsh
    zsh-syntax-highlighting
    zsh-autocomplete
    zsh-autosuggestions
    zsh-fzf-tab
    zsh-fzf-history-search

    # Fonts 
    nerd-fonts.fira-code

    # Dev
    git
    direnv
    devenv
    jq
    nil
    grex
    # ollama - Currently broken on arm64. Using brew version instead
    mkcert
    prettierd # html formatter, used by emacs format-all 
    # vscode-langservers-extracted # for html-mode
    marksman

    # python
    # black
    # poetry
    ruff
    # pyrefly
    ty
    # pyright

    # rust
    cargo-outdated

    # nix
    nixd # lsp server

    # c/c++
    clang # lsp server

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = with pkgs; {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".gnupg/gpg-agent.conf".text = ''
       allow-loopback-pinentry
       pinentry-program ${pkgs.pinentry-tty}/bin/pinentry-tty
       default-cache-ttl 86400       # 24 hours
       max-cache-ttl 604800          # 7 days (hard max)
    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/kevin.colyar/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "emacs -nw";
    COLORTERM="truecolor";
  };

  programs.starship.enable = true;

  programs.fzf.enable = true;
  # programs.fzf.fuzzyCompletion = true;
  # programs.fzf.keybindings = true;

  programs.direnv.enable = true;

  # zsh config is stow-managed: ~/.dotfiles/zsh/.zshrc
  # Do not set Home Manager programs.zsh.enable — it writes ~/.zshrc on switch.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
