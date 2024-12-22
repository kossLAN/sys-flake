# Again this is mostly ripped from outfoxxed, cannot overstate how helpful this is
{
  lib,
  config,
  headscale,
}: let
  cfg = config.services.headscale;
  dataDir = "/var/lib/headscale";
in {
  server_url = "https://kosslan.me";
  listen_addr = "0.0.0.0:3442";
  metrics_listen_addr = "0.0.0.0:3443";

  grpc_listen_addr = "127.0.0.1:50443";
  grpc_allow_insecure = false;

  private_key_path = "${dataDir}/private.key";
  noise.private_key_path = "${dataDir}/noise_private.key";

  prefixes = {
    v6 = "fd7a:115c:a1e0::/48";
    v4 = "100.64.0.0/10";
    allocation = "sequential";
  };

  derp = {
    server = {
      enabled = true;
      region_id = 900;
      region_code = "headscale";
      region_name = "Headscale Embedded DERP";
      stun_listen_addr = "0.0.0.0:8344";
      private_key_path = "${dataDir}/derp_server_private.key";
    };

    urls = [];
    paths = [];

    auto_update_enabled = false;
    update_frequency = "24h";
  };

  database = {
    type = "sqlite3";

    sqlite = {
      path = "${dataDir}/headscale.db";
    };
  };

  disable_check_updates = true;
  ephemeral_node_inactivity_timeout = "30m";
  #node_update_check_interval = "10s";
  acme_url = "";
  acme_email = "";

  tls_letsencrypt_hostname = "";
  tls_letsencrypt_cache_dir = lib.mkDefault "${dataDir}/cache";
  tls_letsencrypt_challenge_type = "HTTP-01";
  tls_letsencrypt_listen = ":http";
  tls_cert_path = null;
  tls_key_path = null;

  log = {
    format = "text";
    level = "info";
  };

  policy = {
    path = null;
    mode = "file";
  };

  dns = {
    override_local_dns = true;
    base_domain = cfg.baseDomain;
    nameservers.global = ["1.1.1.1" "8.8.8.8"];

    search_domains = builtins.map (x: x.name) headscale.tailnetFqdnList;

    extra_records = builtins.map (fqdn: {
      name = fqdn.name;
      type = "A";
      value = fqdn.value;
    }) (headscale.tailnetFqdnList);

    magic_dns = true;
  };

  unix_socket = lib.mkDefault "/var/run/headscale/headscale.sock";
  unix_socket_permission = "0770";

  logtail.enabled = false;
  randomize_client_port = false;
}
