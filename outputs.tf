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

output "image" {
  description = "Packer image used"
  value       = data.hcp_packer_artifact.mcpaper-java
}
