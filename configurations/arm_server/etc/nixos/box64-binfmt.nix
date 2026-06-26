{ lib, pkgs, config, ... }:

let
  cfg   = config.box64-binfmt;
  box64 = pkgs.callPackage ./box64.nix { };

  nativeBox64Libs = with pkgs; [
    alsa-lib libpulseaudio libsndfile openal
    SDL2 SDL2_image SDL2_mixer SDL2_ttf SDL2_net
    SDL SDL_image SDL_mixer SDL_ttf SDL_net
    libGL libGLU vulkan-loader wayland
    xorg.libX11 xorg.libXext xorg.libXrandr xorg.libXrender xorg.libxcb
    xorg.libXfixes xorg.libXcomposite xorg.libXcursor xorg.libXdamage xorg.libXi
    xorg.libXinerama xorg.libXScrnSaver xorg.libSM xorg.libICE
    fontconfig freetype
    libdrm libvdpau libvorbis libogg
    gtk2 gtk3 glib dbus util-linux
  ];

  box64Wrapper = pkgs.writeShellScript "box64-wrapper" ''
    export BOX64_LD_LIBRARY_PATH="${lib.makeLibraryPath nativeBox64Libs}''${BOX64_LD_LIBRARY_PATH:+:$BOX64_LD_LIBRARY_PATH}"
    export LIBGL_ALWAYS_SOFTWARE=1
    exec ${box64}/bin/box64 "$@"
  '';

in
{
  options.box64-binfmt = {
    enable = lib.mkOption {
      type    = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {

    boot.binfmt.preferStaticEmulators = false;

    boot.binfmt.registrations = {
      "x86_64-linux" = {
        interpreter            = "${box64Wrapper}";
        magicOrExtension       = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
        mask                   = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
        wrapInterpreterInShell = false;
        preserveArgvZero       = false;
        openBinary             = false;
      };
      "i386-linux" = {
        interpreter            = "${box64Wrapper}";
        magicOrExtension       = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03\x00'';
        mask                   = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
        wrapInterpreterInShell = false;
        preserveArgvZero       = false;
        openBinary             = false;
      };
      "i686-linux" = {
        interpreter            = "${box64Wrapper}";
        magicOrExtension       = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x06\x00'';
        mask                   = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
        wrapInterpreterInShell = false;
        preserveArgvZero       = false;
        openBinary             = false;
      };
    };

    nix.settings.extra-platforms = [
      "x86_64-linux"
      "i686-linux"
      "i386-linux"
    ];

    environment.systemPackages = [ box64 ];

    nixpkgs.overlays = [
      (final: prev: {
        x86 = import pkgs.path {
          system = "x86_64-linux";
          config.allowUnfree = true;
          config.allowUnsupportedSystem = true;
        };
      })
    ];
  };
}
