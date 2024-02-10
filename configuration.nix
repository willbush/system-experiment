{ inputs, pkgs, lib, config, ... }:
let hashedPassword = "$6$E9Vvt03Z9YlvNNzv$JV4K5PK3J6oqr5ALg5yb72yUzIlxA.VlWWC5NqC8vSUkv9XcNW5gZVkdGvoBjZyyZ.fJeKaT60xYKqJ2wNBYi.";
in
{
  imports = [
    ./greetd.nix
    ./hardware-configuration.nix
    ./persist.nix
  ];

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  networking.hostName = "blitzar";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/Chicago";

  # Enable sound.
  sound.enable = true;
  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # wayland-related
  security.polkit.enable = true;
  hardware.opengl.enable = true; # when using QEMU KVM

  users.mutableUsers = false;

  users.users = {
    root.initialHashedPassword = hashedPassword;

    will = {
      initialHashedPassword = hashedPassword;
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      shell = pkgs.zsh;
    };
  };

  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
    fira-mono
    hack-font
    inconsolata
    iosevka
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
