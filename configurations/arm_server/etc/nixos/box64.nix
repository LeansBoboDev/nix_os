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

  i686Libs = [
    pkgs.pkgsCross.gnu32.stdenv.cc.cc.lib
    pkgs.pkgsCross.gnu32.glibc
  ];
in
{
  environment.systemPackages = [ box64 ] ++ i686Libs;

  environment.sessionVariables.BOX64_LD_LIBRARY_PATH = ".:bin/:" + lib.makeLibraryPath i686Libs;
}
