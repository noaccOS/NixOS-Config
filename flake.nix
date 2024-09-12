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
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix = {
      url = "git+https://git.lix.systems/lix-project/nixos-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    rio = {
      url = "github:raphamorim/rio";
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
      ref = "triple-buffering-v4-46";
      host = "gitlab.gnome.org";
      flake = false;
    };

    # Theming
    catppuccin.url = "github:catppuccin/nix";
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      ...
    }@inputs:
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

        ougi = makeSystem "ougi" {
          localModules = [
            "desktop"
            "personal"
            "gaming"
            "gnome"
            "development"
            "kmonad"
            "virtualization"
          ];

          extraModules = [ nixos-hardware.nixosModules.framework-13-7040-amd ];
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
          user = "francesco";
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

      homeConfigurations = {
        x86 = makeHome { };
        arm = makeHome { system = "aarch64-linux"; };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
