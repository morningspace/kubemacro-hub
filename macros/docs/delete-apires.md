## Macro: delete-apires

Delete API resources in a namespace.

Author: [MorningSpace](https://github.com/morningspace/)

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

Here are some examples that you can take as reference to understand how to use this macro in practice.
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

### **Code**

?> To install this macro, copy the code into a local file and save as `delete-apires.sh` in `$HOME/.kubemacro`.

[filename](../bin/delete-apires.sh ':include :type=code shell')

<!-- tabs:end -->
