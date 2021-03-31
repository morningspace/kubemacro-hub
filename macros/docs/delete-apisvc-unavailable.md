## Macro: delete-apisvc-unavailable

Delete all API services that are unavailable.

Author: [MorningSpace](https://github.com/morningspace/)

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

* awk

### **Code**

?> To install this macro, copy the code into a local file and save as `delete-apisvc-unavailable.sh` in `$HOME/.kubemacro`.

[filename](../bin/delete-apisvc-unavailable.sh ':include :type=code shell')

<!-- tabs:end -->
