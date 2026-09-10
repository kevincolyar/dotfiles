{ config, lib, pkgs, ... }:
let
  cfg = config.programs.keychain;
  invocation = lib.concatStringsSep " " (
    [ "${cfg.package}/bin/keychain" "--eval" ] ++ cfg.extraFlags ++ cfg.keys
  );
in
{
  # Keychain used for cron+ssh+gpg.
  # keychain >= 2.9 auto-classifies each key: a file under ~/.ssh -> ssh-agent,
  # otherwise resolved via `gpg --list-secret-keys` -> gpg-agent (--agents is deprecated).
  programs.keychain = {
    enable = true;
    keys = [
      "id_rsa"
      "3F72CA3F1139B71B" # Kevin Colyar <kevin@colyar.net>
    ];
  };

  # zsh is stow-managed (~/.dotfiles/zsh/.zshrc), so programs.zsh.enable is false and the
  # keychain module's programs.zsh.initContent is never written. Emit the snippet as a file
  # and let .zshrc source it, keeping keys defined here only.
  #
  # Guard: hosts without a local id_rsa must not run keychain at all, or ssh agent
  # forwarding breaks.
  home.file.".config/zsh/keychain.zsh".text = ''
    [[ -f $HOME/.ssh/id_rsa ]] || return 0
    eval "$(SHELL=zsh ${invocation})"
  '';
}
