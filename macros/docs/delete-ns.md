## Macro: delete-ns

Delete a namespace.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


Delete a namespace.

Reference:
- https://stackoverflow.com/questions/55853312/how-to-force-delete-a-kubernetes-namespace
- https://github.com/kubernetes/kubernetes/issues/60807#issuecomment-572615776



### **Usage & Options**

**Usage**

kubectl macro delete-ns (NAME) [options]

**Options**

```

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# Delete a namespace.
kubectl macro delete-ns foo

```

### **Dependencies**

To run this macro, it requires below dependencies to be installed at first:

* `tr`
* `sed`

### **Code**

?> To install this macro, you can download it [here](bin/delete-ns.sh ':ignore delete-ns'), or copy the following code into a local file named as `delete-ns.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/delete-ns.sh ':include :type=code shell')

<!-- tabs:end -->
