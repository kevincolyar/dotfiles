# Emacs

## Profile Startup Time

    emacs -nw -f use-package-report

## Update Packages

    emacs -nw -f auto-package-update-now

## Remove all Packages

    cd ~/.emacs.d && rm -rf eln-cache elpa quelpa; cd -;
