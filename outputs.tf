output "server_name" {
  description = "The name of the server"
  value       = hcloud_server.minecraft.name
}

output "server_ipv4" {
  description = "The IPv4 address of the server"
  value       = hcloud_server.minecraft.ipv4_address
}

output "server_ipv6" {
  description = "The IPv6 address of the server"
  value       = hcloud_server.minecraft.ipv6_address
}

output "server_ssh" {
  description = "The SSH command to connect to the server"
  value       = "ssh root@${hcloud_server.minecraft.ipv4_address}"
}

output "rcon_password" {
  description = "The RCON password"
  value       = random_password.rcon[0].result
  sensitive   = true
}

output "volume_device" {
  description = "The device name of the volume"
  value       = hcloud_volume.worlds.linux_device
}

output "host-keys" {
  description = "The host keys of the server"
  value       = {
    ecdsa = tls_private_key.ecdsa-host-key.public_key_fingerprint_sha256
    rsa   = tls_private_key.rsa-host-key.public_key_fingerprint_sha256
    ed25519 = tls_private_key.ed25519-host-key.public_key_fingerprint_sha256
  }
}