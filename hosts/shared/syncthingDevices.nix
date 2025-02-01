{lib, ...}: {
  devices = let
    port = 22000;
    
    lan = {
      search = "lan.x000.dev";
      subnet = "192.168.1";
    };
    vmn = {
      search = "x000.dev";
      subnet = "192.168.2";
    };

    genAddresses = let
      portStr = builtins.toString port;
      getSearch = with lib.strings; ip: 
        if hasPrefix lan.subnet ip then lan.search
        else if hasPrefix vmn.subnet ip then vmn.search
        else throw "Dodgy ip or subnet config";

    in name: ip: lib.lists.flatten (map (prot: map
      (host: "${prot}://${host}:${portStr}")
      [name "${name}.${getSearch ip}" ip])
    ["quic" "tcp"])
      ++ ["dynamic"];

  in map (spec: spec // {addresses = with spec; genAddresses name ip;}) [
    {
      id = "LDIW2XW-6KVDKV5-KLEHNFG-U7HE3KW-KCRIACC-GUTQVTW-ZFWOQSX-TT2VVQA";
      ip = "192.168.1.101";
      name = "kdes";
    }
    {
      id = "4FRHEEH-GY5UTNB-2OKO4CR-NOACVKU-Y4PI7GF-6R4MXNR-SJXOV56-HW2OZAB";
      ip = "192.168.1.102";
      name = "klap";
    }
    {
      id = "IVUEMOX-NCI23UB-F3S6DCX-XI5OTJH-BQ457QB-OVQGQBM-FVV6IFE-DY7AGQP";
      ip = "192.168.1.103";
      name = "kpho";
    }
    {
      id = "IDLBSPE-NGLFDW2-C54LVKQ-OGBPDC5-XGR2EFM-IMAGNIZ-IUVVRAH-VVC5QQF";
      ip = "192.168.2.2";
      name = "sync";
    }
  ];
}
