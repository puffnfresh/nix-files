{
  users.users.brian = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "dialout" ];
    openssh.authorizedKeys.keys = [
      (builtins.readFile ./brian.pub)
    ];
  };
}
