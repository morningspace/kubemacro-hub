## Macro: delete-ns

Delete a namespace.

<!-- tabs:start -->

### **Description**


Delete a namespace.
Reference:
https://stackoverflow.com/questions/55853312/how-to-force-delete-a-kubernetes-namespace
https://github.com/kubernetes/kubernetes/issues/60807#issuecomment-572615776



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

* tr
* sed

### **Code**

?> To install this macro, copy the code into a local file and save as `delete-ns.sh` in `$HOME/.kubemacro`.

[filename](../bin/delete-ns.sh ':include :type=code shell')

<!-- tabs:end -->
