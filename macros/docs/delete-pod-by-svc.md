## Macro: delete-pod-by-svc

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

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# Delete pods belonging to service echo in default namespace
kubectl macro delete-pod-by-svc echo -n default

```

### **Dependencies**

* jq
* [get-pod-by-svc](docs/get-pod-by-svc.md)
* [delete-res](docs/delete-res.md)

### **Code**

?> To install this macro, copy the code into a local file and save as `delete-pod-by-svc.sh` in `$HOME/.kubemacro`.

[filename](../bin/delete-pod-by-svc.sh ':include :type=code shell')

<!-- tabs:end -->
