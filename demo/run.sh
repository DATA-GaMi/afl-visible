#!/usr/bin/env bash
read -rp "Openserver_PATH:" Open_server
echo
read -rp "httpserver_PATH:" Http_server
echo
read -rp "IP:" Ip
echo
read -rp "docker - 6767 -:" Port
nohup python "$Open_server" 6767 &
cd "$Http_server" || return &&\
perl -pi -e "s/10.10.20.177/$Ip/gi" *.html &&\
perl -pi -e "s/6767/$Port/gi" *.html &&\
nohup python -m http.server 8000 &