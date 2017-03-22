addLdLibraryPath () {
    if [ -d $1/lib ]; then
        export NIX_LD_LIBRARY_PATH="$1/lib${NIX_LD_LIBRARY_PATH:+:}$NIX_LD_LIBRARY_PATH"
    fi
}

runBinary() {
    LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH:$LD_LIBRARY_PATH $(< $NIX_CC/nix-support/dynamic-linker) $@
}

envHooks+=(addLdLibraryPath)
