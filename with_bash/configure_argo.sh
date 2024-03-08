export KUBECONFIG=$HOME/.kube/config
kubectl config use-context k3d-prod

echo -e "\nWaiting for argocd server run\n"
kubectl wait --for=jsonpath='{.status.phase}'=Running pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=-1s

echo -e "\nCreating our apps...\n"
kubectl apply -f ../applications/app.yaml

echo -e "\nWaiting for nginx prod run\n"
sleep 5
kubectl wait --for=jsonpath='{.status.phase}'=Running pod -l app.kubernetes.io/name=nginx --timeout=-1s

kubectl config use-context k3d-dev
echo -e "\nWaiting for nginx dev run\n"
sleep 1
kubectl wait --for=jsonpath='{.status.phase}'=Running pod -l app.kubernetes.io/name=nginx --timeout=-1s

kubectl config use-context k3d-prod

echo -e "\n\n\tNow you can see on ArgoCD UI our apps:"
echo -e "\tProd: nginx"
echo -e "\tAvailable on: localhost:30080"
echo -e "\tDev: nginx-dev"
echo -e "\tAvailable on: localhost:30081"

echo -e "\n\nByee :)"
