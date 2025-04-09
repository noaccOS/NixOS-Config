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
        filter_mode_shell_up_key_binding = "directory";
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
        enableNushellIntegration = false;
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
        signing.format = "openpgp";
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
          ".typos.toml"
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

        settings.template-aliases = {
          "signoff(author)" = ''
            "\n\nSigned-off-by: " ++ author.name() ++ " <" ++ author.email() ++ ">\n"
          '';
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
              draft_commit_description = ''
                concat(
                  description,
                  if(!description.contains("Signed-off-by"), signoff(self.committer())),
                  surround(
                    "\nJJ: This commit contains the following changes:\n", "",
                    indent("JJ:     ", diff.stat(72)),
                  ),
                )
              '';
            };
          }
        ];

        settings.ui.conflict-marker-style = "git";
        settings.ui.default-command = "status";
        settings.ui.diff-editor = ":builtin";
        settings.ui.diff.tool = [
          "difft"
          "--color=always"
          "$left"
          "$right"
        ];
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
        package = pkgs.starship.overrideAttrs {
          patches = [
            (pkgs.fetchpatch2 {
              url = "https://patch-diff.githubusercontent.com/raw/starship/starship/pull/5772.diff";
              sha256 = "sha256-ycPjoeRZ22FKNr/kDm7+6dRWrVPSyM5+XNEaYMr524w=";
            })
          ];
        };
        enableFishIntegration = true;
        enableTransience = true;
        settings = mkMerge [
          (fromTOML (readFile ../../config/starship-nerd.toml))
          {
            gcloud.disabled = true;
            nix_shell.heuristic = true;
            git_branch.disabled = true;
            git_commit.disabled = true;
            git_metrics.disabled = true;
            git_status.disabled = true;
            jj_status = {
              symbol = " ";
              no_description_symbol = "󰏫 ";
              divergent_symbol = "󰞇 ";
              format = "on [$symbol$change_id_prefix]($change_id_prefix_style)[$change_id_suffix]($change_id_suffix_style) [$no_description_symbol](yellow)[$divergent_symbol](bold red)";
            };
          }
        ];
      };

      zoxide.enable = true;
    };
  };
}
