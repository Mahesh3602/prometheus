# Create User
sudo useradd  —-no-create-home --shell /bin/false prometheus

# make directories
mkdir /etc/prometheus
mkdir /var/lib/prometheus

# Allow permission to above 2 folders
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

# download link
wget https://github.com/prometheus/prometheus/releases/download/v2.48.1/prometheus-2.48.1.linux-amd64.tar.gz

# unarchive the downloaded file
tar xvfz prometheus-2.48.1.linux-amd64.tar.gz

# executing process
cd prometheus-2.48.1.linux-amd64/


# copy installations to folder & allow permission
sudo mv console* /etc/prometheus
sudo mv prometheus.yml /etc/prometheus/
sudo chown -R prometheus:prometheus /etc/prometheus

# copy binaries & allow permissions
sudo mv prometheus /usr/local/bin/
sudo mv promtool /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

# Edit service file & paste the content below
sudo vim /etc/systemd/system/prometheus.service

```
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
   --config.file /etc/prometheus/prometheus.yml \
   --storage.tsdb.path /var/lib/prometheus/ \
   --web.console.templates=/etc/prometheus/consoles \
   --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target

```

# start service
sudo systemctl start prometheus

# check status
sudo systemctl status prometheus

# enable state
sudo systemctl enable prometheus

# check if its running on port 9090
  ## configure tcp 9090 in aws security group