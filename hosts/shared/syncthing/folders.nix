{hostName, lib}: let
  inherit (lib.attrsets) filterAttrs mapAttrs;
  inherit (lib.lists) any remove;
  folders = {
    archive = {
      id = "retqm-3wvzg";
      devices = ["kdes" "klap" "sync"];
    };
    audio = {
      id = "eovpz-batvb";
      devices = ["kdes" "klap" "kpho" "sync"];
    };
    docs = {
      id = "hgqpn-ofxpf";
      devices = ["kdes" "klap" "kpho" "sync"];
    };
    kpho = {
      id = "eliin-ttr6c";
      devices = ["kpho" "sync"];
    };
    notes = {
      id = "uxacx-3e297";
      devices = ["kdes" "klap" "kpho" "sync"];
    };
    pics = {
      id = "3bzlc-rj7c4";
      devices = ["kdes" "klap" "kpho" "sync"];
    };
    stl = {
      id = "ctrjj-nrnx5";
      devices = ["kdes" "klap" "sync"];
    };
    vids = {
      id = "tk4vv-jkcpl";
      devices = ["kdes" "klap" "kpho" "sync"];
    };
  };
in mapAttrs 
  (k: v: v // {devices = remove hostName v.devices;})
  (filterAttrs (k: v: any (d: d == hostName) v.devices) folders)
