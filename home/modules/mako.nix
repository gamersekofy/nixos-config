{
  services.mako = {
    enable = true;
    anchor = "top-center";
    backgroundColor = "#1e1e2e";
    borderColor = "#cba6f7";
    textColor = "#cdd6f4";
    progressColor = "over #313244";
    borderRadius = 5;
    defaultTimeout = 5000;
    extraConfig = ''
      [urgency=high]
      border-color=#fab387
    '';
  };
}
