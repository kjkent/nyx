{
  sops.secrets."attic/netrc" = {
    format = "binary";
    sopsFile = ./secrets/attic-netrc;
  };
}
