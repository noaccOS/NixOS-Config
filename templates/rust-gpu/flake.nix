{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    crane.url = "github:ipetkov/crane";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem =
        {
          pkgs,
          system,
          self',
          ...
        }:
        let
          toolchain = inputs.rust-overlay.packages.${system}.rust-nightly.override {
            extensions = [
              "rust-src"
              "rust-analyzer-preview"
            ];
          };
          craneLib = (inputs.crane.mkLib pkgs).overrideToolchain toolchain;
        in
        {
          packages.default = craneLib.buildPackage {
            src = pkgs.lib.cleanSourceWith {
              src = craneLib.path ./.;
              filter = path: type: craneLib.filterCargoSources path type;
            };
            nativeBuildInputs = [ pkgs.pkg-config ];
            buildInputs = with pkgs; [
              udev
              libGL
              alsa-lib
              wayland
            ];
            LD_LIBRARY_PATH = "${pkgs.libxkbcommon}/lib:${pkgs.vulkan-loader}/lib";
            strictDeps = true;
          };

          devShells.default = craneLib.devShell {
            inputsFrom = [ self'.packages.default ];
            inherit (self'.packages.default) LD_LIBRARY_PATH;
            RUST_SRC_PATH = "${toolchain}";
          };

          devShells.setup = craneLib.devShell { };

          formatter = pkgs.nixfmt-rfc-style;
        };
    };
}