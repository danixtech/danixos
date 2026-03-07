{
  description = "DanixOS Live Certification Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs }:

  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
    };

  in {

    nixosConfigurations.danixos = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./iso/configuration.nix
      ];
    };

  };
}
