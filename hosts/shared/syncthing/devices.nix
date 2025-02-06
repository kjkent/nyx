{hostName, lib}: let

  devices = [
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

  networks = [
    {
      search = "home.x000.dev";
      subnet = "192.168.1";
    }
    {
      search = "x000.dev";
      subnet = "192.168.2";
    }
  ];

  generateSyncthingPeers = let
    # explicit inheritance due to importance of output integrity
    inherit (builtins) concatMap filter map throw toString;
    inherit (lib.attrsets) filterAttrs genAttrs;
    inherit (lib.lists) findSingle;
    inherit (lib.strings) hasPrefix;
    inherit (lib.trivial) pipe;

    # generates address list for each device
    genAddresses = let
      # returns appropriate search domain based on IP
      getSearch = ip: let 
        multi = throw "${ip} matches multiple subnets"; 
        none = throw "${ip} matches no subnets"; 
      in (findSingle (n: hasPrefix n.subnet ip) none multi networks).search;

      port = toString 22000;

      # inner map returns a list using protocol given on each loop of the map,
      # leading to [[addrs with quic] [addrs with tcp]] without concatMap.
    in name: ip: (concatMap
        (prot:
          (map
            (host: "${prot}://${host}:${port}")
            [name "${name}.${getSearch ip}" ip]
          )
        )
        ["quic" "tcp"]
      )
    ++ ["dynamic"]; # fallback to autodiscover via relays.

    # Remove current device from device list
    rmNixosHost = devices: filter (device: device.name != hostName) devices;

    # Inject `addresses = [...]` to each device
    injectAddresses = devices: map
      (device: device // {addresses = with device; genAddresses name ip;})
      devices;

    # Remove ip from every device in list
    rmIp = devices: map 
      (device: filterAttrs (k: v: k != "ip") device)
      devices;

    convertToAttrset = devices: let
      multi = throw "convertToAttrset: multiple devices match name";
      none = throw "convertToAttrset: no devices match name";
    in (genAttrs
      (map (i: i.name) devices)
      (name: findSingle (i: i.name == name) none multi devices)
    );

    # rmIp must come after injectAddresses, which needs ip.
  in devices: pipe devices [
    rmNixosHost
    injectAddresses
    rmIp
    convertToAttrset
  ];
in (generateSyncthingPeers devices)
