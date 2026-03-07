{ config, pkgs, modulesPath, ... }:

{
  imports =
    [
      "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ];

  system.stateVersion = "24.11";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "danixos";

  # Root login allowed for live environment
  users.users.root.initialPassword = "danix";

  services.getty.autologinUser = "root";

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

    # System inspection
    lshw
    pciutils
    usbutils
    lm_sensors

    # CLI utilities
    jq
    tmux
    git
    nano
    vim

    # Stress testing
    stress-ng

    # Custom Tools
    danix-kit

  ];

  services.openssh.enable = true;

}
