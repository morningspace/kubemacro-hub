## delete-apisvc-unavailable

Delete all API services that are unavailable.

<!-- tabs:start -->

### **Description**


Delete all API services that are unavailable.



### **Usage & Options**

#### Usage

kubectl macro delete-apisvc-unavailable [options]

#### Options

```
-y, --assumeyes answer yes for all questions

```

### **Examples**

```shell
# To delete all unavailable API services.
kubectl macro delete-apisvc-unavailable
# To delete all unavailable API services without prompt.
kubectl macro delete-apisvc-unavailable -y
# To delete all unavailable API services in dry run mode.
kubectl macro delete-apisvc-unavailable --dry-run=client

```

### **Dependencies**

* awk

### **Installation**

To install this macro:
```shell
$ kubectl macro install delete-apisvc-unavailable
```

Alternaltively, you can install it manually by downloading it [here](../bin/delete-apisvc-unavailable.sh), then put into `$HOME/.kubemacro`. KubeMacro will pick up it automatically.

### **Code**

[filename](../bin/delete-apisvc-unavailable.sh ':include :type=code shell')

<!-- tabs:end -->
