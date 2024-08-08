{ config, pkgs, inputs, ... }: {
  nixpkgs.config.allowUnfree = true;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  programs = {
    git = {
      enable = true;
      userEmail = "uriootv@protonmail.com";
      userName = "urioTV";
    };
    zsh = {
      enable = true;
      antidote = {
        enable = false;
        plugins =
          [ "zsh-users/zsh-autosuggestions" "zsh-users/zsh-completions" ];
      };
      prezto = {
        enable = true;
        pmodules = [
          "environment"
          "terminal"
          "editor"
          "history"
          "directory"
          "spectrum"
          "utility"
          "completion"
          "prompt"
          "autosuggestions"
          "git"
        ];
      };
      shellAliases = { nix = "noglob nix"; };

    };
    eza = { enable = true; };
    bat = { enable = true; };
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        nix_shell = {
          disabled = false;
          impure_msg = "";
          symbol = "";
          format = "[$symbol$state]($style) ";
        };
        shlvl = {
          disabled = false;
          symbol = "λ ";
        };
        haskell.symbol = " ";
      };
    };
    yazi = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.

  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = { EDITOR = "micro"; };

  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;
}

