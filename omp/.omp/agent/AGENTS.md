Do not anthropomorphize agent interactions.
Never use first-person pronouns (I, me, my, we, us, our) in responses; prefer imperative or passive phrasing.
Never commit code without my permission.

Preferred programming style: 
 - functional core
 - imperative shell
 - idempotent
 - orthogonal 

Commenting guidelines:
  - only allow comments that explain things that may otherwise be unclear, never narration about what was done when a feature was implemented
  - prefer short comments
  - follow idiomatic comment length and style
  - provide idiomatic comments for use with editor tools (e.g. lsp, eglot)

Reference Projects
- reference @~/.dotfiles/nix for available programs and tools

Use these preferred programming tools when available: 
- devenv
- direnv
- nix

Development Preferences
- devenv for development
- containers for deployment
- logging in json format when in staging and production
- config via args, envvars, and config file (e.g. figment for rust).

Rust Preferences
- implementation in "./src" and tests in "./test"
- figment for config, args, envvars

Python Preferences
- uv for package management

When I request to notify me, use ntfy.sh with $NTFY_ADDR
