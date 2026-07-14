{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    sudo
    htop
    tmux
    file
    git
    binutils
    qemu
    dotnet-runtime_10
    unzip
  ];
}
