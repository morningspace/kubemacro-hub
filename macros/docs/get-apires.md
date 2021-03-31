## Macro: get-apires

Get API resources in a namespace.

<!-- tabs:start -->

### **Description**


Get API resources in a namespace.



### **Usage & Options**

**Usage**

kubectl macro get-apires [options]

**Options**

```

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# Get all API resources in a namespace.
kubectl macro get-apires
# Get API resources whose names match specified regex in a namespace.
kubectl macro get-apires --include '^endpoints$|^deployments.*$'
kubectl macro get-apires --include '^service' --exclude '.*coreos.*|account'
# Get API resources in a namespace with output format specified.
kubectl macro get-apires -o wide

```

### **Dependencies**

There is no dependency for this macro.

### **Code**

?> To install this macro, copy the code into a local file and save as `get-apires.sh` in `$HOME/.kubemacro`.

[filename](../bin/get-apires.sh ':include :type=code shell')

<!-- tabs:end -->
