{ pkgs, lib, ... }:

let
  box64 = pkgs.box64.overrideAttrs (oldAttrs: {
    enableParallelBuilding = false;
    cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
      "-DRPI4ARM64=1"
      "-DBOX32=ON"
      "-DBOX32_BINFMT=ON"
    ];
  });
in
{
  environment.systemPackages = with pkgs; [
    vim
    wget
    sudo
    htop
    tmux
    file
    git
    binutils

    # Box64
    box64
    pkgs.pkgsCross.gnu32.stdenv.cc.cc.lib
    pkgs.pkgsCross.gnu32.glibc
  ];

  environment.sessionVariables.BOX64_LD_LIBRARY_PATH = lib.makeLibraryPath [
    pkgs.pkgsCross.gnu32.stdenv.cc.cc.lib
    pkgs.pkgsCross.gnu32.glibc
  ];

  boot.binfmt.registrations = {
    x86_64-linux = {
      interpreter      = "${box64}/bin/box64";
      magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
      mask             = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
    i386-linux = {
      interpreter      = "${box64}/bin/box64";
      magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03\x00'';
      mask             = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
  };
}
