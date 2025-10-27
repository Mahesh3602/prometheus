# Add data source
http://<MONITORING_IP_ADDRESS>:9090 

# Login & Add endpoints on monitoring server
sudo vim /etc/prometheus/prometheus.yml

# modify scrape-config file - prometheus/prometheus.yml
```yaml
  - job_name: 'alertmanager'
    static_configs:
    - targets: ['localhost:9093']
  - job_name: 'grafana'
    static_configs:
    - targets: ['<GRAFANA_IP_ADDRESS>:3000']
```

sudo systemctl restart prometheus

