{
  hostName,
  lib,
}: let
  devices = {
    kdes = {
      id = "LDIW2XW-6KVDKV5-KLEHNFG-U7HE3KW-KCRIACC-GUTQVTW-ZFWOQSX-TT2VVQA";
      ip = "192.168.1.101";
    };
    klap = {
      id = "4FRHEEH-GY5UTNB-2OKO4CR-NOACVKU-Y4PI7GF-6R4MXNR-SJXOV56-HW2OZAB";
      ip = "192.168.1.102";
    };
    kpho = {
      id = "IVUEMOX-NCI23UB-F3S6DCX-XI5OTJH-BQ457QB-OVQGQBM-FVV6IFE-DY7AGQP";
      ip = "192.168.1.103";
    };
    sync = {
      id = "IDLBSPE-NGLFDW2-C54LVKQ-OGBPDC5-XGR2EFM-IMAGNIZ-IUVVRAH-VVC5QQF";
      ip = "192.168.2.2";
    };
  };

  searchDomains = {
    "192.168.1" = "home.x000.dev";
    "192.168.2" = "x000.dev";
  };

  generateSyncthingPeers = let
    inherit (builtins) attrNames concatMap map throw toString;
    inherit (lib.attrsets) filterAttrs mapAttrs;
    inherit (lib.lists) findSingle;
    inherit (lib.strings) hasPrefix;
    inherit (lib.trivial) pipe;

    # generates address list for each device
    genAddresses = let
      # returns appropriate search domain based on IP
      getSearch = ip: let
        multi = throw "${ip} matches multiple subnets";
        none = throw "${ip} matches no subnets";
      in
        searchDomains
        .${
          (
            # returns value of searchDomain for key that's the prefix of ip
            findSingle (n: hasPrefix n ip)
            none
            multi
            (attrNames searchDomains)
          )
        };

      port = toString 22000;
      # inner map returns a list using protocol given on each loop of the map,
      # leading to [[addrs with quic] [addrs with tcp]] without concatMap.
    in
      name: ip:
        (
          concatMap
          (
            prot: (
              map
              (host: "${prot}://${host}:${port}")
              [name "${name}.${getSearch ip}" ip]
            )
          )
          ["quic" "tcp"]
        )
        ++ ["dynamic"]; # fallback to autodiscover via relays.

    # Remove current device from device list
    rmNixosHost = devices: filterAttrs (k: _v: k != hostName) devices;

    # Inject `addresses = [...]` to each device
    injectAddresses = devices:
      mapAttrs
      (k: v: v // {addresses = genAddresses k v.ip;})
      devices;

    # Remove ip from every device
    rmIp = devices:
      mapAttrs
      (_k: v: filterAttrs (k: _v: k != "ip") v)
      devices;
    # rmIp must come after injectAddresses, which needs ip.
  in
    devices:
      pipe devices [
        rmNixosHost
        injectAddresses
        rmIp
      ];
in
  generateSyncthingPeers devices
