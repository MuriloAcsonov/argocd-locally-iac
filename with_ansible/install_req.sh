echo -e "\nInstalling ansible...\n"

if ! [ -x "$(command -v ansible)" ]; then
  echo 'Ansible is not installed.' >&2
fi

YUM_CMD=$(which yum)
APT_GET_CMD=$(which apt-get)
MAC_CMD=$(which brew)

if [[ ! -z $YUM_CMD ]]; then    
    sudo yum install -y epel-release
    sudo yum install -y ansible
 elif [[ ! -z $APT_GET_CMD ]]; then
    apt-get install -y ansible
 elif [[ ! -z $MAC_CMD ]]; then
    brew install ansible
 else
    echo "error can't install package ansible on you distro"
    exit 1;
 fi

echo -e "\nInstalling argocd\n"
if ! [ -x "$(command -v argocd)" ]; then
   if [[ ! -z $MAC_CMD ]]; then
      VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
      curl -sSL -o argocd-darwin-arm64 https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-darwin-arm64
      sudo install -m 555 argocd-darwin-arm64 /usr/local/bin/argocd
      rm argocd-darwin-arm64
   else
      curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
      sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
      rm argocd-linux-amd64
   fi
else
   echo -e '\nargocd is already installed.\n' >&2     
fi