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
        # enableAliases = true; # I'm probably doing my own aliases
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

      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
      };

      starship = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          aws.symbol = "  ";
          buf.symbol = " ";
          c.symbol = " ";
          conda.symbol = " ";
          dart.symbol = " ";
          directory.read_only = " 󰌾";
          docker_context.symbol = " ";
          elixir.symbol = " ";
          elm.symbol = " ";
          fossil_branch.symbol = " ";
          gcloud.disabled = true;
          git_branch.symbol = " ";
          golang.symbol = " ";
          guix_shell.symbol = " ";
          haskell.symbol = " ";
          haxe.symbol = " ";
          hg_branch.symbol = " ";
          hostname.ssh_symbol = " ";
          java.symbol = " ";
          julia.symbol = " ";
          lua.symbol = " ";
          memory_usage.symbol = "󰍛 ";
          meson.symbol = "󰔷 ";
          nim.symbol = "󰆥 ";
          nix_shell = { symbol = " "; heuristic = true; };
          nodejs.symbol = " ";
          package.symbol = "󰏗 ";
          pijul_channel.symbol = " ";
          python.symbol = " ";
          rlang.symbol = "󰟔 ";
          ruby.symbol = " ";
          rust.symbol = " ";
          scala.symbol = " ";

          os.symbols = {
            Alpaquita = " ";
            Alpine = " ";
            Amazon = " ";
            Android = " ";
            Arch = " ";
            Artix = " ";
            CentOS = " ";
            Debian = " ";
            DragonFly = " ";
            Emscripten = " ";
            EndeavourOS = " ";
            Fedora = " ";
            FreeBSD = " ";
            Garuda = "󰛓 ";
            Gentoo = " ";
            HardenedBSD = "󰞌 ";
            Illumos = "󰈸 ";
            Linux = " ";
            Mabox = " ";
            Macos = " ";
            Manjaro = " ";
            Mariner = " ";
            MidnightBSD = " ";
            Mint = " ";
            NetBSD = " ";
            NixOS = " ";
            OpenBSD = "󰈺 ";
            openSUSE = " ";
            OracleLinux = "󰌷 ";
            Pop = " ";
            Raspbian = " ";
            Redhat = " ";
            RedHatEnterprise = " ";
            Redox = "󰀘 ";
            Solus = "󰠳 ";
            SUSE = " ";
            Ubuntu = " ";
            Unknown = " ";
            Windows = "󰍲 ";
          };
        };
      };

    };
  };
}
