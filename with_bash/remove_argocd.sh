export KUBECONFIG=$HOME/.kube/config
kubectl config use-context k3d-prod

echo -e "deleting argocd from prd cluster..."
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl delete ns argocd