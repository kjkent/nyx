{
  config = {
    boot = {
      kernel.sysctl = {
        "vm.swappiness" = 180;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
        "vm.page-cluster" = 0;
      };
      tmp = {
        useTmpfs = true;
        tmpfsSize = "30%";
      };
    };
    # https://discourse.nixos.org/t/nix-build-ate-my-ram/35752
    services.earlyoom = {
      enable = true;
      enableNotifications = true;
      extraArgs = let
        catPatterns = patterns: builtins.concatStringsSep "|" patterns;
        preferPatterns = [
          "firefox" # .firefox-unwrapped
          "clang"   # clang++
          "java" # java + .java-unwrapped //"If it's written in java it's uninmportant enough it's ok to kill it"
          "^ninja$" 
          "^nix$"
          "^node$"
        ];
        avoidPatterns = [
          "bash"
          "dbus"
          "docker"
          "gpg"
          "kworker"
          "server"
          "ssh"
          "systemd"
          "tmux"
          "zsh"
        ];
      in [
        "--prefer '${catPatterns preferPatterns}'"
        "--avoid '${catPatterns avoidPatterns}'"
      ]; 
    };
    swapDevices = [];
    zramSwap.enable = true;
  };
}
