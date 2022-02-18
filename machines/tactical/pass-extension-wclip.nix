{ writeTextFile, runtimeShell, wclip }:

writeTextFile {
  name = "pass-extension-wclip";
  executable = true;
  destination = "/lib/password-store/extensions/wclip.bash";
  text = ''
   #!${runtimeShell}
   clip() {
     echo -n "$1" | ${wclip}/bin/wclip.exe --secret
   }
   cmd_show --clip "$@"
  '';
}
