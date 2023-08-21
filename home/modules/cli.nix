{ config, pkgs, ... }:
let
  aliases = {
    defaults = {
      exa = "${pkgs.exa}/bin/exa --color=always --icons -a";
    };

    exa = {
      ls = "${aliases.defaults.exa}";
      ll = "${aliases.defaults.exa} -l";
      lt = "${aliases.defaults.exa} --tree";
    };

    fd = {
      fd = "${pkgs.fd}/bin/fd -H";
    };
  };
in

{
  home.packages = [
    pkgs.ripgrep
    pkgs.neofetch
  ];

  programs = {
    bat = {
      enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    exa = {
      enable = true;
      # enableAliases = true; # I'm probably doing my own aliases
    };

    fish = {
      enable = true;
      shellAliases = aliases.exa // aliases.fd;

      plugins = [
        {
          name = "catppuccin";
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "fish";
            rev = "0b228f65728631bdc815c0f74a4d5134802e092d";
            sha256 = "1pxl1mp42ks5zq7al6dig4w5cgwsb3zs9pckjc88wd5wdq8ph4pj";
          };
        }
      ];

      interactiveShellInit = ''
        set term (basename "/"(ps -f -p (cat /proc/(echo %self)/stat | cut -d \  -f 4) | tail -1 | sed 's/^.* //'))

        switch $term
          case kitty
            ${pkgs.neofetch}/bin/neofetch --config ~/.config/neofetch/config-kitty.conf
          case wezterm-gui
            ${pkgs.neofetch}/bin/neofetch --config ~/.config/neofetch/config-wezterm.conf
          case foot
            ${pkgs.neofetch}/bin/neofetch --config ~/.config/neofetch/config-foot.conf
          case '*'
            ${pkgs.neofetch}/bin/neofetch --config ~/.config/neofetch/config-others.conf
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
}
