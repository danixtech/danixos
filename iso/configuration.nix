{ config, pkgs, modulesPath, danix-kit, lib, buildId, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-base.nix"
  ];

  system.stateVersion = "24.11";

  networking.hostName = "danixos";

  isoImage.isoName = lib.mkForce "${buildId}.iso";
  isoImage.volumeID = lib.mkForce "DANIXOS";

  users.users.root.password = "";

  services.getty.autologinUser = lib.mkForce "root";

  nixpkgs.config.allowUnfree = true;

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
    (import ../pkgs/banner { inherit pkgs buildId; })
  ];

  services.openssh.enable = true;

  programs.bash.loginShellInit = ''
    clear
    echo
    danix-banner
    echo
    sleep 2
    danix
  '';
}
