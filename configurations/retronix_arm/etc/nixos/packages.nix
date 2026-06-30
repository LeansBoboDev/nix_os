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
    retroarch
    libretro.mupen64plus
  ];
}
