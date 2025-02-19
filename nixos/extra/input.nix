{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      cameractrls
      pavucontrol
    ];
    services = {
      libinput.enable = true;
    };
  };
}
