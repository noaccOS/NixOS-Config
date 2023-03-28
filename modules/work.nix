{ pkgs, ... }:
{
  imports = [ ./desktop.nix ];

  environment.defaultPackages = with pkgs; [

  ];

  users.users.tech = {
    hashedPassword = "$y$j9T$EYMiCulten0c9xEkSW59l0$IYR43m.6UjbNP9GbHI05uG.qbNYLPI5cA00s97xnWS5";
    uid = 1000;
    isNormalUser = true;
  };

  
}
