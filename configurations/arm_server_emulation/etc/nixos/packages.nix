{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    sudo
    htop
    tmux
    file
    git
    binutils
    qemu
    unzip
  ];
}
