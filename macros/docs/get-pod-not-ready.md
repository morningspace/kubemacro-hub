## Macro: get-pod-not-ready

Get all pods that are not ready.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


Get all pods that are not ready.



### **Usage & Options**

**Usage**

kubectl macro get-pod-not-ready [options]

**Options**

```

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
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

To run this macro, it requires below dependencies to be installed at first:

n/a

### **Code**

?> To install this macro, you can download it [here](bin/get-pod-not-ready.sh ':ignore get-pod-not-ready'), or copy the following code into a local file named as `get-pod-not-ready.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/get-pod-not-ready.sh ':include :type=code shell')

<!-- tabs:end -->
