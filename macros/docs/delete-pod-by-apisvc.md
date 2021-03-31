## Macro: delete-pod-by-apisvc

Delete all pods belonging to an API service.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


Delete all pods belonging to an API service.



### **Usage & Options**

**Usage**

kubectl macro delete-pod-by-apisvc (NAME) [options]

**Options**

```

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# Delete pods belonging to an API service.
kubectl macro delete-pod-by-apisvc v1beta1.certificates.k8s.io
# Fore delete pods belonging to an API service in dryrun mode.
kubectl macro delete-pod-by-apisvc v1beta1.certificates.k8s.io --force
# Delete pods belonging to an API service in dryrun mode.
kubectl macro delete-pod-by-apisvc v1beta1.certificates.k8s.io --dry-run=client

```

### **Dependencies**

To run this macro, it requires below dependencies to be installed at first:

* `jq`
* [delete-pod-by-svc](docs/delete-pod-by-svc.md)

### **Code**

?> To install this macro, you can download it [here](bin/delete-pod-by-apisvc.sh ':ignore delete-pod-by-apisvc'), or copy the following code into a local file named as `delete-pod-by-apisvc.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/delete-pod-by-apisvc.sh ':include :type=code shell')

<!-- tabs:end -->
