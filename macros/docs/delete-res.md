## delete-res

Delete resource.

<!-- tabs:start -->

### **Description**


Delete resource.

Reference:
https://kubernetes.io/docs/tasks/run-application/force-delete-stateful-set-pod/



### **Usage & Options**

**Usage**

kubectl macro delete-res ([-f FILENAME] | [-k DIRECTORY] | TYPE [(NAME | -l label | --all)]) [options]

**Options**

```

```

### **Examples**

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


### **Installation**

To install this macro:
```shell
$ kubectl macro install delete-res
```

Alternaltively, you can install it manually by downloading it [here](../bin/delete-res.sh), then put into `$HOME/.kubemacro`. KubeMacro will pick up it automatically.

### **Code**

[filename](../bin/delete-res.sh ':include :type=code shell')

<!-- tabs:end -->
