## Macro: get-pod-restarts

Get the pods that the restart number matches specified criteria.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


This macro can help you find the pods that the restart number matches specified criteria.
For example, to list all pods that the restart number is greater than 100 in current namespace:
```shell
kubectl macro get-pod-restarts -gt 100
```

Usually pods restarted many times indicate that they are not healthy and need your further action.



### **Usage & Options**

**Usage**

kubectl macro get-pod-restarts [options]

**Options**

```

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# Get all pods that did not restart in default namespace.
kubectl macro get-pod-restarts -eq 0 -n default
# Get all pods that restarted greater than 1000 in all namespaces.
kubectl macro get-pod-restarts -gt 1000 -A
# Get all pods that restarted no less than 1000 with output format specified.
kubectl macro get-pod-restarts -ge 1000 -o json
kubectl macro get-pod-restarts -ge 1000 -A -o name
kubectl macro get-pod-restarts -ge 1000 -A --no-headers
# Get all pods that match specified labels and did not restart.
kubectl macro get-pod-restarts -l 'app=echo' -eq 0

```

### **Dependencies**

To run this macro, it requires below dependencies to be installed at first:

* [get-pod-not-ready](docs/get-pod-not-ready.md)

### **Code**

?> To install this macro, you can download it [here](bin/get-pod-restarts.sh ':ignore get-pod-restarts'), or copy the following code into a local file named as `get-pod-restarts.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/get-pod-restarts.sh ':include :type=code shell')

<!-- tabs:end -->
