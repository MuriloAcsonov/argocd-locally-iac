echo "\t\nInstalling ArgoCD"
echo "Prerequisites:"
echo -e "#1: kubectl (won't be installed automatically)\n"

if ! [ -x "$(command -v kubectl)" ]; then
  echo 'Error: kubectl is not installed.' >&2
  exit 1
fi

export KUBECONFIG=$HOME/.kube/config
kubectl config use-context k3d-prod

kubectl create ns argocd

echo -e "aplying argocd to the prd cluster..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo -e "Waiting for argocd server run\n"
kubectl wait --for=jsonpath='{.status.phase}'=Running pod -l app.kubernetes.io/name=argocd-server -n argocd

kubectl patch svc argocd-server -n argocd -p \
  '{"spec": {"type": "NodePort", "ports": [{"name": "http", "nodePort": 30000, "port": 80, "protocol": "TCP", "targetPort": 8080}, {"name": "https", "nodePort": 30001, "port": 443, "protocol": "TCP", "targetPort": 8080}]}}'

ARGOCD_PASS=$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo)

echo -e "\t\n\nArgoCD Installed\n\tNow you can access on http://localhost:30000\n\tusername: admin\n\tpassword:$ARGOCD_PASS\n\n"