# Pre-requisites
 ## Running Kubernetes cluster
 ## Sample runningapplication
 ## kubectl configured to communicate with the cluster

# Install Prometheus using Helm
# Install Helm if not already installed
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
# Add Prometheus community helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create a namespace for monitoring
kubectl create namespace monitoring 
# Install Prometheus and Grafana using Helm
helm install my-prometheus-operator prometheus-community/kube-prometheus-stack --namespace monitoring

# Verify the installation
kubectl get pods --namespace monitoring

## Chart has added below components
 # Prometheus Server
 # Alertmanager
 # Pushgateway
 # Grafana
 # Node Exporter
 # Kube State Metrics

# convert the services to NodePort for external access
kubectl patch svc my-prometheus-operator-kub-prometheus -n monitoring -p '{"spec": {"type": "NodePort"}}'

#Get the NodePort assigned
kubectl get svc my-prometheus-operator-kub-prometheus -n monitoring

# same with Grafana
kubectl patch svc my-prometheus-operator-grafana -n monitoring -p '{"spec": {"type": "NodePort"}}'

#Get the NodePort assigned
kubectl get svc my-prometheus-operator-grafana -n monitoring

## Accessing Prometheus and Grafana Dashboards
http://<NodeIP>:9090  # Prometheus
http://<NodeIP>:3000  # Grafana

## exposing services to outside to standalone prometheus and grafana
# Manual addition to your external prometheus.yml
scrape_configs:
  - job_name: 'kubernetes-metrics-targets'
    static_configs:
      - targets:
        - '13.222.52.249:<Prometheus_NodePort>' # Target Prometheus itself
        - '13.222.52.249:<Grafana_NodePort>' # Target Grafana (if it exposes metrics)
        - '13.222.52.249:<MyApp_NodePort>' # Target any custom app exposed via NodePort

# Note: This is an oversimplification. You must configure all Kube-State-Metrics and 
# Node-Exporter targets separately, often by targeting the node IPs directly 
# on their respective NodePorts (3xxxx)



## Additional Configurations
# 1. Node Exporter: Relabel to 'node-exporter' (expected by many dashboards)
- job_name: 'kubernetes-node-exporter'
  static_configs:
    - targets:
      - '10.0.1.23:9100'
      - '10.0.1.71:9100'
  relabel_configs:
    - source_labels: [__address__]
      target_label: job
      replacement: node-exporter # Change job label to 'node-exporter'

# 2. Kube-State-Metrics: Relabel to 'kube-state-metrics' (expected by many dashboards)
- job_name: 'kubernetes-kube-state-metrics'
  static_configs:
    - targets: ['10.0.1.23:31658']
  relabel_configs:
    - source_labels: [__address__]
      target_label: job
      replacement: kube-state-metrics # Change job label to 'kube-state-metrics'