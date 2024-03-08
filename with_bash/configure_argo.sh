export KUBECONFIG=$HOME/.kube/config
kubectl config use-context k3d-prod

echo -e "Exporting config to new cluster on argo\n"
ARGOCD_PASS=$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo)
argocd login localhost:30000 --insecure --username admin --password $ARGOCD_PASS

echo -e "Exporting config to new cluster on argo\n"
argocd app create nginx --auto-prune --repo https://github.com/MuriloAcsonov/argocd-locally-iac --path ./manifests --dest-server https://kubernetes.default.svc --dest-namespace default --revision main --sync-policy auto 
argocd app create nginx --auto-prune --repo https://github.com/MuriloAcsonov/argocd-locally-iac --path ./manifests --dest-server https://k3d-dev-server-0:6443 --dest-namespace default --revision main --sync-policy auto
