## Macro: get-pod-by-svc

Get all pods belonging to a service.

Author: [MorningSpace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


Get all pods belonging to a service.



### **Usage & Options**

**Usage**

kubectl macro get-pod-by-svc (NAME) [options]

**Options**

```

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# Get pods belonging to service echo in default namespace.
kubectl macro get-pod-by-svc echo -n default
# Get pods belonging to service echo in default namespace with output format specified.
kubectl macro get-pod-by-svc echo -o wide
kubectl macro get-pod-by-svc echo -o jsonpath='{.items[*].metadata.name}{"
"}'
# Pipe the output to kubectl describe.
kubectl macro get-pod-by-svc echo -o name | xargs -t kubectl describe

```

### **Dependencies**

* jq

### **Code**

?> To install this macro, copy the code into a local file and save as `get-pod-by-svc.sh` in `$HOME/.kubemacro`.

[filename](../bin/get-pod-by-svc.sh ':include :type=code shell')

<!-- tabs:end -->
