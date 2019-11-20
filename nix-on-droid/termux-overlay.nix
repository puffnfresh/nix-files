self: super: {
  openssh = openssh.overrideDerivation (drv: {
    patches = [
      (fetchpatch {
        url = "https://raw.githubusercontent.com/termux/termux-packages/1ff10e5c361fab8faf2b107dd206f75d4be3dbbd/packages/openssh/sshd.c.patch";
        sha256 = "12b35lid3qskyhwn7a4ls3zp06d1l8mxdhdzxpr4zbbgfi3jl7qg";
      })
    ];
  });
  htop = super.htop.overrideDerivation (drv: {
    patches = [
      (self.fetchpatch {
        url = "https://raw.githubusercontent.com/termux/termux-packages/master/packages/htop/fix-missing-macros.patch";
        sha256 = "1cljkjagp66xxcjb6y1m9k4v994slfkd0s6fijh02l3rp8ycvjnv";
      })
    ];
  });
}
