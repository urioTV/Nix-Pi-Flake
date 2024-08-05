# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    # ./hardware-configuration.nix
  ];

  networking.hostName = "konrad-nixpi";

  # NixOS wants to enable GRUB by default
  # boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  # boot.loader.generic-extlinux-compatible.enable = true;


  # !!! Set to specific linux kernel version
  # boot.kernelPackages = pkgs.linuxPackages_rpi3;


  # Disable ZFS on kernel 6
  # boot.supportedFilesystems = lib.mkForce [ "vfat" "xfs" "cifs" "ntfs" ];

  # !!! Needed for the virtual console to work on the RPi 3, as the default of 16M doesn't seem to be enough.
  # If X.org behaves weirdly (I only saw the cursor) then try increasing this to 256M.
  # On a Raspberry Pi 4 with 4 GB, you should either disable this parameter or increase to at least 64M if you want the USB ports to work.
  boot.kernelParams = [ "cma=256M" ];

  # File systems configuration for using the installer's partition layout
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  # !!! Adding a swap file is optional, but strongly recommended!
  swapDevices = [ { device = "/swapfile"; size = 8192; } ];

  zramSwap.enable = true;
  zramSwap.memoryPercent = 80;

  # systemPackages
  environment.systemPackages = with pkgs; [
    curl
    wget
    micro
    bind
    iptables
    docker-compose
    git
    fastfetch
    nh
    rm-improved
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  services.resolved.enable = true;


  programs.zsh = { enable = true; };

  virtualisation.docker.enable = true;

  networking.firewall.enable = false;

  hardware.enableRedistributableFirmware = true;
  networking.wireless.enable = true;


  # put your own configuration here, for example ssh keys:
  users.defaultUserShell = pkgs.zsh;
  users.mutableUsers = true;
  users.groups = {
    nixos = {
      gid = 1000;
      name = "nixos";
    };
  };
  users.users = {
    nixos = {
      uid = 1000;
      home = "/home/nixos";
      name = "nixos";
      group = "nixos";
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "docker" ];
      isNormalUser = true;
    };
  };
  users.users.root.openssh.authorizedKeys.keys = [
    # This is my public key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRfYCXQz7XXM9pupEpNw949Yh2fuMvfJouJZi6+HOIH urio@konrad-m18"
  ];
  users.users.nixos.openssh.authorizedKeys.keys = [
    # This is my public key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRfYCXQz7XXM9pupEpNw949Yh2fuMvfJouJZi6+HOIH urio@konrad-m18"
  ];
  system.stateVersion = "23.05";
}
