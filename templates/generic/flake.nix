{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem =
        {
          pkgs,
          self',
          ...
        }:
        {
          packages.default = pkgs.stdenv.mkDerivation {
            pname = "package";
            version = "0.1.0";
            src = ./.;

            nativeBuildInputs = [ ];

            buildInputs = [ ];
          };

          devShells.default = pkgs.mkShell {
            packages = [ ];

            inputsFrom = [ self'.packages.default ];
          };

          formatter = pkgs.nixfmt;
        };
    };
}
