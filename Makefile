exec_all_bash:
	@cd with_bash && bash install.sh && bash create_clusters.sh && bash install_argo.sh && bash configure_docker_network.sh && bash configure_argo.sh && bash final.sh

destroy_all_bash:
	@cd with_bash && bash remove_argocd.sh && bash remove_clusters.sh && bash remove_prerequisites.sh

exec_cluster_bash:
	@cd with_bash && bash create_clusters.sh && bash install_argo.sh && bash configure_docker_network.sh && bash configure_argo.sh && bash final.sh

destroy_cluster_bash:
	@cd with_bash && bash remove_argocd.sh && bash remove_clusters.sh

exec_ansible:
	bash with_ansible/install_req.sh && ansible-playbook with_ansible/playbook.yaml && bash with_bash/final.sh