{
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30s # very low value to test suspend-then-hibernate
    SuspendState=mem # suspend2idle is buggy :(
  '';
}
