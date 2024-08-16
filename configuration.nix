# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "konrad-nixprox";

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      # efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
    };
    #grub = {
    #  enable = true;
    #  efiSupport = true;
    #  #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
    #  device = "nodev";
    #};
    systemd-boot.enable = true;
  };

  boot.supportedFilesystems = [ "ntfs" "exfat" ];

  # !!! Set to specific linux kernel version
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_8;

  # !!! Adding a swap file is optional, but strongly recommended!
  # swapDevices = [{
  #   device = "/swapfile";
  #   size = 2048;
  # }];

  zramSwap = {
    enable = true;
    memoryPercent = 75;
  };

  # systemPackages
  environment.systemPackages = with pkgs; [
    curl
    wget
    micro
    bind
    iptables
    git
    fastfetch
    nh
    rm-improved
    dust
    docker-compose
    gping
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };
  services.qemuGuest.enable = true;

  services.resolved.enable = true;

  programs.zsh = { enable = true; };

  virtualisation.docker = {
    enable = true;
  };

  networking.firewall.enable = true;

  networking.useDHCP = lib.mkForce true;

  hardware.enableRedistributableFirmware = true;

  # put your own configuration here, for example ssh keys:
  users.defaultUserShell = pkgs.zsh;
  users.mutableUsers = true;
  users.groups = {
    nixos = {
      gid = 1000;
      name = "urio";
    };
  };
  users.users = {
    urio = {
      uid = 1000;
      home = "/home/urio";
      name = "urio";
      group = "urio";
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "docker" ];
      isNormalUser = true;
    };
  };
  users.users.root.openssh.authorizedKeys.keys = [
    # This is my public key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRfYCXQz7XXM9pupEpNw949Yh2fuMvfJouJZi6+HOIH urio@konrad-m18"
  ];
  users.users.urio.openssh.authorizedKeys.keys = [
    # This is my public key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRfYCXQz7XXM9pupEpNw949Yh2fuMvfJouJZi6+HOIH urio@konrad-m18"
  ];

  system.stateVersion = "23.05";
}
