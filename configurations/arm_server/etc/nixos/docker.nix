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

  virtualisation.docker = {
    enable = true;
  };

  environment.shellAliases = {
    runx64 = "docker run --platform linux/amd64 --rm -it";
  };
}
