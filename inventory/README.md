# Inventory

This folder hosts the inventory and *kubeconfig* files.

Copy your *kubeconfig* file from your drive to this folder and add  host entry like:

```shell
gcp ansible_host=localhost kubeconfig=/runner/inventory/gcp.kubeconfig cloud_profile=gcp
```

__NOTE__:

* All ansible_host will defaults to localhost as only OpenShift logins will be done

* All the files in this folder will be automatically ignore via git
