## Macro: delete-res

Delete or force delete resource.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


This macro is designed to simplify the force deletion of Kubernetes resource which can not be
deleted gracefully by the normal `kubectl delete`. For example, the resources that are stuck in
`Terminating`. It is also fully compatible with the normal `kubectl delete` so that it supports
both delete and force delete.

For example, to delete one or more resources in a namespace:
```shell
kubectl macro delete-res pod/bar -n foo
kubectl macro delete-res pod/bar pod/baz -n foo
kubectl macro delete-res pods --all -n foo
```
It does exactly the same thing as `kubectl delete` does.

To force delete a resource, just need to specify the `--force` option:
```shell
kubectl macro delete-res my-resource --force
```

In some cases, you may have to clear the finalizers of a resource to make the force delete work:
```shell
kubectl macro delete-res pod bar --force --no-finalizer -n foo
```

Some references about this idea can be found as below:
- https://kubernetes.io/docs/tasks/run-application/force-delete-stateful-set-pod/



### **Usage & Options**

**Usage**

kubectl macro delete-res ([-f FILENAME] | [-k DIRECTORY] | TYPE [(NAME | -l label | --all)]) [options]

**Options**

```
     --all=false: Delete all resources, including uninitialized ones, in the namespace of the specified resource types.
     --cascade=true: If true, cascade the deletion of the resources managed by this resource (e.g. Pods created by a
 ReplicationController).  Default true.
     --dry-run='none': Must be "none", "server", or "client". If client strategy, only print the object that would be
 sent, without sending it. If server strategy, submit server-side request without persisting the resource.
     --field-selector='': Selector (field query) to filter on, supports '=', '==', and '!='.(e.g. --field-selector
 key1=value1,key2=value2). The server only supports a limited number of field queries per type.
 -f, --filename=[]: containing the resource to delete.
     --force=false: If true, immediately remove resources from API and bypass graceful deletion. Note that immediate
 deletion of some resources may result in inconsistency or data loss and requires confirmation.
     --grace-period=-1: Period of time in seconds given to the resource to terminate gracefully. Ignored if negative.
 Set to 1 for immediate shutdown. Can only be set to 0 when --force is true (force deletion).
     --ignore-not-found=false: Treat "resource not found" as a successful delete. Defaults to "true" when --all is
 specified.
 -k, --kustomize='': Process a kustomization directory. This flag can't be used together with -f or -R.
 -F, --no-finalizer, clear finalizers of the resources.
     --now=false: If true, resources are signaled for immediate shutdown (same as --grace-period=1).
 -o, --output='': Output mode. Use "-o name" for shorter output (resource/name).
     --raw='': Raw URI to DELETE to the server.  Uses the transport specified by the kubeconfig file.
 -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
 related manifests organized within the same directory.
 -l, --selector='': Selector (label query) to filter on, not including uninitialized ones.
     --timeout=0s: The length of time to wait before giving up on a delete, zero means determine a timeout from the
 size of the object
     --wait=true: If true, wait for resources to be gone before returning. This waits for finalizers.

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# To delete one or more resources in a namespace.
kubectl macro delete-res pod/bar -n foo
kubectl macro delete-res pod/bar pod/baz -n foo
kubectl macro delete-res pods --all -n foo
# To force delete a resource.
kubectl macro delete-res my-resource --force -n foo
# To force delete a resource and clear its finalizers.
kubectl macro delete-res pod bar --force --no-finalizer -n foo

```

### **Dependencies**

To run this macro, it requires below dependencies to be installed at first:

n/a

### **Code**

?> To install this macro, you can download it [here](bin/delete-res.sh ':ignore delete-res'), or copy the following code into a local file named as `delete-res.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/delete-res.sh ':include :type=code shell')

<!-- tabs:end -->
