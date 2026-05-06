{ lib, buildUBoot, fetchFromGitHub }:

buildUBoot {
  version = "2023.10-clara2e";

  src = fetchFromGitHub {
    owner = "akemnade";
    repo = "u-boot-fslc";
    rev = "1f55e1ef7b1ac1e0cdb1375e787f287c33599220";
    hash = "sha256-B6iws88sIs9gPrhjAlZIn/GCicKQbsRZqpBlzUTjIa8=";
  };

  defconfig = "mx6sllclara2e_defconfig";

  extraConfig = ''
    CONFIG_BOOTCOMMAND="run detect_clara2erev ; run distro_bootcmd ; fastboot 0"
    CONFIG_ENV_IS_IN_EXT4=y
    # CONFIG_ENV_IS_IN_MMC is not set
    CONFIG_ENV_EXT4_INTERFACE="mmc"
    CONFIG_ENV_EXT4_DEVICE_AND_PART="0:1"
    CONFIG_ENV_EXT4_FILE="/uboot.env"
  '';

  filesToInstall = [ "u-boot-dtb.imx" ];

  meta = with lib; {
    description = "U-Boot for Kobo Clara 2E";
    homepage = "https://github.com/akemnade/u-boot-fslc";
    license = licenses.gpl2;
    platforms = [ "armv7l-linux" ];
  };
}
