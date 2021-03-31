## get-pod-not-ready

Get all pods that are not ready.

<!-- tabs:start -->

### **Description**


Get all pods that are not ready.



### **Usage & Options**

#### Usage

kubectl macro get-pod-not-ready [options]

#### Options

```

```

### **Examples**

```shell
# Get all pods that are not ready in default namespace.
kubectl macro get-pod-not-ready -n default
# Get all pods that are not ready in all namespaces.
kubectl macro get-pod-not-ready -A
# Get all pods that are not ready with output format specified.
kubectl macro get-pod-not-ready -o json
kubectl macro get-pod-not-ready -A -o name
kubectl macro get-pod-not-ready -A --no-headers
# Get all pods that match specified labels and are not ready.
kubectl macro get-pod-not-ready -l 'app=echo'

```

### **Dependencies**


### **Installation**

To install this macro:
```shell
$ kubectl macro install get-pod-not-ready
```

Alternaltively, you can install it manually by downloading it [here](../bin/get-pod-not-ready.sh), then put into `$HOME/.kubemacro`. KubeMacro will pick up it automatically.

### **Code**

[filename](../bin/get-pod-not-ready.sh ':include :type=code shell')

<!-- tabs:end -->
