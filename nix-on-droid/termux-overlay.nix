self: super: {
  htop = super.htop.overrideDerivation (drv: {
    patches = [
      (self.fetchpatch {
        url = "https://raw.githubusercontent.com/termux/termux-packages/master/packages/htop/fix-missing-macros.patch";
        sha256 = "1cljkjagp66xxcjb6y1m9k4v994slfkd0s6fijh02l3rp8ycvjnv";
      })
    ];
  });
}
