# Deploy

helm install --dry-run --name seal-morning -f morning.yaml --debug ../seal
helm install --dry-run --name seal-afternoon -f afternoon.yaml --debug ../seal


helm install --name seal-morning -f morning.yaml ../seal
helm install --name seal-afternoon -f afternoon.yaml ../seal

