## Macro: delete-ns

Force delete a namespace.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


This macro is designed to force delete a namespace that is stuck in `Terminating` status.

A namespace can keep `Terminating` for some reason. To force delete such a namespace, this
macro runs `kubectl delete` to trigger the deletion of the namespace if you haven't done so,
then clear the finalizers attached to the namespace.

Some references about this idea can be found as below:
- https://stackoverflow.com/questions/55853312/how-to-force-delete-a-kubernetes-namespace
- https://github.com/kubernetes/kubernetes/issues/60807#issuecomment-572615776



### **Usage & Options**

**Usage**

kubectl macro delete-ns (NAME) [options]

**Options**

```
 -h, --help: Print the help information.
     --version: Print the version information.

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# To delete `foo` namespace.
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
