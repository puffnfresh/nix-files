{ runCommand, fetchzip }:

runCommand "kobo-clara2e-firmware" {
  src = fetchzip {
    url = "https://kbdownload1-a.akamaihd.net/firmwares/kobo10/Dec2022/kobo-update-4.35.20400.zip";
    stripRoot = false;
    sha256 = "sha256-OgrzDpvYvE2di5QN8f7vACQqVv6/f9tk2CLsJqUbJ5w=";
  };
} ''
  mkdir -p "$out/lib/firmware/imx/epdc"
  cp -vf ${./blobs/400_B080_HH3201_ED060KHCC1_VD1405-FOD_TC1.fw} \
    $out/lib/firmware/imx/epdc/epdc.fw

  mkdir -p "$out/lib/firmware/mrvl"
  tar xOf $src/KoboRoot.tgz ./lib/firmware/nxp/sdiouart8987_combo_v0.bin \
    > "$out/lib/firmware/mrvl/sd8987_uapsta.bin"
''
