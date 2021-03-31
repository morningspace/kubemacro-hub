## Macro: get-by-owner-ref

Get resources by OwnerReferences.

Author: [morningspace](https://github.com/morningspace/)

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

To run this macro, it requires below dependencies to be installed at first:

* `jq`

### **Code**

?> To install this macro, you can download it [here](bin/get-by-owner-ref.sh ':ignore get-by-owner-ref'), or copy the following code into a local file named as `get-by-owner-ref.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/get-by-owner-ref.sh ':include :type=code shell')

<!-- tabs:end -->
