{ lib, stdenv, fetchFromGitHub, cmake, python3 }:

let
  withDynarec = stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isRiscV64 || stdenv.hostPlatform.isLoongArch64;
in
stdenv.mkDerivation {
  pname = "box64";
  version = "7eeb5016493dab4e143d53da50dd47bfb44a9509";
  doCheck = false;

  src = fetchFromGitHub {
    owner = "ptitSeb";
    repo = "box64";
    rev = "7eeb5016493dab4e143d53da50dd47bfb44a9509";
    hash = "sha256-XESbBWXSj2vrwVaHsVIU+m/Ru/hOXcx9ywrA2WqXG/o=";
  };

  nativeBuildInputs = [ cmake python3 ];

  env = lib.optionalAttrs stdenv.hostPlatform.isAarch64 {
    NIX_CFLAGS_COMPILE = "-march=armv8.1-a+crc";
  };

  cmakeFlags =
    [
      (lib.cmakeBool "NOGIT" true)
      (lib.cmakeBool "ARM64" stdenv.hostPlatform.isAarch64)
      (lib.cmakeBool "RV64" stdenv.hostPlatform.isRiscV64)
      (lib.cmakeBool "PPC64LE" (stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isLittleEndian))
      (lib.cmakeBool "LARCH64" stdenv.hostPlatform.isLoongArch64)
    ]
    ++ lib.optionals stdenv.hostPlatform.isx86_64 [
      (lib.cmakeBool "LD80BITS" true)
      (lib.cmakeBool "NOALIGN" true)
    ]
    ++ [
      (lib.cmakeBool "ARM_DYNAREC" (withDynarec && stdenv.hostPlatform.isAarch64))
      (lib.cmakeBool "RV64_DYNAREC" (withDynarec && stdenv.hostPlatform.isRiscV64))
      (lib.cmakeBool "LARCH64_DYNAREC" (withDynarec && stdenv.hostPlatform.isLoongArch64))
      (lib.cmakeBool "BOX32" true)
      (lib.cmakeBool "BOX32_BINFMT" true)
    ];

  installPhase = ''
    runHook preInstall
    install -Dm 0755 box64 "$out/bin/box64"
    runHook postInstall
  '';

  meta = {
    homepage = "https://box86.org/";
    description = "Run x86_64 (and i386 via Box32) Linux programs on non-x86 systems";
    license = lib.licenses.mit;
    mainProgram = "box64";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "riscv64-linux"
      "powerpc64le-linux"
      "loongarch64-linux"
      "mips64el-linux"
    ];
  };
}
