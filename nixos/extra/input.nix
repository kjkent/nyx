{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      cameractrls
      pavucontrol
      qmk
    ];
    services = {
      libinput.enable = true;
    };
  };
}
