## Macro: get-pod-by-apisvc

Get all pods belonging to an API service.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


Get all pods belonging to an API service.



### **Usage & Options**

**Usage**

kubectl macro get-pod-by-apisvc (NAME) [options]

**Options**

```

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
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

To run this macro, it requires below dependencies to be installed at first:

* `jq`
* [get-pod-by-svc](docs/get-pod-by-svc.md)

### **Code**

?> To install this macro, you can download it [here](bin/get-pod-by-apisvc.sh ':ignore get-pod-by-apisvc'), or copy the following code into a local file named as `get-pod-by-apisvc.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/get-pod-by-apisvc.sh ':include :type=code shell')

<!-- tabs:end -->
