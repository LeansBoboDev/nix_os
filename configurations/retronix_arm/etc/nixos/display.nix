{ pkgs, ... }:
{
  hardware.graphics.enable = true;

  # cage: Wayland kiosk compositor — boots directly into retroarch, no desktop
  services.cage = {
    enable = true;
    user = "admin";
    program = "${pkgs.retroarch}/bin/retroarch";
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
