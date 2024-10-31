{ modulesPath, lib, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };
  
  # This was populated at runtime with the networking
  # details gathered from the active system.
  #networking = {
  #    nameservers = [ "8.8.8.8"
  #  ];
  #  defaultGateway = "172.31.1.1";
  #  defaultGateway6 = {
  #    address = "fe80::1";
  #    interface = "eth0";
  #  };
  #  dhcpcd.enable = false;
  #  usePredictableInterfaceNames = lib.mkForce false;
  #  interfaces = {
  #    eth0 = {
  #      ipv4.addresses = [
  #        { address="65.108.213.97"; prefixLength=32; }
  #      ];
  #      ipv6.addresses = [
  #        { address="2a01:4f9:c012:490d::1"; prefixLength=64; }
  #        { address="fe80::9400:3ff:fe7b:d05d"; prefixLength=64; }
  #      ];
  #      ipv4.routes = [ { address = "172.31.1.1"; prefixLength = 32; } ];
  #      ipv6.routes = [ { address = "fe80::1"; prefixLength = 128; } ];
  #    };
  #    
  #  };
  #};
  #services.udev.extraRules = ''
  #  ATTR{address}=="96:00:03:7b:d0:5d", NAME="eth0"
  #  
  #'';
}
