{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homeModules.cli;
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
    home.packages = with pkgs; [ sd ];

    homeModules.programs.cli.zellij.enable = true;
    homeModules.development.defaultVisual = "helix";

    programs = {
      bat = {
        enable = true;
      };

      bottom = {
        enable = true;
      };

      direnv = {
        enable = true;
        nix-direnv.enable = true;

        config.global = {
          bash_path = "${pkgs.bash}/bin/bash";
          load_dotenv = true;
        };
      };

      eza = {
        enable = true;
        enableFishIntegration = true;
        icons = true;
        git = true;
      };

      fish = {
        enable = true;
        shellInit = lib.strings.optionalString cfg.sourceNix ''
          if test -f ~/.nix-profile/etc/profile.d/nix.fish
            source ~/.nix-profile/etc/profile.d/nix.fish
          end
        '';
      };

      fd = {
        enable = true;
        hidden = true;
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
          ".lexical/"
        ];
        extraConfig = {
          credential.helper = "store";
          diff.algorithm = "histogram";
          fetch.prune = true;
          fetch.prunetags = true;
          github.user = "noaccOS";
          init.defaultBranch = "main";
          log.date = "iso";
          merge.confilictStyle = "zdiff3";
          pull.ff = "only";
          pull.rebase = "interactive";
          push.autoSetupRemote = true;
          rebase.autosquash = true;
          rebase.autostash = true;
          rebase.updateRefs = true;
          rerere.enabled = true;

          user = {
            name = "Francesco Noacco";
            email = "francesco.noacco2000@gmail.com";
          };
        };

        includes = [
          {
            condition = "gitdir:~/src/seco/";
            contents = {
              user = {
                email = "francesco.noacco@secomind.com";
                signingKey = "A83DA1B14BD444A6";
              };
              commit.gpgSign = true;
            };
          }
        ];
      };

      ripgrep = {
        enable = true;
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
