echo -e "\nStart configuring kubernetes clusters\n"

echo -e "\nCreating Prod Cluster\n"
k3d cluster create prod --api-port 6443 -p "30075-30080:30075-30080@server:0"

echo -e "\nCreating Dev Cluster\n"
k3d cluster create dev --api-port 6444 -p "30081-30091:30081-30091@server:0"