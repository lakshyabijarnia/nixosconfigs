{
  lib,
  inputs,
  system,
  config,
  pkgs,

  username,
  fullname,
  ...
}:

{
  imports = [
    ./hardware-config.nix
    ./../../global-config.nix
    ./../../video-creation.nix
    ./../../intensive-apps.nix
    ./../../virtualization.nix
  ];

  # Hostname
  networking.hostName = "nixos";

  # GPU driver stuff:
  # https://nixos.wiki/wiki/AMD_GPU
#  services.xserver.videoDrivers = [ "nvidia" ];
 # systemd.tmpfiles.rules = [
  #  "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
 # ];
 # hardware.opengl.extraPackages = with pkgs; [
 #   rocm-opencl-icd
 #   rocm-opencl-runtime
 #   amdvlk
 # ];
 # hardware.opengl.extraPackages32 = with pkgs; [
 #   driversi686Linux.amdvlk
 # ];
 # hardware.opengl.driSupport = true;
 # hardware.opengl.driSupport32Bit = true;
   

   # Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Tell Xorg to use the nvidia driver (also valid for Wayland)
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is needed for most Wayland compositors
    modesetting.enable = true;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = false;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
