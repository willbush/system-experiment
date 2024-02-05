{ inputs, pkgs, lib, config, ... }:
let hashedPassword = "$6$E9Vvt03Z9YlvNNzv$JV4K5PK3J6oqr5ALg5yb72yUzIlxA.VlWWC5NqC8vSUkv9XcNW5gZVkdGvoBjZyyZ.fJeKaT60xYKqJ2wNBYi.";
in
{
  imports = [
    ./hardware-configuration.nix
    ./persist.nix
    ./greetd.nix
  ];

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/etc/nix/path" ];

  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

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
