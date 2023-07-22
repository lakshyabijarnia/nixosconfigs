{
  config,
  pkgs,
  ...
}:

{
  systemd.services.enable-sysrq = {
    description = "Enable SysRQ.";
    wantedBy = [ "multi-user.target" ];
    script = ''
      echo 1 > /proc/sys/kernel/sysrq
    '';
    serviceConfig = {
      User = "root";
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
  };
}
