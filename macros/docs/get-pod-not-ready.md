## Macro: get-pod-not-ready

Get all pods that are not ready.

Author: [MorningSpace](https://github.com/morningspace/)

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

There is no dependency for this macro.

### **Code**

?> To install this macro, copy the code into a local file and save as `get-pod-not-ready.sh` in `$HOME/.kubemacro`.

[filename](../bin/get-pod-not-ready.sh ':include :type=code shell')

<!-- tabs:end -->
