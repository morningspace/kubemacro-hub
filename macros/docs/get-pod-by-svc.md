## Macro: get-pod-by-svc

Get all pods belonging to a service.

Author: [morningspace](https://github.com/morningspace/)

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

To run this macro, it requires below dependencies to be installed at first:

* `jq`

### **Code**

?> To install this macro, you can download it [here](bin/get-pod-by-svc.sh ':ignore get-pod-by-svc'), or copy the following code into a local file named as `get-pod-by-svc.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/get-pod-by-svc.sh ':include :type=code shell')

<!-- tabs:end -->
