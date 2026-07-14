{ pkgs, ... }:

let
  # Official Microsoft .NET runtime — compiled for ARMv8.0 (no LSE).
  # NixOS's dotnet-runtime_10 is built with ARMv8.1+ LSE instructions,
  # which crash on Raspberry Pi 4 (Cortex-A72, ARMv8.0) with SIGILL.
  dotnet-ms-runtime = pkgs.stdenv.mkDerivation {
    pname = "dotnet-ms-runtime";
    version = "10.0.8";

    src = pkgs.fetchurl {
      url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.8/dotnet-runtime-10.0.8-linux-arm64.tar.gz";
      # If this hash is wrong, nixos-rebuild will fail and print the correct hash.
      # Replace this value with what it prints (e.g. "sha256-ABC...=").
      hash = "sha256-AHqlJIEcZeE8HaLFs234bG4YUxCAMmgfrSON7O1hfBE=";
    };

    # The tarball extracts files to the root (no wrapping directory).
    sourceRoot = ".";
    dontBuild = true;
    dontStrip = true;

    nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeWrapper ];
    buildInputs = with pkgs; [
      stdenv.cc.cc.lib
      libunwind
      icu
      openssl
      zlib
      krb5
    ];

    # liblttng-ust.so.0 (v2.12) is only the tracing/profiling provider and is not
    # required to run .NET apps. nixpkgs ships lttng-ust v2.13+ (liblttng-ust.so.1).
    autoPatchelfIgnoreMissingDeps = [ "liblttng-ust.so.0" ];

    installPhase = ''
      mkdir -p $out/bin
      cp -r . $out/

      # dotnet refuses to run if its executable is renamed (wrapProgram renames it).
      # makeShellWrapper creates a NEW wrapper at $out/bin/dotnet without touching
      # the original binary, so dotnet sees its real name at runtime.
      # Needed because .NET discovers ICU via dlopen(), bypassing RPATH.
      makeShellWrapper $out/dotnet $out/bin/dotnet \
        --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath [ pkgs.icu pkgs.openssl ]}
    '';
  };
in
{
  environment.systemPackages = [ dotnet-ms-runtime ];
}
