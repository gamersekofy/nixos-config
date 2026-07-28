{
  services.howdy = {
    enable = true;
    control = "[success=ok default=ignore]";
    # control = "sufficient";
  };

  services.linux-enable-ir-emitter = {
    enable = true;
    device = "video2";
  };
}
