{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homeModules.cli;
  inherit (builtins) fromTOML readFile;

  inherit (lib)
    concatStringsSep
    mapAttrsToList
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    optionalString
    pipe
    types
    ;

in
{
  options.homeModules.cli = {
    enable = mkEnableOption "basic cli tools";
    sourceNix = mkOption {
      type = types.bool;
      default = false;
      description = "Enable sourcing of nix profile. Useful in non-nixos systems.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      sd
      hwatch
    ];

    homeModules.programs.cli.zellij.enable = true;
    homeModules.programs.cli.gitui.enable = true;
    homeModules.programs.shells.nu.enable = true;
    homeModules.development.defaultVisual = "helix";

    home.sessionVariables.LESS = "--quit-if-one-screen --RAW-CONTROL-CHARS --mouse --wheel-lines=3";
    home.sessionVariables.HWATCH = "--no-title --color --no-help-banner";

    xdg.userDirs.enable = true;

    programs = {
      atuin.enable = true;
      atuin.settings = {
        enter_accept = true;
        inline_height = 15;
        show_help = false;
        show_tabs = false;
        style = "full";
      };
      bat.enable = true;
      bottom.enable = true;
      carapace.enable = true;
      carapace.enableFishIntegration = false;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableNushellIntegration = false;

        config.global = {
          bash_path = "${pkgs.bash}/bin/bash";
          load_dotenv = true;
          warn_timeout = 0;
        };
      };

      eza = {
        enable = true;
        enableFishIntegration = true;
        icons = "auto";
        git = true;
      };

      fish = {
        enable = true;
        shellAliases = {
          cat = "bat --style=plain --paging=never";
        };
        shellInit = optionalString cfg.sourceNix ''
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
          ".elixir_ls/"
          ".lexical/"
          ".helix"
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
              tag.gpgSign = true;
            };
          }
        ];
      };

      jujutsu = {
        enable = true;
        settings.user = {
          name = config.programs.git.extraConfig.user.name;
          email = mkDefault config.programs.git.extraConfig.user.email;
        };

        settings.ui.default-command = "log";
      };

      less = {
        enable = true;
        keys =
          let
            keys = {
              k = "repeat-search";
              K = "reverse-search";
              t = "forw-line";
              n = "back-line";
            };
          in
          pipe keys [
            (mapAttrsToList (name: value: "${toString name}\t${toString value}"))
            (concatStringsSep "\n")
          ];
      };

      ripgrep.enable = true;

      starship = {
        enable = true;
        enableFishIntegration = true;
        settings = mkMerge [
          (fromTOML (readFile ../../config/starship-nerd.toml))
          {
            gcloud.disabled = true;
            nix_shell.heuristic = true;
          }
        ];
      };

      zoxide.enable = true;
    };
  };
}
