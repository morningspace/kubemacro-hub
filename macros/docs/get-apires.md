## Macro: get-apires

Get API resources in a namespace.

Author: [morningspace](https://github.com/morningspace/)

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

To run this macro, it requires below dependencies to be installed at first:

n/a

### **Code**

?> To install this macro, you can download it [here](bin/get-apires.sh ':ignore get-apires'), or copy the following code into a local file named as `get-apires.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/get-apires.sh ':include :type=code shell')

<!-- tabs:end -->
