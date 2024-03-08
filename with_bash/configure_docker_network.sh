ARGOCD_PASS=$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo)
argocd login localhost:30000 --insecure --username admin --password $ARGOCD_PASS
argocd cluster add -y k3d-prod >&2
argocd cluster add -y k3d-dev >&2

export KUBECONFIG=$HOME/.kube/config
kubectl config use-context k3d-dev

SECRET_NAME=$(kubectl get sa -n kube-system argocd-manager -o json | jq -r '.secrets[0].name')
TOKEN="$(kubectl get secret -n kube-system $SECRET_NAME -o json  | jq  -r .data.token | base64 -d )"
CA_CERT="$(kubectl get cm kube-root-ca.crt -o jsonpath="{['data']['ca\.crt']}" | base64)"

kubectl config use-context k3d-prod
kubectl create secret generic k3d-dev-cluster-secret -n argocd
kubectl label secret k3d-dev-cluster-secret -n argocd "argocd.argoproj.io/secret-type=cluster"
kubectl patch secret k3d-dev-cluster-secret -n argocd -p \
  '{"stringData": {"config": "{\"bearerToken\": \"'$TOKEN'\", \"tlsClientConfig\": { \"insecure\": false, \"caData\": \"'$CA_CERT'\"} }", "name": "k3d-dev", "server": "https://k3d-dev-server-0:6443" }}'

docker network connect k3d-prod k3d-dev-server-0