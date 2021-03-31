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

```shell
# Delete a namespace.
kubectl macro delete-ns foo

```

### **Dependencies**

* tr
* sed

### **Installation**

To install this macro:
```shell
$ kubectl macro install delete-ns
```

Alternaltively, you can install it manually by downloading it [here](../bin/delete-ns.sh), then put into `$HOME/.kubemacro`. KubeMacro will pick up it automatically.

### **Code**

[filename](../bin/delete-ns.sh ':include :type=code shell')

<!-- tabs:end -->
