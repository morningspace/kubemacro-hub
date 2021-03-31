## Macro: delete-res

Delete resource.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


Delete resource.

Reference:
- https://kubernetes.io/docs/tasks/run-application/force-delete-stateful-set-pod/



### **Usage & Options**

**Usage**

kubectl macro delete-res ([-f FILENAME] | [-k DIRECTORY] | TYPE [(NAME | -l label | --all)]) [options]

**Options**

```

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# Delete one or more resources.
kubectl macro delete-res pod/foo
kubectl macro delete-res pod/bar pod/baz
kubectl macro delete-res pods --all
# To force delete a resource.
kubectl macro delete-res pod echo --force
# To force delete a resource and clear its finalizers.
kubectl macro delete-res pod echo --force --no-finalizer -n default

```

### **Dependencies**

To run this macro, it requires below dependencies to be installed at first:

n/a

### **Code**

?> To install this macro, you can download it [here](bin/delete-res.sh ':ignore delete-res'), or copy the following code into a local file named as `delete-res.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/delete-res.sh ':include :type=code shell')

<!-- tabs:end -->
