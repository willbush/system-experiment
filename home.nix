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

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind =
        [
          "$mod, F, exec, firefox"
          ", Print, exec, grimblast copy area"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList
            (
              x:
              let
                ws =
                  let
                    c = (x + 1) / 10;
                  in
                  builtins.toString (x + 1 - (c * 10));
              in
              [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10)
        );
    };
  };

  # wayland.windowManager.sway = {
  #   enable = true;
  #   config = rec {
  #     modifier = "Mod4"; # Super key
  #     terminal = "alacritty";
  #     output = {
  #       "Virtual-1" = {
  #         mode = "1920x1080@60Hz";
  #       };
  #     };
  #   };
  # };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
