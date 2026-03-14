{
  description = "DanixOS Live Certification Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    danix-kit.url = "path:/home/dan/Repos/github/danixtech/danix-kit";
  };

  outputs = { self, nixpkgs, danix-kit }:

  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};

    version = "alpha";
    buildDate = builtins.substring 0 10 (builtins.toString self.lastModifiedDate or "unknown");
    buildId = "danixos-${version}-${buildDate}";

  in {

    nixosConfigurations = {

      danixos = lib.nixosSystem {
        inherit system;

        modules = [
          ./iso/configuration.nix
        ];

        specialArgs = { inherit danix-kit buildId version buildDate; };
      };

      danixos-netboot = lib.nixosSystem {
        inherit system;

        modules = [
          ./iso/configuration.nix
          "${nixpkgs}/nixos/modules/installer/netboot/netboot-minimal.nix"
        ];

        specialArgs = { inherit danix-kit buildId version buildDate; };
      };

    };

    packages.${system} = let

      iso =
        self.nixosConfigurations.danixos.config.system.build.isoImage;

      kernel =
        self.nixosConfigurations.danixos-netboot.config.system.build.kernel;

      initrd =
        self.nixosConfigurations.danixos-netboot.config.system.build.netbootRamdisk;

      ipxe =
        self.nixosConfigurations.danixos-netboot.config.system.build.netbootIpxeScript;

    in {

      iso = pkgs.runCommand "danixos-iso" { inherit buildId; } ''
        mkdir -p $out
        cp ${iso}/iso/*.iso $out/${buildId}.iso
      '';

      pxe = pkgs.runCommand "danixos-pxe" { inherit buildId; } ''
        mkdir -p $out/${buildId}

        cp ${kernel}/bzImage $out/${buildId}/
        cp ${initrd}/initrd $out/${buildId}/
        cp ${ipxe}/netboot.ipxe $out/${buildId}/
      '';

      bundle = pkgs.runCommand "danixos-bundle" { inherit buildId; } ''
        mkdir -p $out/iso
        mkdir -p $out/pxe/${buildId}

        cp ${iso}/iso/*.iso $out/iso/${buildId}.iso

        cp ${kernel}/bzImage $out/pxe/${buildId}/
        cp ${initrd}/initrd $out/pxe/${buildId}/
        cp ${ipxe}/netboot.ipxe $out/pxe/${buildId}/
      '';

      default = self.packages.${system}.bundle;

    };

  };
}
