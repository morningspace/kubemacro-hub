## delete-pod-by-svc

Delete all pods belonging to a service.

<!-- tabs:start -->

### **Description**


Delete all pods belonging to a service.



### **Usage & Options**

**Usage**

kubectl macro delete-pod-by-svc (NAME) [options]

**Options**

```

```

### **Examples**

```shell
# Delete pods belonging to service echo in default namespace
kubectl macro delete-pod-by-svc echo -n default

```

### **Dependencies**

* jq
* [get-pod-by-svc](docs/get-pod-by-svc.md)
* [delete-res](docs/delete-res.md)

### **Installation**

To install this macro:
```shell
$ kubectl macro install delete-pod-by-svc
```

Alternaltively, you can install it manually by downloading it [here](../bin/delete-pod-by-svc.sh), then put into `$HOME/.kubemacro`. KubeMacro will pick up it automatically.

### **Code**

[filename](../bin/delete-pod-by-svc.sh ':include :type=code shell')

<!-- tabs:end -->
