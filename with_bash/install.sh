echo "Installing Prerequisites:" 
echo "#1: docker (won't be installed automatically)"
echo "#2: kubectl (won't be installed automatically)"
echo "#3: curl and Wget (will be installed automatically)"
echo "#4: k3d (will be installed automatically)"
echo "#5: argocd (will be installed automatically)"
echo -e "#6: helm (will be installed automatically)\n\n"

if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: docker is not installed.' >&2
  exit 1
fi
if ! [ -x "$(command -v kubectl)" ]; then
  echo 'Error: kubectl is not installed.' >&2
  exit 1
fi

YUM_CMD=$(which yum)
APT_GET_CMD=$(which apt-get)
MAC_CMD=$(which brew)

STANDARD_PKGS="curl wget jq"

echo -e "\nInstalling dependencies\n"
if [[ ! -z $YUM_CMD ]]; then    
    yum install -y $STANDARD_PKGS
 elif [[ ! -z $APT_GET_CMD ]]; then
    apt-get install -y $STANDARD_PKGS
 elif [[ ! -z $MAC_CMD ]]; then
    brew install $STANDARD_PKGS
 else
    echo "error can't install package $STANDARD_PKGS on you distro"
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

echo -e "\nInstalling k3d\n"
if ! [ -x "$(command -v k3d)" ]; then
   echo -e "\nInstalling k3d"
   curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash   
else
   echo -e '\nk3d is already installed.\n' >&2     
fi
