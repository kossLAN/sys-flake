let
  backup = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMw1hLInzGOHV+b0TNmQbl0HHR4cabnZjPdbXcqkSNk";
  cerebrite = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPQc5Or080Vx65xnRe8VnCOKUobhOqdCFvWC06zanvWt";
  galahad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDMw1hLInzGOHV+b0TNmQbl0HHR4cabnZjPdbXcqkSNk";
  dahlia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBoPlufvtH9l19yYmw56vLCrZH84imK3pV5UHm98j8wn";

  systems = [backup cerebrite galahad dahlia];
in {
  # Wireguard Keys
  "av0client1.age".publicKeys = systems;
  "av0preshared.age".publicKeys = systems;

  # Wireguard Profiles
  "wg0client1.age".publicKeys = systems;
  "wg0preshared.age".publicKeys = systems;

  "cloudflare.age".publicKeys = systems;
  "tailscale.age".publicKeys = systems;
  "deluge.age".publicKeys = systems;
}
