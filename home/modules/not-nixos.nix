{ pkgs, ... }:
{
  programs.fish.shellInit = ''
    if test -f ~/.nix-profile/etc/profile.d/nix.fish
      source ~/.nix-profile/etc/profile.d/nix.fish
    end
  '';
}
