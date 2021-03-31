## Macro: get-pod-by-svc

Get all pods belonging to a service.

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

### **Installation**

To install this macro:
```shell
$ kubectl macro install get-pod-by-svc
```

Alternaltively, you can install it manually by downloading it [here](../bin/get-pod-by-svc.sh), then put into `$HOME/.kubemacro`. KubeMacro will pick up it automatically.

### **Code**

[filename](../bin/get-pod-by-svc.sh ':include :type=code shell')

<!-- tabs:end -->
