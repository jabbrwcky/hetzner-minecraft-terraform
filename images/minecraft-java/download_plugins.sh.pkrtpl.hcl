#!/usr/bin/env sh

cd /home/minecrafter
mkdir /home/minecrafter/plugins

%{ for plugin in plugins ~}
curl --output-dir /home/minecrafter/plugins/${plugin.name} --create-dirs -OL ${plugin.url}
%{ endfor ~}

chown -R minecrafter:minecrafter /home/minecrafter/plugins
