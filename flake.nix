{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nmattia/naersk";
  };

  outputs = { self, nixpkgs, utils, naersk }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages."${system}";
      naersk-lib = naersk.lib."${system}";
    in rec {
      packages.nix-autobahn = naersk-lib.buildPackage {
        pname = "nix-autobahn";
        root = ./.;
      };
      defaultPackage = packages.nix-autobahn;

      apps.nix-autobahn = utils.lib.mkApp {
        drv = packages.nix-autobahn;
      };
      defaultApp = apps.nix-autobahn;

      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [ rustc cargo ];
      };
    });
}
