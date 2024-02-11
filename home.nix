{ config, pkgs, ... }: {

  home = {
    username = "will";
    homeDirectory = "/home/will";
  };

  imports = [ ./emacs.nix ];

  home.packages = with pkgs; [
    wl-clipboard-rs
    firefox

    # core
    curl
    eza
    fd
    ripgrep
    tree
    wget

    # dev
    delta
    gh
    nixfmt
    nixpkgs-fmt
    nodePackages.prettier
    nodejs # for copilot.el login
    python311
    python311Packages.grip # markdown preview
    python311Packages.pip
    shfmt
    xq # jq in rust

    # network
    dnsutils
    openconnect
    rustscan
    xh

    # security
    git-crypt
    gopass

    # compressor / archiver packages
    p7zip
    unar
    unzip
    zip

    # tui utils
    btop
    glances
    # zenith #broken

    # other utils
    du-dust
    file
    hyperfine # benchmarking tool
    tealdeer # tldr in Rust
    trash-cli
    usbutils
  ];

  programs = {
    home-manager.enable = true;

    wofi.enable = true;
    alacritty.enable = true;
    fzf.enable = true; # enables zsh integration by default
    starship.enable = true;

    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      enableAutosuggestions = true;
      shellAliases = {
        l = "eza";
        la = "eza -lah";
        ll = "eza -l";
        tp = "trash-put";
        vi = "nvim";
        vim = "nvim";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [
          "ripgrep"
        ];
      };

      history = {
        path = "${config.xdg.dataHome}/zsh/zsh_history";
        extended = false; # Whether to insert timestamps
        ignoreDups = true;
        size = 100000;
        save = 100000;
      };
      initExtra = pkgs.lib.fileContents ./configs/zsh/zshrc-init-extra.sh;
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
    # lightweight notification daemon for Wayland
    mako.enable = true;

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
