echo -e "\n\n------------------------------------------------------------------------------------------------\n\n"

echo -e "\n\n\tIf you receive an erro trying to access the apps recently deployed..."
echo -e "\n\tYou will need to refresh them"
echo -e "\n\t#1 using argocd:"
echo -e "\n\targocd app get nginx-dev --hard-refresh"
echo -e "\n\targocd app get nginx --hard-refresh"
echo -e "\n\n\t#2 via UI:"
echo -e "\n\ton the dashboard -> click applications -> refresh (the app it isn't work properly)"

echo -e "\n\n------------------------------------------------------------------------------------------------\n\n"
