clear
kubectl apply -f namespace.yml

clear
kubectl apply -f pvc.yml
kubectl get pvc -n production

clear
kubectl get sc

clear
kubectl apply -f sql.yml