## get-apires

Get API resources in a namespace.

<!-- tabs:start -->

### **Description**


Get API resources in a namespace.



### **Usage & Options**

#### Usage

kubectl macro get-apires [options]

#### Options

```

```

### **Examples**

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


### **Installation**

To install this macro:
```shell
$ kubectl macro install get-apires
```

Alternaltively, you can install it manually by downloading it [here](../bin/get-apires.sh), then put into `$HOME/.kubemacro`. KubeMacro will pick up it automatically.

### **Code**

[filename](../bin/get-apires.sh ':include :type=code shell')

<!-- tabs:end -->
