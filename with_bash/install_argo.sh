echo "\t\nInstalling ArgoCD\n"
echo "Prerequisites:"
echo -e "#1: kubectl (won't be installed automatically)\n"

if ! [ -x "$(command -v kubectl)" ]; then
  echo 'Error: kubectl is not installed.' >&2
  exit 1
fi

export KUBECONFIG=$HOME/.kube/config
kubectl config use-context k3d-dev

echo -e "\ncreating ns argocd\n"
kubectl create ns argocd

kubectl config use-context k3d-prod

echo -e "\ncreating ns argocd\n"
kubectl create ns argocd

echo -e "\naplying argocd to the prd cluster...\n"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo -e "\nWaiting for argocd server run\n"
kubectl wait --for=jsonpath='{.status.phase}'=Running pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=-1s

echo -e "\npatching nodeport service argocd\n"
kubectl patch svc argocd-server -n argocd -p \
  '{"spec": {"type": "NodePort", "ports": [{"name": "http", "nodePort": 30075, "port": 80, "protocol": "TCP", "targetPort": 8080}, {"name": "https", "nodePort": 30076, "port": 443, "protocol": "TCP", "targetPort": 8080}]}}'

while ! kubectl get secret -n argocd argocd-initial-admin-secret; do echo "Waiting for password secret creation..."; sleep 2; done
