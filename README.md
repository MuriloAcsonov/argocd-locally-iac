# argocd-locally-iac

We have two ways to run our environment, using simple bash or ansible, but everything we will run using make.

In the root of this repo you have a Makefile, all of our commands are there.

### using simple bash

available commands:

* exec_all_bash <br>
this one will exec all scripts, including installing k3d and argocd cli, also it will run some verifications
* exec_cluster_bash <br>
it will run only just the parts of creations, assuming that you already have everything installed
* destroy_all_bash <br>
will destroy everything and it will delete all binaries installed, like argocd, k3d...
* destroy_cluster_bash <br>
it will destroy just the clusters and remove all configurations, but will keep the binaries installed.

### using ansible

available commands:

* exec_ansible: <br>
it will run all scripts to verify and install k3d, argocd and the apps.