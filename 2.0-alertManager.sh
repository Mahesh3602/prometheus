# create user
sudo useradd  -—no-create-home --shell /bin/false alertmanager

# create directories
sudo mkdir /etc/alertmanager

# download alertmanager
wget https://github.com/prometheus/alertmanager/releases/download/v0.16.1/alertmanager-0.16.1.linux-amd64.tar.gz

# unarchive the downloaded file
tar -xvf alertmanager-0.16.1.linux-amd64.tar.gz

cd alertmanager-0.16.1.linux-amd64/

# move binary files to appropriate directories and allow permissions
sudo mv alertmanager /usr/local/bin/
sudo mv amtool /usr/local/bin/

sudo chown -R alertmanager:alertmanager /usr/local/bin/alertmanager
sudo chown -R alertmanager:alertmanager /usr/local/bin/amtool

# move config file to appropriate directory and allow permissions
sudo mv alertmanager.yml /etc/alertmanager/
sudo chown -R alertmanager:alertmanager /etc/alertmanager/ 

# create systemd service file & copy content from alertmanager.service.txt
sudo vim /etc/systemd/system/alertmanager.service
```
[Unit]
Description=Alertmanager
Wants=network-online.target
After=network-online.target

[Service]
User=alertmanager
Group=alertmanager
Type=simple
WorkingDirectory=/etc/alertmanager/
ExecStart=/usr/local/bin/alertmanager \
   --config.file /etc/alertmanager/alertmanager.yml

[Install]
WantedBy=multi-user.target

```

# stop prometheus if it is running
sudo systemctl stop prometheus

# edit the prometheus service file to add alertmanager as a dependency a
sudo vim /etc/prometheus/prometheus.yml
 ## add localhost:9093 to the alertmanager section in prometheus.yml file

# start prometheus and alertmanager services
sudo systemctl start prometheus
sudo systemctl status prometheus

# reload systemd daemon
sudo systemctl daemon-reload    

# srtart alertmanager service
sudo systemctl start alertmanager
sudo systemctl status alertmanager  

# enable alertmanager service
sudo systemctl enable alertmanager  

# check if its running on port 9093
  ## configure tcp 9093 in aws security group