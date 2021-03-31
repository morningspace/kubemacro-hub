## Macro: delete-pod-by-apisvc

Delete all pods belonging to an API service.

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

* jq
* [delete-pod-by-svc](docs/delete-pod-by-svc.md)

### **Code**

?> To install this macro, copy the code into a local file and save as `delete-pod-by-apisvc.sh` in `$HOME/.kubemacro`.

[filename](../bin/delete-pod-by-apisvc.sh ':include :type=code shell')

<!-- tabs:end -->
