## Macro: get-pod-terminating

Get all pods that are terminating.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


Get all pods that are terminating.



### **Usage & Options**

**Usage**

kubectl macro get-pod-terminating [options]

**Options**

```

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
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

To run this macro, it requires below dependencies to be installed at first:

* [get-pod-not-ready](docs/get-pod-not-ready.md)

### **Code**

?> To install this macro, you can download it [here](bin/get-pod-terminating.sh ':ignore get-pod-terminating'), or copy the following code into a local file named as `get-pod-terminating.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/get-pod-terminating.sh ':include :type=code shell')

<!-- tabs:end -->
