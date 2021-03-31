## get-pod-terminating

Get all pods that are terminating.

<!-- tabs:start -->

### **Description**


Get all pods that are terminating.



### **Usage & Options**

#### Usage

kubectl macro get-pod-terminating [options]

#### Options

```

```

### **Examples**

```shell
# Get all pods that are terminating in default namespace.
kubectl macro get-pod-terminating -n default
# Get all pods that are terminating in all namespaces.
kubectl macro get-pod-terminating -gt 1000 -A
# Get all pods that are terminating with output format specified.
kubectl macro get-pod-terminating -o json
kubectl macro get-pod-terminating -A -o name
kubectl macro get-pod-terminating -A --no-headers
# Get all pods that match specified labels and are terminating.
kubectl macro get-pod-terminating -l 'app=echo'

```

### **Dependencies**

* [get-pod-not-ready](docs/get-pod-not-ready.md)

### **Installation**

To install this macro:
```shell
$ kubectl macro install get-pod-terminating
```

Alternaltively, you can install it manually by downloading it [here](../bin/get-pod-terminating.sh), then put into `$HOME/.kubemacro`. KubeMacro will pick up it automatically.

### **Code**

[filename](../bin/get-pod-terminating.sh ':include :type=code shell')

<!-- tabs:end -->
