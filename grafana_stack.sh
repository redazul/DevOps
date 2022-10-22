#create persistent storage
docker volume create grafana-storage

#Run grafana + prometheus
docker run -d -p 3000:3000 --name=grafana -v grafana-storage:/var/lib/grafana grafana/grafana-oss
docker run -d -p 9090:9090 --name=prometheus prom/prometheus

#Config Loki + Promtail
cd /mnt/config
wget https://raw.githubusercontent.com/grafana/loki/v2.6.1/cmd/loki/loki-local-config.yaml -O loki-config.yaml
wget https://raw.githubusercontent.com/grafana/loki/v2.6.1/clients/cmd/promtail/promtail-docker-config.yaml -O promtail-config.yaml

#Run Loki + Promtail
docker run --name loki -d -v $(pwd):/mnt/config -p 3100:3100 grafana/loki:2.6.1 -config.file=/mnt/config/loki-config.yaml
docker run --name promtail -d -v $(pwd):/mnt/config -v /root/log:/var/log --link loki grafana/promtail:2.6.1 -config.file=/mnt/config/promtail-config.yaml
