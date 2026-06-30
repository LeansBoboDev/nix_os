{ pkgs, ... }:
{
  hardware.graphics.enable = true;

  # cage: Wayland kiosk compositor — boots directly into retro_os Flutter frontend
  services.cage = {
    enable = true;
    user = "admin";
    program = "/home/admin/retro_os";
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
