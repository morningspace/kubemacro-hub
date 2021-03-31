## Macro: delete-apisvc-unavailable

Delete all API services that are unavailable.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


Delete all API services that are unavailable.



### **Usage & Options**

**Usage**

kubectl macro delete-apisvc-unavailable [options]

**Options**

```
-y, --assumeyes answer yes for all questions

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# To delete all unavailable API services.
kubectl macro delete-apisvc-unavailable
# To delete all unavailable API services without prompt.
kubectl macro delete-apisvc-unavailable -y
# To delete all unavailable API services in dry run mode.
kubectl macro delete-apisvc-unavailable --dry-run=client

```

### **Dependencies**

To run this macro, it requires below dependencies to be installed at first:

* `awk`

### **Code**

?> To install this macro, you can download it [here](bin/delete-apisvc-unavailable.sh ':ignore delete-apisvc-unavailable'), or copy the following code into a local file named as `delete-apisvc-unavailable.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/delete-apisvc-unavailable.sh ':include :type=code shell')

<!-- tabs:end -->
