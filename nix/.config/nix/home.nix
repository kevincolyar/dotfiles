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
    dust
    eza
    emacs30-nox
    emacs-lsp-booster
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
    htop
    btop
    most
    gnugrep
    neovim
    mprocs
    autossh
    stow
    delta
    yazi
    nmap
    prettierd # html formatter, used by emacs format-all 
    iperf

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
    ollama

    # python
    ruff
    black
    poetry
    pyright

    # rust
    cargo-outdated

    # nix
    nixd # lsp server

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
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
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
    EDITOR = "emacs";
    COLORTERM="truecolor";
    GPG_TTY = "tty"; # Required by gnupg-vim
  };

  programs.starship.enable = true;

  programs.fzf.enable = true;
  # programs.fzf.fuzzyCompletion = true;
  # programs.fzf.keybindings = true;

  programs.direnv.enable = true;

  # https://github.com/starcraft66/os-config/blob/master/home-manager/programs/zsh.nix
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Disable completion because completion is already enabled in nix config.
    # Zsh startup is slow if set to true.
    enableCompletion = false;

    initExtra = ''
       # Vim Mode
       bindkey -v

       zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|=*' 'l:|=*'
 
       # Optional: you may want to add other useful options
       setopt AUTO_MENU    # enables automatic selection in the completion menu.
       setopt CORRECT      # enables spelling correction
       setopt REC_EXACT    # don't correct matches even though they are typographical mistakes

       path=(
         ./bin
         $HOME/bin
         $HOME/bin/ssh
         $HOME/bin/mount
         $HOME/.docker/bin
         $path
       )

       # Homebrew
       if [[ -d /opt/homebrew ]]; then
         eval "$(/opt/homebrew/bin/brew shellenv)"
       fi

       # fzf
       if [ -n "''${commands[fzf-share]}" ]; then
         # source "$(fzf-share)/key-bindings.zsh"
         # source "$(fzf-share)/completion.zsh"
         source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
       fi
    '';

    shellAliases = {

      ".." = "cd ..";
      less="less -R";
      du="dua -i .git -i node_modules interactive";
      cat="bat";
      e="emacs";

      ls="eza --git";
      l="eza -lgh";
      ll="eza -lgah";
      la="ls -lAGh --color";

      # Git
      gl="git pull";
      gp="git push";
      gd="git diff";
      gc="git commit";
      gca="git commit -a";
      gco="git checkout";
      gb="git branch";
      gs="git status";
      grm="git status | grep deleted | awk '{print \$3}' | xargs git rm";
      git_diff="git diff --no-ext-diff -w '$@' | vim -R -";
      glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset %C(yellow) %an %Creset' --abbrev-commit --date=relative";

      # docker
      dc="docker compose";
      dcl="docker compose -f docker-compose.yml -f docker-compose.local.yml";

      # kubernetes
      k8="kubectl";

      # Other
      vi="vim";
      vim="nvim";

      # Globbing issues
      curl="noglob curl";
      wget="noglob wget";
      git="noglob git";

    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
