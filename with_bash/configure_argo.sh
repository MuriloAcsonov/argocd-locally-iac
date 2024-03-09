export KUBECONFIG=$HOME/.kube/config
kubectl config use-context k3d-prod

echo -e "\nWaiting for argocd server run\n"
kubectl wait --for=jsonpath='{.status.phase}'=Running pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=-1s

echo -e "\nCreating our apps...\n"
kubectl apply -f ../applications/app.yaml
sleep 15

kubectl config use-context k3d-prod

while ! kubectl get secret -n argocd argocd-initial-admin-secret; do echo "Waiting for password secret creation..."; sleep 2; done
ARGOCD_PASS=$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo)
argocd login localhost:30075 --insecure --username admin --password $ARGOCD_PASS
argocd app get nginx-dev --hard-refresh
argocd app get nginx --hard-refresh

sleep 15

echo -e "\nWaiting for nginx prod run\n"
kubectl wait --for=jsonpath='{.status.phase}'=Running pod -l app.kubernetes.io/name=nginx --timeout=-1s

kubectl config use-context k3d-dev
echo -e "\nWaiting for nginx dev run\n"
kubectl wait --for=jsonpath='{.status.phase}'=Running pod -l app.kubernetes.io/name=nginx --timeout=-1s

echo -e "\n\n------------------------------------------------------------------------------------------------\n\n"

echo -e "\n\n\tArgoCD Installed!"
echo -e "\n\tYou can access ArgoCD on:"
echo -e "\n\thttp://localhost:30075"
echo -e "\n\tusername: admin"
echo -e "\n\tpassword: $ARGOCD_PASS\n\n"

echo -e "\n\n------------------------------------------------------------------------------------------------\n\n"

echo -e "\n\n\tAlso, you can see on ArgoCD UI our apps:"
echo -e "\tProd: nginx"
echo -e "\tAvailable on: http://localhost:30080"
echo -e "\tDev: nginx-dev"
echo -e "\tAvailable on: http://localhost:30081"

echo -e "\n\n------------------------------------------------------------------------------------------------\n\n"

echo -e "\n\nByee :)"
