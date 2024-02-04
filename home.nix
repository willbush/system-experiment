{ pkgs, ... }: {
  home = {
    username = "will";
    homeDirectory = "/home/will";
  };

  home.packages = with pkgs; [ wl-clipboard-rs tree ripgrep firefox ];

  programs = {
    home-manager.enable = true;

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
    settings = {
      "$mod" = "SUPER";

      bind =
        [
          # These are Colemak-DH keys. I don't dedicated number row unless I go
          # through a layer key. So I rather use keys close to the home row.

          # binds $mod + {q..g} to workspace {q..g}
          "$mod, q, workspace, 1"
          "$mod, w, workspace, 2"
          "$mod, f, workspace, 3"
          "$mod, p, workspace, 4"
          "$mod, b, workspace, 5"
          "$mod, a, workspace, 6"
          "$mod, r, workspace, 7"
          "$mod, s, workspace, 8"
          "$mod, t, workspace, 9"
          "$mod, g, workspace, 10"

          # binds $mod + shift + {q..g} to move to workspace {q..g}
          "$mod SHIFT, q, movetoworkspace, 1"
          "$mod SHIFT, w, movetoworkspace, 2"
          "$mod SHIFT, f, movetoworkspace, 3"
          "$mod SHIFT, p, movetoworkspace, 4"
          "$mod SHIFT, b, movetoworkspace, 5"
          "$mod SHIFT, a, movetoworkspace, 6"
          "$mod SHIFT, r, movetoworkspace, 7"
          "$mod SHIFT, s, movetoworkspace, 8"
          "$mod SHIFT, t, movetoworkspace, 9"
          "$mod SHIFT, g, movetoworkspace, 10"
        ];
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
