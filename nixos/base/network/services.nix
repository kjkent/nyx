{
  config,
  hostName,
  lib,
  nixosHost,
  nixosUser,
  options,
  ...
}: {
  imports = [./firewall];
  config = {
    networking = {
      hostName = nixosHost;
      networkmanager.enable = false;
      timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
    };

    programs = {
      nm-applet.enable = lib.mkIf config.networking.networkmanager.enable true;
    };

    services = {
      ## journalctl message from avahi suggests disabling due to other ipv4 stack (from resolved)
      #avahi = {
      #  enable = true;
      #  nssmdns4 = true;
      #  openFirewall = true;
      #};
      openssh = {
        enable = true;
        authorizedKeysInHomedir = false;
        banner = ''
          🭚΄˙           ΄         ¯   ⠈   `              🭥🬨
           ΄                                              ▕
                                                          ▐
                          ▁▁▂▂▂🬭🬭🬭▂▁            ⠄ .       🭢
                     ▂▄🬹▆▇███████████🭌🬹🬽                  ╶
                 🭇🭆▇████████████████████🭌🬹🬼               ⠈
                🭈████████████████████🭝🭒🭝🬎🭜🭔🭑              ▕
               🭉████████████████████🬺🭌🬿 🭈🬾🭢🭕🭎🬼            ▕
               🭋██████████████████🭞🬎▀🬆▗🬹▄🬯▂🭈🬑🬬🬾
               ▕█████████████████🭟🭯🭊🭝🭷🭢🭕█🬂🬂▔  ΄           ▗
          ΄     🭕████████████🬄🭊██🭙 ▔   🭅██▆▆🬏🭢🬿
                 🭔█████████🬺🬹🬹🭁██🭑▁  🭈▟██🭠΄🭢¯˛▉
                 🭤████🬕🬎████🬬██🭒▀███████🭘 🬇🮠 🭖🭙
                  ⠈🭣🭕█🭎▄██████🭝🬍🬬▆▆▆██████🭠🭮▌`
                     🭧🭓🭠🭘🭨████🭎🬼🭋█████████🮛🭠🭥
                      🭇🭂▇██████🭌🭁██████████🬲▁       ・
                      🭢🬂🬡🭆█▟█████████████🭜🬷🬆🭓🬴🬼_  ,  ΄
                        🬎🬂🬸██🬴▍🮀🭧🬎🭒█████▙🭁🭜  ⠈🭣🬀🭮▏
               .          🬬███🬐▀🭷⠂ 🮀▜🭓🭓🭞🭜΄
               ⠠        ▂🭊████▙🬰🭧🭓🭂█🬝▘  🭊▄🬹🬹🬹🬹▖
                     🭇🬭▟█████▜█▇▇▆🭝🭞🬀  🭇🭨███🬝▘🭤🬱🬼_
                   🭈▂🬷🬝🬎🭒██████🭓🭙🭋███🭍▇█▛🬬█🭞▏  🭣΄ 🭧🬃
                 🭊🭁███▋ 🭅█🭡🭣🭧🭓🬄  🬯🬸██🬝🬬🭗🭄▍΄  🭮🭍🭑 🭢⠂  ΄
              ˛🭊🭂█████🭌🬭🭃█🭌🭑🬲🬭▄🬹▇█🭝🭓▎_🭧🭒🬮🭂▍  ΄🭒█🬾▆🬿⠕
          🭂▆▇▇██████████🬎▀▀🬬██🬴🬰███🭞████🬝🭜🬀   🭢🭒🭐 🭨▌
          █████████🭪🬏🭊🭾🬺🭂▛🭓🬺▔🭓🭞▀▔🭧🬎🬎🭓🭓██🬴🬽▁    `🭥▄🭟΄ 🬏
          🭒█████████🭜██🭠🬊█🭍┻╴ 🭁█████▇▇🭝🭓🭓🬰▀🬎━🬃   ⠈  🭋🭞╻
          🭢🭒████🭞🭘🬟🭆🭂🭞🭚 🬦🬴🬮·🬼🭷▀🬎🬎🬎🭓🭓██🬭🬭🬭▂▂🮗🬩🭂▇▆🬓⠁   ▁🭖🬓  ▕
          🭊🭁██🭟🬩▇🭞━⠐🭺·  🭮██🬁΄🬠🬸▇🮗🮗▂🬵🬓🭤🭓🭓🬰🬒🬂▀🬎██🬴🬐    ▀🭜🭗  🬭
        '';
        knownHosts = {
          gitHub = {
            hostNames = ["github.com"];
            publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=";
          };
        };
        settings = {
          AllowUsers = [nixosUser.username "root"];
          X11Forwarding = true;
        };
      };
      resolved = {
        enable = true;
        dnssec = "false"; # Sept 2023: SD devs state implementation is not robust enough.
        dnsovertls = "false"; # +++ Disable prior to LAN DOT/DNSSEC implementation.
        fallbackDns = [
          "1.1.1.1"
          "1.2.2.1"
          "9.9.9.9"
        ];
      };
    };

    users.users.${nixosUser.username}.extraGroups = [
      "dialout"
      "networkmanager"
    ];
  };
}
