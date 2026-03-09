{
  description = "DanixOS Live Certification Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    #danix-kit.url = "github:danixtech/danix-kit";
    danix-kit.url = "path:/home/dan/Repos/github/danixtech/danix-kit";
  };

  outputs = { self, nixpkgs, danix-kit }:

  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
    };

  in {

    nixosConfigurations.danixos = nixpkgs.lib.nixosSystem {
      system = system;

      modules = [
        ./iso/configuration.nix
      ];

      specialArgs = {
        inherit danix-kit;
      };
    };

  };
}
