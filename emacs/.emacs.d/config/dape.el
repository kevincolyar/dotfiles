;;; -*- lexical-binding: t; -*-
;; Dape -- Debug Adapter Protocol client
;; ------------------------------------------------------------------------------
;; https://github.com/svaante/dape
;;
;; dap-mode is the other DAP client for Emacs, but it is built on lsp-mode.
;; This config runs eglot (config/eglot.el), and dape depends on nothing
;; outside core Emacs, so it is the only choice that does not pull in a second
;; LSP stack just to debug.
;;
;; Keys live under `SPC d' (config/key-mapping.el), next to eglot's `SPC c'.
;; `dape-key-prefix' (C-x C-a, gud's prefix) is left alone as a fallback.
;;
;; Adapters come from two places, and which one is not a matter of taste:
;;
;;   rust   codelldb  nix (nix/.config/nix/home.nix) -- standalone binary
;;   js     js-debug  nix (nix/.config/nix/home.nix) -- standalone binary
;;   python debugpy   the project: the interpreter that imports debugpy is
;;                    the one that runs the program, so a global copy would
;;                    debug the wrong environment
;;   ruby   rdbg      the project: `debug' is a bundled gem since ruby 3.1,
;;                    otherwise `gem install debug' or add it to the Gemfile
;;
;; `SPC d d' picks a configuration with `completing-read' (so vertico and
;; orderless drive it); `SPC d D', or `C-u SPC d d', uses dape's own prompt,
;; where every key of a configuration can be amended, e.g.
;;
;;   codelldb-rust compile "cargo test --no-run" :program "target/debug/deps/x"
;;   rdbg-bundle -c "bundle exec rails server"
;;   js-debug-node :program "server.js" :args ["--port" "3000"]
;;
;; Those overrides can be typed into the `SPC d d' prompt too -- both readers
;; end in `dape--config-from-string' -- only its completion stops helping once
;; the configuration name is complete.

