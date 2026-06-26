{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    sudo
    htop
    tmux
    file
    binutils
    (retroarch.override {
      cores = with libretro; [
        mupen64plus
      ];
    })
  ];
}
