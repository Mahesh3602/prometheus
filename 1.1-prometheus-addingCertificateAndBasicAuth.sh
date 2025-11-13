# generate certificate
sudo mkdir -p /etc/prometheus/certs
cd /etc/prometheus/certs

## change the IP address in the CN field to your server's public IP address
sudo openssl req -x509 -newkey rsa:4096 -nodes -keyout prometheus.key -out prometheus.crt -days 365 -subj "/C=US/ST=VA/L=Ashburn/O=Prometheus/CN=34.204.175.212"

# change ownership and permissions
sudo chown prometheus:prometheus prometheus.key prometheus.crt

# create webconfig file
vi /etc/prometheus/web.yml
# Add the following content to web.yml
```
tls_server_config:
  cert_file: /etc/prometheus/certs/prometheus.crt
  key_file: /etc/prometheus/certs/prometheus.key
basic_auth_users:
# Replace 'your_username' and the hash with your generated credentials
    admin: "$2y$05$wH4k1bX6Z1   
```
# generate password hash using:
sudo apt update
sudo apt install apache2-utils
sudo htpasswd -nB your_username 
# Copy the output and paste it in place of the hash above in /etc/prometheus/web.yml

sudo systemctl daemon-reload
sudo systemctl restart prometheus