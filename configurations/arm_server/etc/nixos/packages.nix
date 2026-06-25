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
    box86
  ];
}
