{ config, pkgs, ... }:
{
  programs.fish = {
    plugins = [
      {
        name = "fenv";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }
    ];
    
    shellInit = ''
      if test -f ~/.nix-profile/etc/profile.d/nix.sh
        fenv source ~/.nix-profile/etc/profile.d/nix.sh
      end
    '';
  };
}
