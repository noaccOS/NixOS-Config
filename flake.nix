{
  description = "NixOS and Home-Manager configuration";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # rock5 = {
    #   url = "github:aciceri/rock5b-nixos";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lexical = {
      url = "github:lexical-lsp/lexical?ref=v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rycee = {
      url = "gitlab:rycee/nur-expressions";
      flake = false;
    };

    # Overrides
    mutter-triple-buffer = {
      type = "gitlab";
      owner = "Community%2FUbuntu";
      repo = "mutter";
      ref = "triple-buffering-v4-45";
      host = "gitlab.gnome.org";
      flake = false;
    };

    # Theming
    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };
    catppuccin-fish = {
      url = "github:catppuccin/fish";
      flake = false;
    };
    catppuccin-rio = {
      url = "github:catppuccin/rio";
      flake = false;
    };
    catppuccin-starship = {
      url = "github:catppuccin/starship";
      flake = false;
    };
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, home-manager, ... }@inputs:
    let
      makeSystem = import ./lib/makeSystem.nix inputs;
      makeHome = import ./lib/makeHome.nix inputs;
    in
    {
      nixosConfigurations = {
        mayoi = makeSystem "mayoi" {
          localModules = [
            "desktop"
            "docker"
            "personal"
            "gaming"
            "gnome"
            "development"
            "nvidia"
            "virtualization"
            "logitech"
            "canon"
          ];
        };

        nadeko = makeSystem "nadeko" {
          localModules = [
            "desktop"
            "personal"
            "gnome"
            "development"
            "virtualization"
          ];
        };

        # hitagi = makeSystem "hitagi" {
        #   inherit nixpkgs home-manager emacs-overlay;
        #   system = "aarch64-linux";
        #   wan = "noaccos.ovh";
        #   extraModules = [
        #     rock5.nixosModules.kernel
        #     rock5.nixosModules.fan-control
        #   ];
        #   localModules = [
        #     "server"
        #   ];
        # };

        kaiki = makeSystem "kaiki" {
          user = { name = "francesco"; fullName = "Francesco Noacco"; };
          localModules = [
            "desktop"
            "work"
            "docker"
            "intel"
            "gnome"
            "development"
            "virtualization"
          ];
        };
      };

      homeConfigurations =
        {
          x86 = makeHome { };
          arm = makeHome { system = "aarch64-linux"; };
        };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
