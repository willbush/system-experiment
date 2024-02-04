{ pkgs, ... }: {
  home = {
    username = "will";
    homeDirectory = "/home/will";
  };

  home.packages = with pkgs; [ wl-clipboard-rs tree ripgrep firefox ];

  programs = {
    home-manager.enable = true;

    wofi.enable = true;
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
      extraConfig = builtins.readFile ./configs/nvim/init.vim;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      userName = "Will Bush";
      userEmail = "will.g.bush@gmail.com";
      signing = {
        # public key fingerprint
        key = "4441422E61E4C8F3EBFE5E333823864B54B13BDA";
        signByDefault = true;
      };

      extraConfig = {
        core.autocrlf = "input";
        init.defaultBranch = "main";
        merge.conflictstyle = "zdiff3";
        pull.rebase = false;
        push.autoSetupRemote = true;
      };

      difftastic.enable = true;
    };

    ssh = {
      enable = true;
      serverAliveInterval = 30;
      matchBlocks = {
        "github" = {
          hostname = "github.com";
          identityFile = "~/.secrets/id_ed25519_github_will";
        };
      };
    };

    gpg.enable = true;
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = "qt";

      defaultCacheTtl = 10800; # 3 hours
      defaultCacheTtlSsh = 10800;
      maxCacheTtl = 21600; # 6 hours
      maxCacheTtlSsh = 21600;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./configs/hypr/hyprland.conf;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
