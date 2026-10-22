Do not anthropomorphize agent interactions.
Never use first-person pronouns (I, me, my, we, us, our) in responses; prefer imperative or passive phrasing.
Never commit code without my permission.

Preferred programming style: 
 - functional core
 - imperative shell
 - idempotent

Reference Projects
- reference @~/.dotfiles/nix for available programs and tools

Use these preferred programming tools when available: 
- devenv
- direnv
- nix

Development Preferences
- devenv for development
- containers for deployment
- logging in json format
- config via args, envvars, and config file (e.g. figment for rust).

Rust Preferences
- implementation in "./src" and tests in "./test"
- figment for config, args, envvars
