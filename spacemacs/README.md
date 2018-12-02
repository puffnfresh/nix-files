# spacemacs2nix

You can generate an attribute set of layers to packages via:

```
./spacemacs2nix.el > all-spacemacs-packages.nix
```

And you can generate the transitive list of layers your `~/.spacemacs` uses via:

```
./dotspacemacs-used-layers.el > $USER-layers.nix
```

Then you can build an Emacs with all of your packages:

```
nix-build -E "with import <nixpkgs> { }; (callPackage ./spacemacs-with-layers.nix { }) (import ./$USER-layers.nix)"
```

You need to change `~/.spacemacs` to make it not attempt deleting system packages:

```elisp
dotspacemacs-install-packages 'used-but-keep-unused
```
