## Macro: delete-pod-by-svc

Delete all pods belonging to a service.

Author: [morningspace](https://github.com/morningspace/)

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

To run this macro, it requires below dependencies to be installed at first:

* `jq`
* [get-pod-by-svc](docs/get-pod-by-svc.md)
* [delete-res](docs/delete-res.md)

### **Code**

?> To install this macro, you can download it [here](bin/delete-pod-by-svc.sh ':ignore delete-pod-by-svc'), or copy the following code into a local file named as `delete-pod-by-svc.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/delete-pod-by-svc.sh ':include :type=code shell')

<!-- tabs:end -->
