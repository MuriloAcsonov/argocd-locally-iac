echo -e "Getting config from cluster dev\n"
k3d kubeconfig get dev > dev_kubeconfig.yaml

echo -e "Exporting config to new cluster on argo\n"
ARGOCD_PASS=$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo)
argocd login localhost:30000 --username admin --password $ARGOCD_PASS
argocd cluster add dev --kubeconfig dev_kubeconfig.yaml
rm -rf dev_kubeconfig.yaml

echo -e "Exporting config to new cluster on argo\n"
argocd app create nginx --repo https://github.com/MuriloAcsonov/argocd-locally-iac --path ./manifests --dest-server https://kubernetes.default.svc --dest-namespace default
