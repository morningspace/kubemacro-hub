## Macro: delete-apires

Delete API resources in a namespace.

<!-- tabs:start -->

### **Description**


Delete API resources in a namespace.



### **Usage & Options**

**Usage**

kubectl macro delete-apires [options]

**Options**

```

```

### **Examples**

```shell
# Delete all API resources in a namespace.
kubectl macro delete-apires -n default
# Delete API resources whose names match specified regex in a namespace.
kubectl macro delete-apires --include '^endpoints$|^deployments.*$'
kubectl macro delete-apires --include '^service' --exclude '.*coreos.*|account'

```

### **Dependencies**

* [get-apires](docs/get-apires.md)
* [delete-res](docs/delete-res.md)

### **Installation**

To install this macro:
```shell
$ kubectl macro install delete-apires
```

Alternaltively, you can install it manually by downloading it [here](../bin/delete-apires.sh), then put into `$HOME/.kubemacro`. KubeMacro will pick up it automatically.

### **Code**

[filename](../bin/delete-apires.sh ':include :type=code shell')

<!-- tabs:end -->
