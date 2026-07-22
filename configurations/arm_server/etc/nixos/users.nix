{ pkgs, ... }:

{
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
    
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 PUTTHEPUBKEYHERE admin@dont_forget_to_change_the_machine_name_here_alright_interrogation_pontuation"
    ];
  };
}
