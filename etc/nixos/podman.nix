{ config, lib, pkgs, ... }:
{
  # Workaround for https://github.com/NixOS/nixpkgs/issues/392673
  nixpkgs.overlays = [
    (final: previous: {
      nettle = previous.nettle.overrideAttrs (
        lib.optionalAttrs final.stdenv.hostPlatform.isStatic {
          CCPIC = "-fPIC";
        }
      );
    })
    (final: previous: {
      qemu-user = previous.qemu-user.overrideAttrs (
        old:
        lib.optionalAttrs final.stdenv.hostPlatform.isStatic {
          configureFlags = old.configureFlags ++ [ "--disable-pie" ];
        }
      );
    })
  ];

  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
  boot.binfmt.preferStaticEmulators = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
