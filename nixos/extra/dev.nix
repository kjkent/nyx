{
  nixosUser,
  pkgs,
  ...
}:
with pkgs; {
  config = {
    environment.systemPackages = let
      arduino = [
        adafruit-nrfutil
        arduino-cli
        arduino-ide
      ];
      python = [
        python3
        pyupgrade
        uv
      ];
      sigrok = [
        libsigrok # needs to be included in services.udev.packages
        libsigrokdecode
        pulseview
        sigrok-cli
        sigrok-firmware-fx2lafw
      ];

      bundles = arduino ++ python ++ sigrok;
    in
      bundles
      ++ [
        android-studio
        ansible
        ansible-lint
        biome
        bruno
        clang
        dfu-util
        docker-compose
        espflash
        esptool
        flashprog
        flashrom
        fritzing
        git
        hexdiff
        hexyl
        httptoolkit-appimage
        stable.imsprog # build issue
        jetbrains.pycharm-community-bin
        jetbrains.webstorm
        meson
        ninja
        nixd
        neovide
        opentofu
        processing
        saleae-logic-2
        shellcheck
        tinyxxd # xxd (usually bundled with vim)
      ];

    programs = {
      adb.enable = true;
      direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
      };
      wireshark = {
        enable = true;
        # Otherwise uses wireshark-cli... even though the package looks
        # like it installs wireshark??
        # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/wireshark.nix
        package = wireshark;
      };
    };

    # Gives logged-in user access to any USB device enumerating a ttyUSB
    # or ttyACM device -- if the rule works (pls). Also tells ModemManager
    # to leave it alone as (old) reports state interference.
    services.udev.packages = let
      uaccess = ''TAG+="uaccess"'';
      mmIgnore = ''ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"'';
      uaccessMmIgnore = "${uaccess}, ${mmIgnore}";

      usb-tty = writeTextFile rec {
        name = "usb-tty";
        # uaccess tagging gives access to the currently authenticated user, but
        # the udev rule must be ordered before 73-seat-late.rules to have ACLs
        # applied:
        # https://github.com/systemd/systemd/issues/4288#issuecomment-348166161
        text = ''
          KERNEL=="tty(ACM|USB)[0-9]*", SUBSYSTEMS=="usb", ${uaccessMmIgnore}
        '';
        destination = "/etc/udev/rules.d/70-${name}.rules";
      };
      ch341a = writeTextFile rec {
        name = "ch341a";
        text = ''
          SUBSYSTEM=="usb", ATTR{idVendor}=="1a86", ATTR{idProduct}=="5512", ${uaccessMmIgnore}
        '';
        destination = "/etc/udev/rules.d/70-${name}.rules";
      };
    in [
      libsigrok
      saleae-logic-2
      usb-tty
      ch341a
    ];
    users.users.${nixosUser.username}.extraGroups = ["adbusers" "wireshark"];
  };
}
