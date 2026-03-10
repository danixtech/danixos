{ config, pkgs, modulesPath, danix-kit, lib, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-base.nix"
  ];
  system.stateVersion = "24.11";

  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostName = "danixos";

  isoImage.isoName = lib.mkForce "danixos-alpha-${config.system.nixos.label}.iso";
  isoImage.volumeID = lib.mkForce "DANIXOS";

  users.users.root.password = "";

  services.getty.autologinUser = lib.mkForce "root";

  environment.systemPackages = with pkgs; [

    # Core utilities
    bash
    coreutils
    util-linux
    findutils
    gnugrep
    gawk

    # Disk tools
    smartmontools
    nvme-cli
    hdparm
    fio
    pv
    storcli

    # System inspection
    lshw
    pciutils
    usbutils
    lm_sensors
    dmidecode

    # CLI utilities
    jq
    tmux
    git
    nano
    vim

    # Stress testing
    stress-ng

    # Custom Tools
    danix-kit.packages.${pkgs.system}.default

  ];

  services.openssh.enable = true;

  programs.bash.loginShellInit = ''
    echo
    echo "DanixOS Hardware Certification Environment"
    echo
    danix
  '';

}
