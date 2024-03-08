echo -e "Start configuring kubernetes clusters\n"

echo -e "\nCreating Prod Cluster"
k3d cluster create prod --api-port 6443 -p "30000-30080:30000-30080@server:0"

echo -e "\nCreating Dev Cluster"
k3d cluster create dev --api-port 6444 -p "30081-30160:30081-30160@server:0"