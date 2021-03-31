## delete-pod-by-apisvc

Delete all pods belonging to an API service.

<!-- tabs:start -->

### **Description**


Delete all pods belonging to an API service.



### **Usage & Options**

#### Usage

kubectl macro delete-pod-by-apisvc (NAME) [options]

#### Options

```

```

### **Examples**

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

### **Installation**

To install this macro:
```shell
$ kubectl macro install delete-pod-by-apisvc
```

Alternaltively, you can install it manually by downloading it [here](../bin/delete-pod-by-apisvc.sh), then put into `$HOME/.kubemacro`. KubeMacro will pick up it automatically.

### **Code**

[filename](../bin/delete-pod-by-apisvc.sh ':include :type=code shell')

<!-- tabs:end -->
