## Macro: get-by-owner-ref

Get resources by OwnerReferences.

Author: [MorningSpace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


Get resources by OwnerReferences.



### **Usage & Options**

**Usage**

kubectl macro get-by-owner-ref [options]

**Options**

```

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# Get pod echo and its parents by navigating OwnerReferences.
kubectl macro get-by-owner-ref pod echo -n default
# Get all pods that match specified criteria and their parents by navigating OwnerReferences.
kubectl macro get-by-owner-ref pod -l 'app=echo'

```

### **Dependencies**

* jq

### **Code**

?> To install this macro, copy the code into a local file and save as `get-by-owner-ref.sh` in `$HOME/.kubemacro`.

[filename](../bin/get-by-owner-ref.sh ':include :type=code shell')

<!-- tabs:end -->
