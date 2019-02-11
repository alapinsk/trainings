az group create -n pbitrainings -l westeurope

az aks create -g pbitrainings \
    -n pbitrainingscluster \
    --node-count 1 \
    --node-vm-size Standard_D2s_v3 \
    --generate-ssh-keys

# az aks scale \ 
#     -g pbitrainings \
#     -n pbitrainingscluster \
#     --node-count 5 \

az aks install-cli

az aks get-credentials \
    -g pbitrainings \
    -n pbitrainingscluster
    
kubectl config get-contexts

clear
kubectl cluster-info

#deploy cognitive services
az cognitiveservices account create -n textanalyticspbitest -g pbitrainings --kind TextAnalytics --sku S0 -l WestEurope --yes

