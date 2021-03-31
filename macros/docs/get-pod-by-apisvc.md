## get-pod-by-apisvc

Get all pods belonging to an API service.

<!-- tabs:start -->

### **Description**


Get all pods belonging to an API service.



### **Usage & Options**

#### Usage

kubectl macro get-pod-by-apisvc (NAME) [options]

#### Options

```

```

### **Examples**

```shell
# Get pods belonging to an API service.
kubectl macro get-pod-by-apisvc v1beta1.certificates.k8s.io
# Get pods belonging to an API service with output format specified.
kubectl macro get-pod-by-apisvc v1beta1.certificates.k8s.io -o wide
kubectl macro get-pod-by-apisvc v1beta1.certificates.k8s.io -o jsonpath='{.items[*].metadata.name}{"
"}'
# Pipe the output to kubectl describe.
kubectl macro get-pod-by-apisvc v1beta1.certificates.k8s.io -o name | xargs -t kubectl describe

```

### **Dependencies**

* jq
* [get-pod-by-svc](docs/get-pod-by-svc.md)

### **Installation**

To install this macro:
```shell
$ kubectl macro install get-pod-by-apisvc
```

Alternaltively, you can install it manually by downloading it [here](../bin/get-pod-by-apisvc.sh), then put into `$HOME/.kubemacro`. KubeMacro will pick up it automatically.

### **Code**

[filename](../bin/get-pod-by-apisvc.sh ':include :type=code shell')

<!-- tabs:end -->
