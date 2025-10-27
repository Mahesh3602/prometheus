# create user
sudo useradd --no-create-home --shell /bin/false node_exporter

# get the link from https://prometheus.io/download/#node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz

# extract the tar file
tar -xvzf node_exporter-1.9.1.linux-amd64.tar.gz

# move the binary file to /usr/local/bin
sudo mv node_exporter-1.9.1.linux-amd64/node_exporter /usr/local/bin/

# Edit service file & paste the content below
sudo vim /etc/systemd/system/node_exporter.service

```
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
```

#start the exporter, log output to file, send process to background (you may want to set up the exporter as a service)
#./node_exporter > node.out 2>&1 &


#verify the exporter is exposing metrics
curl http://localhost:9100/metrics

### Prometheus Configuration
# edit the prometheus service file to add alertmanager as a dependency a
sudo vim /etc/prometheus/prometheus.yml

```yaml
scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
    - targets: ['<IP_ADDRESS>:9100']
```

sudo systemctl restart prometheus

