{ pkgs, ... }:

{
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    packages = with pkgs; [
      tree
    ];
  };
}
