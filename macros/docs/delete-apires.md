## Macro: delete-apires

Delete API resources in a namespace.

Author: [morningspace](https://github.com/morningspace/)

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

To run this macro, it requires below dependencies to be installed at first:

* [get-apires](docs/get-apires.md)
* [delete-res](docs/delete-res.md)

### **Code**

?> To install this macro, you can download it [here](bin/delete-apires.sh ':ignore delete-apires'), or copy the following code into a local file named as `delete-apires.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/delete-apires.sh ':include :type=code shell')

<!-- tabs:end -->
