{
  description = "Template for nix projects";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    pre-commit.url = "github:cachix/git-hooks.nix";
    treefmt.url = "github:numtide/treefmt-nix";
    systems.url = "github:nix-systems/x86_64-linux";
    nix-checks = {
      url = "github:huuff/nix-checks";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
      pre-commit,
      nix-checks,
      treefmt,
      ...
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        treefmt-build = (treefmt.lib.evalModule pkgs ./treefmt.nix).config.build;
        pre-commit-check = pre-commit.lib.${system}.run {
          src = ./.;
          hooks = import ./pre-commit.nix {
            inherit pkgs;
            treefmt = treefmt-build.wrapper;
          };
        };
        inherit (nix-checks.lib.${system}) checks;
      in
      {
        checks = {
          # just check formatting is ok without changing anything
          formatting = treefmt-build.check self;

          statix = checks.statix ./.;
          deadnix = checks.deadnix ./.;
          flake-checker = checks.flake-checker ./.;
        };

        # for `nix fmt`
        formatter = treefmt-build.wrapper;

        packages = {
          leptosfmt = pkgs.callPackage ./leptosfmt.nix { };
          cargo-upgrades = pkgs.callPackage ./cargo-upgrades.nix { };
        };

        devShells.default = pkgs.mkShell {
          inherit (pre-commit-check) shellHook;
          buildInputs =
            with pkgs;
            pre-commit-check.enabledPackages
            ++ [
              nil
              nixfmt-rfc-style
            ];
        };
      }
    );
}
