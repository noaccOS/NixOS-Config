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
    mkAfter
    mkBefore
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
    homeModules.development.defaultVisual = "zed";
    homeModules.development.extraEditors = [ "helix" ];

    home.sessionVariables.LESS = "--quit-if-one-screen --RAW-CONTROL-CHARS --wheel-lines=3";
    home.sessionVariables.HWATCH = "--no-title --color --no-help-banner";

    xdg.userDirs.enable = true;

    programs = {
      atuin.enable = true;
      atuin.daemon.enable = true;
      atuin.settings = {
        enter_accept = true;
        filter_mode_shell_up_key_binding = "session";
        inline_height = 15;
        search_mode = "skim";
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

        config.global = {
          bash_path = "${pkgs.bash}/bin/bash";
          load_dotenv = true;
          warn_timeout = 0;
        };
      };

      eza = {
        enable = true;
        enableFishIntegration = true;
        enableNushellIntegration = false;
        icons = "auto";
        git = true;
      };

      fish = {
        enable = true;
        binds = {
          "ctrl-o".command = "edit_command_buffer";
        };
        interactiveShellInit = mkMerge [
          (mkBefore ''
            set atuin_session_bak "$ATUIN_SESSION"
          '')
          (mkAfter ''
            test -n "$atuin_session_bak"; and set -gx ATUIN_SESSION "$atuin_session_bak"
          '')
        ];
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
        signing.format = "openpgp";
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
        settings = {
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

      difftastic = {
        enable = true;
        git.enable = true;
      };

      nix-index.enable = true;
      nix-your-shell.enable = true;

      jujutsu = {
        enable = true;

        settings.user = {
          name = config.programs.git.settings.user.name;
          email = mkDefault config.programs.git.settings.user.email;
        };

        settings."--scope" = [
          {
            "--when".repositories = [ "~/src/seco" ];
            user.email = "francesco.noacco@secomind.com";
            signing = {
              behavior = "own";
              backend = "gpg";
              key = "A83DA1B14BD444A6";
            };
            templates = {
              commit_trailers = "format_signed_off_by_trailer(self)\n";
            };
          }
        ];

        settings.ui.conflict-marker-style = "git";
        settings.ui.default-command = "status";
        settings.ui.diff-editor = ":builtin";
        settings.ui.diff-formatter = [
          "difft"
          "--color=always"
          "$left"
          "$right"
        ];
      };

      less = {
        enable = true;
        config =
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

      nh = {
        enable = true;
        clean.enable = true;
        flake = mkDefault (config.home.homeDirectory + "/src/nixos-config");
      };

      ripgrep.enable = true;

      starship = {
        enable = true;
        enableFishIntegration = true;
        enableTransience = true;
        settings = mkMerge [
          (fromTOML (readFile ../../config/starship-nerd.toml))
          {
            gcloud.disabled = true;
            nix_shell.heuristic = true;
          }
        ];
      };

      vivid.enable = true;
      zoxide.enable = true;
    };
    services = {
      syncthing = {
        enable = true;
      };
    };
  };
}
