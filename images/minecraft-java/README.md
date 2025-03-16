# Minecraft Java

Builds an Java PaperMC image with the plugins listed.

This packer build downloads the latext PaperMC build compatible for the given version.

Required variables for configuration:

| Variable            | Description                                                          | default                        |
| ------------------- | -------------------------------------------------------------------- | ------------------------------ |
| `hcloud_token`      | Token for Hetzner Cloud, falls back to env variable `HCLOUD_TOKEN`   | `none`                         |
| `minecraft_version` | Minecraft server version to build.                                   | `1.21.4`                       |
| `plugins`           | List of objexts specifying a plugin (folder) name and a download URL | See `plugins.auto.pkrvars.hcl` |
