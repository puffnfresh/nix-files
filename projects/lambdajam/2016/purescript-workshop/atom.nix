{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."atom-linter"."^3.0.0" =
    self.by-version."atom-linter"."3.4.1";
  by-version."atom-linter"."3.4.1" = self.buildNodePackage {
    name = "atom-linter-3.4.1";
    version = "3.4.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/atom-linter/-/atom-linter-3.4.1.tgz";
      name = "atom-linter-3.4.1.tgz";
      sha1 = "9c287a40d313ac0d5a1bcf1acac258c46919bb2f";
    };
    deps = {
      "xregexp-2.0.0" = self.by-version."xregexp"."2.0.0";
      "tmp-0.0.28" = self.by-version."tmp"."0.0.28";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."atom-package-deps"."^4.0.1" =
    self.by-version."atom-package-deps"."4.0.1";
  by-version."atom-package-deps"."4.0.1" = self.buildNodePackage {
    name = "atom-package-deps-4.0.1";
    version = "4.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/atom-package-deps/-/atom-package-deps-4.0.1.tgz";
      name = "atom-package-deps-4.0.1.tgz";
      sha1 = "cca45c77723d85b4e15dff72ab93f7700befe104";
    };
    deps = {
      "atom-package-path-1.1.0" = self.by-version."atom-package-path"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."atom-package-path"."^1.1.0" =
    self.by-version."atom-package-path"."1.1.0";
  by-version."atom-package-path"."1.1.0" = self.buildNodePackage {
    name = "atom-package-path-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/atom-package-path/-/atom-package-path-1.1.0.tgz";
      name = "atom-package-path-1.1.0.tgz";
      sha1 = "b51fedbc00e7c8ce5223d0d803db7a3f4f69614f";
    };
    deps = {
      "sb-callsite-1.1.2" = self.by-version."sb-callsite"."1.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."atom-space-pen-views"."^2.0.3" =
    self.by-version."atom-space-pen-views"."2.2.0";
  by-version."atom-space-pen-views"."2.2.0" = self.buildNodePackage {
    name = "atom-space-pen-views-2.2.0";
    version = "2.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/atom-space-pen-views/-/atom-space-pen-views-2.2.0.tgz";
      name = "atom-space-pen-views-2.2.0.tgz";
      sha1 = "a65b2c920ed02f724014fa7d3e5c3d78fbf59997";
    };
    deps = {
      "fuzzaldrin-2.1.0" = self.by-version."fuzzaldrin"."2.1.0";
      "space-pen-5.1.2" = self.by-version."space-pen"."5.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."atom-space-pen-views"."^2.1.0" =
    self.by-version."atom-space-pen-views"."2.2.0";
  by-spec."balanced-match"."^0.3.0" =
    self.by-version."balanced-match"."0.3.0";
  by-version."balanced-match"."0.3.0" = self.buildNodePackage {
    name = "balanced-match-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/balanced-match/-/balanced-match-0.3.0.tgz";
      name = "balanced-match-0.3.0.tgz";
      sha1 = "a91cdd1ebef1a86659e70ff4def01625fc2d6756";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."brace-expansion"."^1.0.0" =
    self.by-version."brace-expansion"."1.1.3";
  by-version."brace-expansion"."1.1.3" = self.buildNodePackage {
    name = "brace-expansion-1.1.3";
    version = "1.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.3.tgz";
      name = "brace-expansion-1.1.3.tgz";
      sha1 = "46bff50115d47fc9ab89854abb87d98078a10991";
    };
    deps = {
      "balanced-match-0.3.0" = self.by-version."balanced-match"."0.3.0";
      "concat-map-0.0.1" = self.by-version."concat-map"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."concat-map"."0.0.1" =
    self.by-version."concat-map"."0.0.1";
  by-version."concat-map"."0.0.1" = self.buildNodePackage {
    name = "concat-map-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz";
      name = "concat-map-0.0.1.tgz";
      sha1 = "d8a96bd77fd68df7793a73036a3ba0d5405d477b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."d"."^0.1.1" =
    self.by-version."d"."0.1.1";
  by-version."d"."0.1.1" = self.buildNodePackage {
    name = "d-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/d/-/d-0.1.1.tgz";
      name = "d-0.1.1.tgz";
      sha1 = "da184c535d18d8ee7ba2aa229b914009fae11309";
    };
    deps = {
      "es5-ext-0.10.11" = self.by-version."es5-ext"."0.10.11";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."d"."~0.1.1" =
    self.by-version."d"."0.1.1";
  by-spec."emissary"."^1.2.0" =
    self.by-version."emissary"."1.3.3";
  by-version."emissary"."1.3.3" = self.buildNodePackage {
    name = "emissary-1.3.3";
    version = "1.3.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/emissary/-/emissary-1.3.3.tgz";
      name = "emissary-1.3.3.tgz";
      sha1 = "a618d92d682b232d31111dc3625a5df661799606";
    };
    deps = {
      "underscore-plus-1.6.6" = self.by-version."underscore-plus"."1.6.6";
      "mixto-1.0.0" = self.by-version."mixto"."1.0.0";
      "property-accessors-1.1.3" = self.by-version."property-accessors"."1.1.3";
      "es6-weak-map-0.1.4" = self.by-version."es6-weak-map"."0.1.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."emissary"."^1.3.3" =
    self.by-version."emissary"."1.3.3";
  by-spec."es5-ext"."^0.10.7" =
    self.by-version."es5-ext"."0.10.11";
  by-version."es5-ext"."0.10.11" = self.buildNodePackage {
    name = "es5-ext-0.10.11";
    version = "0.10.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/es5-ext/-/es5-ext-0.10.11.tgz";
      name = "es5-ext-0.10.11.tgz";
      sha1 = "8184c3e705a820948c2dbe043849379b1dbd0c45";
    };
    deps = {
      "es6-iterator-2.0.0" = self.by-version."es6-iterator"."2.0.0";
      "es6-symbol-3.0.2" = self.by-version."es6-symbol"."3.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es5-ext"."~0.10.10" =
    self.by-version."es5-ext"."0.10.11";
  by-spec."es5-ext"."~0.10.2" =
    self.by-version."es5-ext"."0.10.11";
  by-spec."es5-ext"."~0.10.5" =
    self.by-version."es5-ext"."0.10.11";
  by-spec."es5-ext"."~0.10.6" =
    self.by-version."es5-ext"."0.10.11";
  by-spec."es6-iterator"."2" =
    self.by-version."es6-iterator"."2.0.0";
  by-version."es6-iterator"."2.0.0" = self.buildNodePackage {
    name = "es6-iterator-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/es6-iterator/-/es6-iterator-2.0.0.tgz";
      name = "es6-iterator-2.0.0.tgz";
      sha1 = "bd968567d61635e33c0b80727613c9cb4b096bac";
    };
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.11" = self.by-version."es5-ext"."0.10.11";
      "es6-symbol-3.0.2" = self.by-version."es6-symbol"."3.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es6-iterator"."~0.1.3" =
    self.by-version."es6-iterator"."0.1.3";
  by-version."es6-iterator"."0.1.3" = self.buildNodePackage {
    name = "es6-iterator-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/es6-iterator/-/es6-iterator-0.1.3.tgz";
      name = "es6-iterator-0.1.3.tgz";
      sha1 = "d6f58b8c4fc413c249b4baa19768f8e4d7c8944e";
    };
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.11" = self.by-version."es5-ext"."0.10.11";
      "es6-symbol-2.0.1" = self.by-version."es6-symbol"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es6-symbol"."3" =
    self.by-version."es6-symbol"."3.0.2";
  by-version."es6-symbol"."3.0.2" = self.buildNodePackage {
    name = "es6-symbol-3.0.2";
    version = "3.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/es6-symbol/-/es6-symbol-3.0.2.tgz";
      name = "es6-symbol-3.0.2.tgz";
      sha1 = "1e928878c6f5e63541625b4bb4df4af07d154219";
    };
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.11" = self.by-version."es5-ext"."0.10.11";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es6-symbol"."~2.0.1" =
    self.by-version."es6-symbol"."2.0.1";
  by-version."es6-symbol"."2.0.1" = self.buildNodePackage {
    name = "es6-symbol-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/es6-symbol/-/es6-symbol-2.0.1.tgz";
      name = "es6-symbol-2.0.1.tgz";
      sha1 = "761b5c67cfd4f1d18afb234f691d678682cb3bf3";
    };
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.11" = self.by-version."es5-ext"."0.10.11";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es6-symbol"."~3.0.2" =
    self.by-version."es6-symbol"."3.0.2";
  by-spec."es6-weak-map"."^0.1.2" =
    self.by-version."es6-weak-map"."0.1.4";
  by-version."es6-weak-map"."0.1.4" = self.buildNodePackage {
    name = "es6-weak-map-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/es6-weak-map/-/es6-weak-map-0.1.4.tgz";
      name = "es6-weak-map-0.1.4.tgz";
      sha1 = "706cef9e99aa236ba7766c239c8b9e286ea7d228";
    };
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.11" = self.by-version."es5-ext"."0.10.11";
      "es6-iterator-0.1.3" = self.by-version."es6-iterator"."0.1.3";
      "es6-symbol-2.0.1" = self.by-version."es6-symbol"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fs"."~0.0.2" =
    self.by-version."fs"."0.0.2";
  by-version."fs"."0.0.2" = self.buildNodePackage {
    name = "fs-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fs/-/fs-0.0.2.tgz";
      name = "fs-0.0.2.tgz";
      sha1 = "e1f244ef3933c1b2a64bd4799136060d0f5914f8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fuzzaldrin"."^2.1.0" =
    self.by-version."fuzzaldrin"."2.1.0";
  by-version."fuzzaldrin"."2.1.0" = self.buildNodePackage {
    name = "fuzzaldrin-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fuzzaldrin/-/fuzzaldrin-2.1.0.tgz";
      name = "fuzzaldrin-2.1.0.tgz";
      sha1 = "90204c3e2fdaa6941bb28d16645d418063a90e9b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."^5.0.14" =
    self.by-version."glob"."5.0.15";
  by-version."glob"."5.0.15" = self.buildNodePackage {
    name = "glob-5.0.15";
    version = "5.0.15";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/glob/-/glob-5.0.15.tgz";
      name = "glob-5.0.15.tgz";
      sha1 = "1bc936b9e02f4a603fcc222ecf7633d30b8b93b1";
    };
    deps = {
      "inflight-1.0.4" = self.by-version."inflight"."1.0.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-3.0.0" = self.by-version."minimatch"."3.0.0";
      "once-1.3.3" = self.by-version."once"."1.3.3";
      "path-is-absolute-1.0.0" = self.by-version."path-is-absolute"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."grim"."^1.0.0" =
    self.by-version."grim"."1.5.0";
  by-version."grim"."1.5.0" = self.buildNodePackage {
    name = "grim-1.5.0";
    version = "1.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/grim/-/grim-1.5.0.tgz";
      name = "grim-1.5.0.tgz";
      sha1 = "b32b08ef567cf1852f81759ed9c68b0d71396a32";
    };
    deps = {
      "emissary-1.3.3" = self.by-version."emissary"."1.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hover-tooltips"."^0.5.0" =
    self.by-version."hover-tooltips"."0.5.0";
  by-version."hover-tooltips"."0.5.0" = self.buildNodePackage {
    name = "hover-tooltips-0.5.0";
    version = "0.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/hover-tooltips/-/hover-tooltips-0.5.0.tgz";
      name = "hover-tooltips-0.5.0.tgz";
      sha1 = "2e7cfc83dc45f685bc84e44111366af2cd945c2f";
    };
    deps = {
      "emissary-1.3.3" = self.by-version."emissary"."1.3.3";
      "atom-space-pen-views-2.2.0" = self.by-version."atom-space-pen-views"."2.2.0";
      "fs-0.0.2" = self.by-version."fs"."0.0.2";
      "q-1.0.1" = self.by-version."q"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ide-purescript"."https://github.com/nwolverson/atom-ide-purescript/archive/v0.13.0.tar.gz" =
    self.by-version."ide-purescript"."0.13.0";
  by-version."ide-purescript"."0.13.0" = self.buildNodePackage {
    name = "ide-purescript-0.13.0";
    version = "0.13.0";
    bin = false;
    src = fetchurl {
      url = "https://github.com/nwolverson/atom-ide-purescript/archive/v0.13.0.tar.gz";
      name = "ide-purescript-0.13.0.tgz";
      sha256 = "8f1f89e3a5ebc9f52a25318c9152f3796f52cbdfbca48a62c28a7bc5ac991669";
    };
    deps = {
      "atom-linter-3.4.1" = self.by-version."atom-linter"."3.4.1";
      "atom-package-deps-4.0.1" = self.by-version."atom-package-deps"."4.0.1";
      "atom-space-pen-views-2.2.0" = self.by-version."atom-space-pen-views"."2.2.0";
      "glob-5.0.15" = self.by-version."glob"."5.0.15";
      "hover-tooltips-0.5.0" = self.by-version."hover-tooltips"."0.5.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "ide-purescript" = self.by-version."ide-purescript"."0.13.0";
  by-spec."inflight"."^1.0.4" =
    self.by-version."inflight"."1.0.4";
  by-version."inflight"."1.0.4" = self.buildNodePackage {
    name = "inflight-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/inflight/-/inflight-1.0.4.tgz";
      name = "inflight-1.0.4.tgz";
      sha1 = "6cbb4521ebd51ce0ec0a936bfd7657ef7e9b172a";
    };
    deps = {
      "once-1.3.3" = self.by-version."once"."1.3.3";
      "wrappy-1.0.1" = self.by-version."wrappy"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inherits"."2" =
    self.by-version."inherits"."2.0.1";
  by-version."inherits"."2.0.1" = self.buildNodePackage {
    name = "inherits-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/inherits/-/inherits-2.0.1.tgz";
      name = "inherits-2.0.1.tgz";
      sha1 = "b17d08d326b4423e568eff719f91b0b1cbdf69f1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."interact.js"."^1.2.5" =
    self.by-version."interact.js"."1.2.6";
  by-version."interact.js"."1.2.6" = self.buildNodePackage {
    name = "interact.js-1.2.6";
    version = "1.2.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/interact.js/-/interact.js-1.2.6.tgz";
      name = "interact.js-1.2.6.tgz";
      sha1 = "06758900ca1f8534acba2362131d1adf5a48a71f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jquery"."2.1.4" =
    self.by-version."jquery"."2.1.4";
  by-version."jquery"."2.1.4" = self.buildNodePackage {
    name = "jquery-2.1.4";
    version = "2.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jquery/-/jquery-2.1.4.tgz";
      name = "jquery-2.1.4.tgz";
      sha1 = "228bde698a0c61431dc2630a6a154f15890d2317";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."language-purescript"."https://github.com/purescript-contrib/atom-language-purescript/archive/v0.7.0.tar.gz" =
    self.by-version."language-purescript"."0.7.0";
  by-version."language-purescript"."0.7.0" = self.buildNodePackage {
    name = "language-purescript-0.7.0";
    version = "0.7.0";
    bin = false;
    src = fetchurl {
      url = "https://github.com/purescript-contrib/atom-language-purescript/archive/v0.7.0.tar.gz";
      name = "language-purescript-0.7.0.tgz";
      sha256 = "ea42223427e1bde9024185aaf94e621a550ba8799ba81235e194cbc87270a78c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "language-purescript" = self.by-version."language-purescript"."0.7.0";
  by-spec."linter"."https://github.com/steelbrain/linter/archive/v1.11.4.tar.gz" =
    self.by-version."linter"."1.11.4";
  by-version."linter"."1.11.4" = self.buildNodePackage {
    name = "linter-1.11.4";
    version = "1.11.4";
    bin = false;
    src = fetchurl {
      url = "https://github.com/steelbrain/linter/archive/v1.11.4.tar.gz";
      name = "linter-1.11.4.tgz";
      sha256 = "31313329596ba73a47a7da798c8e3588aa17d0ffc0b73b395805c94f2e5cd712";
    };
    deps = {
      "interact.js-1.2.6" = self.by-version."interact.js"."1.2.6";
      "minimatch-3.0.0" = self.by-version."minimatch"."3.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "linter" = self.by-version."linter"."1.11.4";
  by-spec."minimatch"."2 || 3" =
    self.by-version."minimatch"."3.0.0";
  by-version."minimatch"."3.0.0" = self.buildNodePackage {
    name = "minimatch-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/minimatch/-/minimatch-3.0.0.tgz";
      name = "minimatch-3.0.0.tgz";
      sha1 = "5236157a51e4f004c177fb3c527ff7dd78f0ef83";
    };
    deps = {
      "brace-expansion-1.1.3" = self.by-version."brace-expansion"."1.1.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimatch"."^3.0.0" =
    self.by-version."minimatch"."3.0.0";
  by-spec."mixto"."1.x" =
    self.by-version."mixto"."1.0.0";
  by-version."mixto"."1.0.0" = self.buildNodePackage {
    name = "mixto-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mixto/-/mixto-1.0.0.tgz";
      name = "mixto-1.0.0.tgz";
      sha1 = "c320ef61b52f2898f522e17d8bbc6d506d8425b6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."once"."^1.3.0" =
    self.by-version."once"."1.3.3";
  by-version."once"."1.3.3" = self.buildNodePackage {
    name = "once-1.3.3";
    version = "1.3.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/once/-/once-1.3.3.tgz";
      name = "once-1.3.3.tgz";
      sha1 = "b2e261557ce4c314ec8304f3fa82663e4297ca20";
    };
    deps = {
      "wrappy-1.0.1" = self.by-version."wrappy"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."os-tmpdir"."~1.0.1" =
    self.by-version."os-tmpdir"."1.0.1";
  by-version."os-tmpdir"."1.0.1" = self.buildNodePackage {
    name = "os-tmpdir-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.1.tgz";
      name = "os-tmpdir-1.0.1.tgz";
      sha1 = "e9b423a1edaf479882562e92ed71d7743a071b6e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-is-absolute"."^1.0.0" =
    self.by-version."path-is-absolute"."1.0.0";
  by-version."path-is-absolute"."1.0.0" = self.buildNodePackage {
    name = "path-is-absolute-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.0.tgz";
      name = "path-is-absolute-1.0.0.tgz";
      sha1 = "263dada66ab3f2fb10bf7f9d24dd8f3e570ef912";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."property-accessors"."^1.1" =
    self.by-version."property-accessors"."1.1.3";
  by-version."property-accessors"."1.1.3" = self.buildNodePackage {
    name = "property-accessors-1.1.3";
    version = "1.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/property-accessors/-/property-accessors-1.1.3.tgz";
      name = "property-accessors-1.1.3.tgz";
      sha1 = "1dde84024631865909ef30703365680c5f928b15";
    };
    deps = {
      "mixto-1.0.0" = self.by-version."mixto"."1.0.0";
      "es6-weak-map-0.1.4" = self.by-version."es6-weak-map"."0.1.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."q"."~1.0.0" =
    self.by-version."q"."1.0.1";
  by-version."q"."1.0.1" = self.buildNodePackage {
    name = "q-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/q/-/q-1.0.1.tgz";
      name = "q-1.0.1.tgz";
      sha1 = "11872aeedee89268110b10a718448ffb10112a14";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sb-callsite"."^1.1.2" =
    self.by-version."sb-callsite"."1.1.2";
  by-version."sb-callsite"."1.1.2" = self.buildNodePackage {
    name = "sb-callsite-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/sb-callsite/-/sb-callsite-1.1.2.tgz";
      name = "sb-callsite-1.1.2.tgz";
      sha1 = "28191fb66d64e3a3ee92084a95a90fcb5102243b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."space-pen"."^5.1.2" =
    self.by-version."space-pen"."5.1.2";
  by-version."space-pen"."5.1.2" = self.buildNodePackage {
    name = "space-pen-5.1.2";
    version = "5.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/space-pen/-/space-pen-5.1.2.tgz";
      name = "space-pen-5.1.2.tgz";
      sha1 = "22fbbe10e0b044e7b7a47b023da99d94b584ef8f";
    };
    deps = {
      "grim-1.5.0" = self.by-version."grim"."1.5.0";
      "jquery-2.1.4" = self.by-version."jquery"."2.1.4";
      "underscore-plus-1.6.6" = self.by-version."underscore-plus"."1.6.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tmp"."*" =
    self.by-version."tmp"."0.0.28";
  by-version."tmp"."0.0.28" = self.buildNodePackage {
    name = "tmp-0.0.28";
    version = "0.0.28";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tmp/-/tmp-0.0.28.tgz";
      name = "tmp-0.0.28.tgz";
      sha1 = "172735b7f614ea7af39664fa84cf0de4e515d120";
    };
    deps = {
      "os-tmpdir-1.0.1" = self.by-version."os-tmpdir"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."underscore"."~1.6.0" =
    self.by-version."underscore"."1.6.0";
  by-version."underscore"."1.6.0" = self.buildNodePackage {
    name = "underscore-1.6.0";
    version = "1.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/underscore/-/underscore-1.6.0.tgz";
      name = "underscore-1.6.0.tgz";
      sha1 = "8b38b10cacdef63337b8b24e4ff86d45aea529a8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."underscore-plus"."1.x" =
    self.by-version."underscore-plus"."1.6.6";
  by-version."underscore-plus"."1.6.6" = self.buildNodePackage {
    name = "underscore-plus-1.6.6";
    version = "1.6.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/underscore-plus/-/underscore-plus-1.6.6.tgz";
      name = "underscore-plus-1.6.6.tgz";
      sha1 = "65ecde1bdc441a35d89e650fd70dcf13ae439a7d";
    };
    deps = {
      "underscore-1.6.0" = self.by-version."underscore"."1.6.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."wrappy"."1" =
    self.by-version."wrappy"."1.0.1";
  by-version."wrappy"."1.0.1" = self.buildNodePackage {
    name = "wrappy-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/wrappy/-/wrappy-1.0.1.tgz";
      name = "wrappy-1.0.1.tgz";
      sha1 = "1e65969965ccbc2db4548c6b84a6f2c5aedd4739";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xregexp"."^2.0.0" =
    self.by-version."xregexp"."2.0.0";
  by-version."xregexp"."2.0.0" = self.buildNodePackage {
    name = "xregexp-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/xregexp/-/xregexp-2.0.0.tgz";
      name = "xregexp-2.0.0.tgz";
      sha1 = "52a63e56ca0b84a7f3a5f3d61872f126ad7a5943";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
}
