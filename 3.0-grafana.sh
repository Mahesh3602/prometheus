# install prerequisites
sudo apt-get install libfontconfig

# download and install grafana .deb package
wget https://dl.grafana.com/oss/release/grafana_5.4.3_amd64.deb
sudo dpkg -i grafana_5.4.3_amd64.deb

# start grafana server
sudo systemctl start grafana-server

# enable grafana to start at boot
sudo systemctl enable grafana-server

# check grafana server status
sudo systemctl status grafana-server

# test grafana by opening a web browser and navigating to http://<your_server_ip>:3000
# default login is admin/admin  (you will be prompted to change the password on first login)    
# add port 3000 to the security group inbound rules if using AWS or similar cloud service