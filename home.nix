{ pkgs, ... }: {
  home = {
    username = "will";
    homeDirectory = "/home/will";
  };

  home.packages = with pkgs; [ wl-clipboard-rs tree ripgrep ];

  programs = {
    home-manager.enable = true;
    git.enable = true;

    alacritty.enable = true;
    fzf.enable = true; # enables zsh integration by default
    starship.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
    };

    neovim = {
      enable = true;
      extraConfig = builtins.readFile ./nvim/init.vim;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

  };

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4"; # Super key
      terminal = "alacritty";
      output = {
        "Virtual-1" = {
          mode = "1920x1080@60Hz";
        };
      };
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
