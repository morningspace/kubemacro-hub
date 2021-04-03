## Macro: delete-apires

Delete API resources in a namespace.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


This macro can be used to delete API resources in a namespace. This is useful when you want to
gracefully delete a namespace or a namespace that is stuck in `Terminating` status.

The normal `kubectl delete` can be used to delete a namespace, but it does not always succeed.
Sometimes, the namespace can be stuck in `Terminating` status because some API resources in this
namespace are failed to be deleted. This will ultimately prevent the whole namespace from being
deleted. This macro can enumerate all API resources that match certain criteria in a namespace,
then delete the corresponding instances of each resource. For example, to delete all resources in
`foo` namespace:
```shell
kubectl macro delete-apires -n foo
```

When looks for resources, by default the macro will delete all resources in a namespace. You can
specify `--include` and/or `--exclude` option with regular expression to filter the resources to
be deleted. For example, to delete the `endpoints` resource and all resources whose names start
with `deployments`:
```shell
kubectl macro delete-apires --include '^endpoints$|^deployments.*$'
```
And, to delete all resources whose names start with `service` but exclude those having `coreos` or
`account` in their names:
```shell
kubectl macro delete-apires --include '^service' --exclude '.*coreos.*|account'
```

When delete the resource instance, you can also specify `--force` option to force delete, or use
`-F/--no-finalizer` option to clear the finalizer of the instance. This is helpful when you got some
resource instances stuck in `Terminating` status which prevent them from being deleted with normal
`kubectl delete`.



### **Usage & Options**

**Usage**

kubectl macro delete-apires [options]

**Options**

```
     --dry-run='none': Must be "none", "server", or "client". If client strategy, only print the object that would be
 sent, without sending it. If server strategy, submit server-side request without persisting the resource.
     --exclude: Exclude resources to be deleted by specifying a regular expression.
     --force: Immediately remove resources from API and bypass graceful deletion.
 -h, --help: Print the help information.
     --include: Include resources to be deleted by specifying a regular expression.
 -n, --namespace='': If present, the namespace scope for this CLI request.
 -F, --no-finalizer, clear finalizers of the resources.
     --version: Print the version information.

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# To delete all API resources in foo namespace.
kubectl macro delete-apires -n foo
# To delete the `endpoints` resource and all resources whose names start with `deployments`.
kubectl macro delete-apires --include '^endpoints$|^deployments.*$'
# To delete all resources whose names start with `service` but exclude those having `coreos` or `account` in their names.
kubectl macro delete-apires --include '^service' --exclude '.*coreos.*|account'
# To force delete all resources in current namespace.
kubectl macro delete-apires --force

```

### **Dependencies**

To run this macro, it requires below dependencies to be installed at first:

* [get-apires](docs/get-apires.md)
* [delete-res](docs/delete-res.md)

### **Code**

?> To install this macro, you can download it [here](bin/delete-apires.sh ':ignore delete-apires'), or copy the following code into a local file named as `delete-apires.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/delete-apires.sh ':include :type=code shell')

<!-- tabs:end -->