(use-package dape
  :defer t
  ;; dape.el carries autoload cookies on `dape' and `dape-breakpoint-global-mode'
  ;; only, so every other command bound under `SPC d' would be void-function
  ;; until something else pulled the package in. `:commands' generates the
  ;; missing autoloads.
  :commands (dape-breakpoint-toggle dape-breakpoint-remove-all
             dape-breakpoint-log dape-breakpoint-expression dape-breakpoint-hits
             dape-continue dape-next dape-step-in dape-step-out dape-until
             dape-pause dape-restart dape-kill dape-quit
             dape-evaluate-expression dape-watch-dwim
             dape-select-thread dape-select-stack dape-info dape-repl)

  :custom
  ;; Keep source in the window it is already in and stack
  ;; scope/stack/breakpoints/repl in side windows on the right.
  (dape-buffer-window-arrangement 'right)

  :config
  ;; Ruby and python debug the file on disk, not the buffer.
  (defun my/dape-save-buffers ()
    "Save modified file buffers without prompting."
    (save-some-buffers t t))
  (add-hook 'dape-start-hook #'my/dape-save-buffers)
  ;; `dape-compile-hook' runs only when compilation finished successfully, so
  ;; a failed `cargo build' still leaves its *compilation* buffer to read.
  ;; `kill-buffer' alone leaves the window `compile' opened for it, which then
  ;; falls back to whatever it displayed before -- the source file -- so every
  ;; session ended up with the same buffer in two windows.  `quit-window'
  ;; reads the window's `quit-restore' parameter and deletes a window that was
  ;; created for this buffer instead.
  (defun my/dape-quit-compile-window (buffer)
    "Kill compilation BUFFER and the window opened to display it."
    (if-let* ((window (get-buffer-window buffer)))
        (quit-window t window)
      (kill-buffer buffer)))

  (add-hook 'dape-compile-hook #'my/dape-quit-compile-window)

  ;; which-key pops up in a bottom side window at slot 0, which is the slot
  ;; dape hands `*dape-shell*' (`dape--display-buffer'); side windows sharing a
  ;; side and slot are one window, so `SPC d' during a session displaced the
  ;; shell with the menu. Giving which-key its own slot only splits the bottom
  ;; row -- both want its full width -- so the menu moves to the minibuffer for
  ;; as long as a session is live.
  (defvar my/dape-which-key-popup-type nil
    "Value of `which-key-popup-type' outside a dape session.")

  (defun my/dape-which-key-arrange ()
    "Keep which-key out of dape's side windows while a session is live."
    (when (boundp 'which-key-popup-type)
      (if dape-active-mode
          (setq my/dape-which-key-popup-type which-key-popup-type
                which-key-popup-type 'minibuffer)
        (setq which-key-popup-type (or my/dape-which-key-popup-type
                                       'side-window)))))

  (add-hook 'dape-active-mode-hook #'my/dape-which-key-arrange)

  ;; `compile' spawns through `shell-file-name', and nix-darwin writes an
  ;; /etc/zshenv that sources its `set-environment' for *every* zsh, `zsh -c'
  ;; included -- and that file does `export PATH=...' with an absolute list.
  ;; So the buffer's direnv/devenv PATH, which is the only place cargo lives
  ;; on this machine, is wiped between `dape' and `cargo build': the step dies
  ;; with exit 127 while `executable-find' inside Emacs still resolves cargo.
  ;; A non-interactive /bin/sh reads no startup files, so the environment dape
  ;; prepared reaches the compiler intact.
  (defun my/dape-compile (command)
    "Run COMMAND with `compile' in a shell that keeps the caller's PATH."
    (let ((shell-file-name (if (file-executable-p "/bin/sh")
                               "/bin/sh"
                             shell-file-name)))
      (compile command)))

  (setq dape-compile-function #'my/dape-compile)

  (defun my/dape-set-config (name config)
    "Set dape configuration NAME to CONFIG, replacing any existing entry."
    (setf (alist-get name dape-configs) config))

  (defun my/dape-configure (config-list)
    "Register dape configurations from CONFIG-LIST.
Each entry should be (NAME . CONFIG)."
    (dolist (config config-list)
      (my/dape-set-config (car config) (cdr config))))

  (defun my/dape-update-config (name &rest props)
    "Set PROPS (alternating keys and values) on dape configuration NAME.
Skips NAME when this dape version does not ship it, rather than registering
a config that holds nothing but PROPS. Works on a copy, so the list in
`dape-configs' (and the defcustom's standard value it shares structure
with) is never mutated in place."
    (when-let* ((config (copy-sequence (alist-get name dape-configs))))
      (while props
        (setq config (plist-put config (pop props) (pop props))))
      (my/dape-set-config name config)))

  ;; Rust -----------------------------------------------------------------
  (defun my/dape-lldb-debugserver ()
    "Return the macOS debugserver binary LLDB should launch processes with.
LLDB finds it through `DEVELOPER_DIR', and devenv/direnv exports that
variable pointing at nixpkgs' apple-sdk, which ships headers and no
LLDB.framework at all.  Every launch in such a shell then dies with
\"executable doesn't exist: '(empty)'\" -- the empty name being the
debugserver LLDB never resolved, not the program under debug.  nixpkgs'
codelldb wrapper only defaults `LLDB_DEBUGSERVER_PATH' to a path inside
Xcode.app, which a command-line-tools-only machine does not have.

Not macOS: codelldb talks to its own bundled lldb-server and ignores the
variable, so there is nothing to point at."
    (if (not (eq system-type 'darwin))
        ""
      (or (cl-loop for path in (list (getenv "LLDB_DEBUGSERVER_PATH")
                                     "/Library/Developer/CommandLineTools/Library/PrivateFrameworks/LLDB.framework/Resources/debugserver"
                                     "/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/Resources/debugserver")
                   when (and path (file-executable-p path)) return path)
          (user-error "No debugserver found; install the Xcode command line tools"))))

  (defun my/dape-cargo-cwd ()
    "Return the absolute root directory of the cargo workspace around point.
`dape-cwd' guesses with `project-current', which knows nothing about
Cargo.toml: a crate that is not a VC repository launches in the buffer's
own directory -- usually `src/' -- and the fallback branch of
`dape--default-cwd' hands back `default-directory' unexpanded, so an
abbreviated buffer path reaches the adapter as a literal `~/...', which
chdir(2) cannot resolve.  `command-cwd' is also what dape resolves
breakpoint paths and runs `compile' against, so it has to be the root.

`cargo locate-project --workspace' prints the workspace manifest, which
is the root by definition; without cargo there is nothing better than
dape's own guess, expanded."
    (let ((manifest (when (executable-find "cargo")
                      (with-temp-buffer
                        (when (zerop (call-process "cargo" nil (list t nil) nil
                                                   "locate-project" "--workspace"
                                                   "--message-format" "plain"))
                          (string-trim (buffer-string)))))))
      (if (and manifest (not (string-empty-p manifest)))
          (file-name-directory (expand-file-name manifest))
        (expand-file-name (dape-cwd)))))

  (defun my/dape-cargo-program ()
    "Return the debug executable of the cargo package around `default-directory'.
`cargo metadata' is the only dependable source for this path: the
executable is named after the [[bin]] target rather than after the crate
directory, and `target_directory' moves with CARGO_TARGET_DIR and with
workspace layout.  Stderr is discarded so cargo warnings cannot corrupt
the JSON on stdout."
    (with-temp-buffer
      (unless (zerop (call-process "cargo" nil (list t nil) nil
                                   "metadata" "--no-deps" "--format-version" "1"))
        (user-error "`cargo metadata' failed in %s" default-directory))
      (goto-char (point-min))
      (let* ((metadata (json-parse-buffer :object-type 'plist :array-type 'list))
             (binaries
              (cl-loop for package in (plist-get metadata :packages)
                       append (cl-loop for target in (plist-get package :targets)
                                       when (member "bin" (plist-get target :kind))
                                       collect (plist-get target :name)))))
        (file-name-concat
         (plist-get metadata :target_directory) "debug"
         (pcase binaries
           ('nil (user-error "No [[bin]] target below %s" default-directory))
           (`(,binary) binary)
           (_ (completing-read "Debug binary: " binaries nil t)))))))

  (defun my/dape-rust-lldb-lookup ()
    "Return `initCommands' that import rustc's own LLDB formatters.
codelldb imports them itself, but only if the sysroot still carries
`lib/rustlib/etc/lldb_commands'.  Rust deleted that file once
`lldb_lookup.py' grew an `__lldb_init_module', so on every toolchain
since 1.85 codelldb 1.12.2 prints \"Could not find LLDB data formatters
in your Rust toolchain\" on stderr and String, Vec and HashMap show up as
raw pointer/length structs.  Importing lldb_lookup.py is exactly what
rust-lldb does, and it is harmless on the older layout.

An empty vector when rustc is absent or the file is missing: no
formatters is still a working session, a failed `initCommands' is not."
    (let* ((sysroot (when (executable-find "rustc")
                      (with-temp-buffer
                        (when (zerop (call-process "rustc" nil (list t nil) nil
                                                   "--print" "sysroot"))
                          (string-trim (buffer-string))))))
           (lookup (and sysroot (file-name-concat
                                 sysroot "lib/rustlib/etc/lldb_lookup.py"))))
      (if (and lookup (file-exists-p lookup))
          (vector (format "command script import '%s'" lookup))
        [])))

  ;; Python ---------------------------------------------------------------
  (defun my/dape-python-executable ()
    "Return the python interpreter that should host debugpy.
`debugpy.adapter' starts the debuggee with the very interpreter that
imports debugpy, so only the project's own interpreter can see the
project's dependencies -- and dape's stock \"python\" is not even on PATH
on macOS.  direnv-mode (config/nix.el) already exports a devenv or venv
python per buffer; the in-tree lookup covers projects without direnv."
    (let ((root (dape-command-cwd)))
      (or (cl-loop for venv in '(".venv" "venv")
                   for python = (file-name-concat root venv "bin" "python")
                   when (file-executable-p python) return (file-local-name python))
          (executable-find "python")
          (executable-find "python3")
          (user-error "No python executable found for %s" root))))

  ;; Ruby -----------------------------------------------------------------
  (defun my/dape-rdbg-expand-command (config)
    "Replace the `:-c' placeholder in CONFIG's `command-args' with its `-c'.
rdbg hands that string to `Kernel#exec', which runs a single argument
containing spaces through a shell, so it has to stay one argument."
    (plist-put config 'command-args
               (mapcar (lambda (arg)
                         (if (eq arg :-c) (plist-get config '-c) arg))
                       (plist-get config 'command-args))))

  (my/dape-configure
   '((codelldb-rust
      modes (rust-mode rust-ts-mode rustic-mode)
      ensure dape-ensure-command
      ;; codelldb serves a single session on --port and exits with it, which
      ;; is exactly dape's lifecycle.
      command "codelldb"
      command-args ("--port" :autoport)
      port :autoport
      ;; The adapter inherits the buffer's direnv environment, which is what
      ;; puts cargo and rustc on PATH and, on macOS, what breaks LLDB's own
      ;; debugserver lookup; see `my/dape-lldb-debugserver'.
      command-env (:LLDB_DEBUGSERVER_PATH my/dape-lldb-debugserver)
      command-cwd my/dape-cargo-cwd
      compile "cargo build"
      :type "lldb"
      :request "launch"
      :cwd my/dape-cargo-cwd
      :program my/dape-cargo-program
      ;; `sourceLanguages ["rust"]' is deliberately absent: codelldb's
      ;; lang_support/rust.py does nothing but load these same formatters,
      ;; and on current toolchains it only prints "Could not find LLDB data
      ;; formatters in your Rust toolchain" while doing so. String, Vec and
      ;; HashMap print as values rather than raw pointer/length structs once
      ;; lldb_lookup.py is imported, which is what this does. The file is
      ;; located with `rustc --print sysroot', so rustc has to be on PATH --
      ;; direnv-mode (config/nix.el) supplies the per-project toolchain.
      :initCommands my/dape-rust-lldb-lookup
      :args []
      ;; codelldb's default terminal, "integrated", asks dape to run the
      ;; program through `codelldb-launch' in a comint buffer, and dape parks
      ;; that `*dape-shell*' in a bottom side window at slot 0 -- the slot
      ;; which-key and every other bottom popup want. "console" has codelldb
      ;; run the program itself and relay its stdout/stderr as DAP output
      ;; events, so the output lands in the REPL and the bottom row holds one
      ;; dape window instead of two. Programs reading stdin want the terminal
      ;; back.
      :terminal "console")

     ;; Debugging the test that fails is the common python case, and pytest
     ;; swallows `breakpoint()', so run pytest as a module under the adapter.
     ;; The buffer file is the only argument; narrow it at the prompt with
     ;; :args ["path::test_name" "-k" "..."].
     (debugpy-pytest
      modes (python-mode python-ts-mode)
      ensure (lambda (config)
               (dape-ensure-command config)
               (let ((python (dape-config-get config 'command)))
                 ;; No shell: an interpreter path with spaces stays one argument.
                 (unless (zerop (process-file python nil nil nil
                                              "-c" "import debugpy.adapter, pytest"))
                   (user-error "%s cannot import debugpy and pytest" python))))
      command my/dape-python-executable
      command-args ("-m" "debugpy.adapter" "--host" "127.0.0.1" "--port" :autoport)
      host "127.0.0.1"
      port :autoport
      :type "python"
      :request "launch"
      :cwd dape-cwd
      :module "pytest"
      :args [dape-buffer-default]
      :console "integratedTerminal"
      :justMyCode nil
      :showReturnValue t
      :stopOnEntry nil)

     (rdbg
      modes (ruby-mode ruby-ts-mode)
      ensure dape-ensure-command
      command "rdbg"
      command-args ("-O" "--host" "127.0.0.1" "--port" :autoport "-c" "--" :-c)
      fn my/dape-rdbg-expand-command
      host "127.0.0.1"
      port :autoport
      command-cwd dape-command-cwd
      :type "Ruby"
      ;; rdbg runs the program itself and dape attaches over TCP, which the
      ;; debuggee reads as a remote client: without `:localfs' it refuses to
      ;; map source paths and every breakpoint comes back unverified with
      ;; "could not be located; specify source location ... localfs".
      :localfs t
      ;; rdbg passes -c to `Kernel#exec', which runs a string with spaces
      ;; through /bin/sh, so the file name needs shell quoting.
      -c (concat "ruby " (shell-quote-argument (dape-buffer-default))))

     ;; Same, for projects where the debug gem lives in the bundle -- rails
     ;; apps, mostly. Swap the program at the prompt:
     ;; `rdbg-bundle -c "bundle exec rspec spec/foo_spec.rb"'.
     (rdbg-bundle
      modes (ruby-mode ruby-ts-mode)
      ensure dape-ensure-command
      command "bundle"
      command-args ("exec" "rdbg" "-O" "--host" "127.0.0.1" "--port" :autoport
                    "-c" "--" :-c)
      fn my/dape-rdbg-expand-command
      host "127.0.0.1"
      port :autoport
      command-cwd dape-command-cwd
      :type "Ruby"
      :localfs t
      -c (concat "bundle exec ruby " (shell-quote-argument (dape-buffer-default))))))

  ;; debugpy's interpreter is the debuggee's interpreter, so dape's stock
  ;; "python" command is replaced wherever debugpy is started. The adapter is
  ;; also pinned to 127.0.0.1 rather than dape's 0.0.0.0: a debugger that
  ;; evaluates arbitrary expressions has no business listening on the network.
  (dolist (name '(debugpy debugpy-module))
    (my/dape-update-config name
                           'command #'my/dape-python-executable
                           'command-args '("-m" "debugpy.adapter" "--host" "127.0.0.1"
                                           "--port" :autoport)
                           'host "127.0.0.1"))

  ;; nixpkgs' vscode-js-debug ships the wrapper `js-debug PORT [HOST]', which
  ;; execs node on dapDebugServer.js; dape's own entries instead expect the
  ;; release tarball unpacked under `dape-adapter-dir', which nothing here
  ;; populates. HOST is not optional: given only a port the server binds ::1,
  ;; while dape dials "localhost", which resolves to 127.0.0.1 first.
  ;;
  ;; .tsx files open in `tsx-ts-mode' (config/tree-sitter.el), which none of
  ;; the typescript-capable entries list, so nothing was ever offered there.
  (dolist (name '(js-debug-node js-debug-node-attach js-debug-ts-node
                  js-debug-tsx js-debug-chrome))
    (let ((modes (plist-get (alist-get name dape-configs) 'modes)))
      (my/dape-update-config name
                             'ensure #'dape-ensure-command
                             'command "js-debug"
                             'command-args '(:autoport "127.0.0.1")
                             'host "127.0.0.1"
                             'modes (if (and (memq 'typescript-ts-mode modes)
                                             (not (memq 'tsx-ts-mode modes)))
                                        (cons 'tsx-ts-mode modes)
                                      modes))))

  ;; dape's stock `lldb-dap' and `lldb-vscode' claim every rust mode while
  ;; launching `:program "a.out"', which no cargo project produces. devenv's
  ;; clang toolchain puts lldb-dap on PATH, so the entry passes `ensure' and
  ;; `dape' has two candidates for a rust buffer -- and it only prefills the
  ;; "Run adapter: " prompt when exactly one config is suggested, so every
  ;; session had to be typed out. codelldb-rust supersedes them for rust; C
  ;; and C++ keep them.
  (dolist (name '(lldb-dap lldb-vscode))
    (my/dape-update-config
     name 'modes
     (cl-remove-if (lambda (mode)
                     (memq mode '(rust-mode rust-ts-mode rustic-mode)))
                   (plist-get (alist-get name dape-configs) 'modes)))))

;; Selecting a configuration ----------------------------------------------------
;; `dape' reads its configuration with `read-from-minibuffer' plus a
;; `completion-at-point' table (`dape--read-config'), which vertico never sees
;; -- vertico only drives `completing-read'. In this config TAB there pops
;; corfu instead, and dape prefills the prompt only when exactly one
;; configuration is suggested, so a rust buffer with a live `lldb-dap' on PATH
;; meant typing the name out every time.
;;
;; These commands live outside the `use-package' form on purpose: `SPC d d' is
;; bound to `my/dape' (config/key-mapping.el), and a command defined in
;; `:config' would not exist until something else had already loaded dape.

(defun my/dape--suggested-configs ()
  "Return names of `dape-configs' entries offered for the current buffer.
The test is `dape--read-config's own: the configuration's `modes' cover
this buffer and its `ensure' finds the adapter installed."
  (cl-loop for (name . config) in dape-configs
           when (and (dape--config-mode-p config)
                     (ignore-errors (dape--config-ensure config)))
           collect (symbol-name name)))

(defun my/dape--annotate-config (name)
  "Annotate configuration NAME with the adapter it launches.
The raw `command' is read rather than `dape-config-get': evaluating it
would run `my/dape-cargo-program', and with it a `cargo metadata'
subprocess, for every candidate on every keystroke."
  (when-let* ((config (alist-get (intern name) dape-configs))
              (command (plist-get config 'command))
              ;; Adapters unpacked under `dape-adapter-dir' carry an absolute
              ;; path as their command; only its last element identifies them.
              (label (if (stringp command)
                         (file-name-nondirectory command)
                       (plist-get config :type))))
    (concat "  " (propertize label 'face 'completions-annotations))))

(defun my/dape-read-config ()
  "Read a `dape-configs' entry through `completing-read'.
Configurations suggested for this buffer are grouped first; the rest
stay one `orderless' pattern away.  A match is not required, because
both readers end in `dape--config-from-string': options can still be
typed after the name, completion just stops offering candidates."
  (let* ((suggested (my/dape--suggested-configs))
         (names (append suggested
                        (cl-loop for (name . _config) in dape-configs
                                 for string = (symbol-name name)
                                 unless (member string suggested)
                                 collect string)))
         (table
          (lambda (string predicate action)
            (if (eq action 'metadata)
                `(metadata
                  (category . dape-config)
                  (annotation-function . ,#'my/dape--annotate-config)
                  (group-function
                   . ,(lambda (name transform)
                        (cond (transform name)
                              ((member name suggested) "Suggested here")
                              (t "All configurations"))))
                  ;; NAMES is already ordered suggested-first; without this
                  ;; vertico re-sorts alphabetically and buries them.
                  (display-sort-function . ,#'identity)
                  (cycle-sort-function . ,#'identity))
              (complete-with-action action names string predicate))))
         (input (string-trim
                 (completing-read "Run adapter: " table nil nil nil
                                  'dape-history))))
    (when (string-empty-p input)
      (user-error "No configuration selected"))
    ;; `dape-restart' re-runs `(car dape-history)' when no session is live, so
    ;; the selection has to land there. `completing-read' already pushes it
    ;; through its HIST argument, but only when reading a real minibuffer;
    ;; `add-to-history' makes that unconditional and deduplicates.
    (add-to-history 'dape-history input)
    input))

(defun my/dape (&optional edit)
  "Start a debug session, selecting the configuration with completion.
With prefix argument EDIT, hand the selection to dape's own prompt
prefilled instead: it completes configuration keys and file names, and
shows the expanded configuration as a hint, which `completing-read'
cannot.  Plain `dape' stays on `SPC d D' for the same reason."
  (interactive "P")
  (require 'dape)
  (pcase-let* ((input (my/dape-read-config))
               (`(,key ,config) (dape--config-from-string input)))
    (if edit
        ;; `dape--read-config' seeds its prompt from `dape-command', so this
        ;; re-enters dape's own reader with the selection already typed in.
        (let ((dape-command (cons key config)))
          (call-interactively #'dape))
      ;; Mirrors the tail of `dape's `interactive' form, which is skipped when
      ;; `dape' is called with a configuration already in hand.
      (when-let* ((live (dape--live-connections-root)))
        (when (yes-or-no-p
               (format "Session(s) %s running; kill? "
                       (mapconcat (lambda (conn)
                                    (string-remove-prefix "dape-" (jsonrpc-name conn)))
                                  live ", ")))
          (dape--kill-busy-wait)))
      (dape (let ((default-directory (dape--guess-root config)))
              (dape--config-eval key config))))))
