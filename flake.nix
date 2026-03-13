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
    lib = nixpkgs.lib;

  in {

    nixosConfigurations = {

      danixos = lib.nixosSystem {
        inherit system;

        modules = [
          ./iso/configuration.nix
        ];

        specialArgs = { inherit danix-kit; };
      };

      danixos-netboot = lib.nixosSystem {
        inherit system;

        modules = [
          ./iso/configuration.nix
          "${nixpkgs}/nixos/modules/installer/netboot/netboot-minimal.nix"
        ];

        specialArgs = { inherit danix-kit; };
      };

    };

    packages.${system}.default =

      let
        iso =
          self.nixosConfigurations.danixos.config.system.build.isoImage;

        kernel =
          self.nixosConfigurations.danixos-netboot.config.system.build.kernel;

        initrd =
          self.nixosConfigurations.danixos-netboot.config.system.build.netbootRamdisk;

      in nixpkgs.legacyPackages.${system}.symlinkJoin {

        name = "danixos-build";

        paths = [
          iso
          kernel
          initrd
        ];

      };

  };
}
