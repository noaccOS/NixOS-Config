{ config, pkgs, lib, ... }:
let
  cfg = config.homeModules.cli;
  aliases = {
    defaults = {
      eza = "${pkgs.eza}/bin/eza --color=auto --icons -a";
    };

    eza = {
      ls = "${aliases.defaults.eza}";
      ll = "${aliases.defaults.eza} -lh";
      lt = "${aliases.defaults.eza} --tree";
    };

    fd = {
      fd = "${pkgs.fd}/bin/fd -H";
    };
  };
in

{
  options.homeModules.cli = {
    enable = lib.mkEnableOption "basic cli tools";
    sourceNix = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable sourcing of nix profile. Useful in non-nixos systems.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ripgrep
      fd
      sd
    ];

    homeModules.programs.editors.helix.enable = true;

    # Remove when Fish gains theme support through home-manager
    xdg.configFile."fish/themes/catppuccin.theme".source = builtins.fetchurl {
      name = "catppuccin-fish";
      url = "https://raw.githubusercontent.com/catppuccin/fish/91e6d6721362be05a5c62e235ed8517d90c567c9/themes/Catppuccin%20Mocha.theme";
      sha256 = "sha256:0qkghib607nrsi72wzkgvxm2rwf42ad73472ksbf3sik1q33slij";
    };
    programs = {
      bat = {
        enable = true;
      };

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      eza = {
        enable = true;
      };

      fish = {
        enable = true;
        shellAliases = aliases.eza // aliases.fd;

        interactiveShellInit = ''
          ${pkgs.fastfetch}/bin/fastfetch
        '';

        shellInit = lib.strings.optionalString cfg.sourceNix ''
          if test -f ~/.nix-profile/etc/profile.d/nix.fish
            source ~/.nix-profile/etc/profile.d/nix.fish
          end
        '';
      };

      git = {
        enable = true;
        difftastic.enable = true;
        ignores = [
          "log/"
          ".direnv/"
          ".nix-mix/"
          ".nix-hex/"
          ".envrc"
          ".vscode/"
          "result"
        ];
        extraConfig = {
          init.defaultBranch = "main";
          pull.ff = "only";
          github.user = "noaccOS";
          diff.algorithm = "patience";
          credential.helper = "store";

          user = {
            name = "Francesco Noacco";
            email = "francesco.noacco2000@gmail.com";
          };
        };

        includes = [{
          condition = "gitdir:~/src/seco/";
          contents = {
            user = {
              email = "francesco.noacco@secomind.com";
              signingKey = "A83DA1B14BD444A6";
            };
            commit.gpgSign = true;
          };
        }];

      };

      starship = {
        enable = true;
        enableFishIntegration = true;
        settings = lib.mkMerge [
          (builtins.fromTOML (builtins.readFile ../../config/starship-nerd.toml))
          {
            gcloud.disabled = true;
            nix_shell.heuristic = true;
          }
        ];
      };
    };
  };
}
