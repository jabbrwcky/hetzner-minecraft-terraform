
# Add a record to the domain
resource "dnsimple_zone_record" "minecraft-a" {
  count     = local.create_dnsimple_record ? 1 : 0
  zone_name = var.domain
  name      = var.hostname
  value     = hcloud_primary_ip.mainv4.ip_address
  type      = "A"
  ttl       = 3600
}

resource "dnsimple_zone_record" "minecraft-aaaa" {
  count     = local.create_dnsimple_record ? 1 : 0
  zone_name = var.domain
  name      = var.hostname
  value     = hcloud_primary_ip.mainv6.ip_address
  type      = "AAAA"
  ttl       = 3600
}