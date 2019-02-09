az group delete --resource-group pbitrainings --no-wait --yes



kubectl config delete-cluster pbitrainingscluster
kubectl config delete-context pbitrainingscluster

kubectl config unset users.clusterUser_pbitrainings_pbitrainingscluster
