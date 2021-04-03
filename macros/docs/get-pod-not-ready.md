## Macro: get-pod-not-ready

Get the pods that are not ready.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


This macro can be used to get the pods that are not ready. This is useful when you want to quickly
figure out which pods are not healthy in a namespace or across namespaces.

Usually to check whether a pod is healthy or not can be done by running `kubectl get` and checking
the `STATUS` column. But it does not always mean a pod is healthy when you see its status is running.
For example, a pod with multiple containers can be in `Running` status even some of its containers
have not been started yet. A pod not in `Running` status, e.g. `Completed`, does not mean it is not
in health.

This macro considers all the situations when it detects a pod status to determine whether the pod is
actually ready or not.

When list the pods, you can also specify `-o/--output` and other options supported by `kubectl get`
to customize the returned list since this macro actually calls `kubectl get` to get the pods. For
example:
```shell
kubectl macro get-pod-not-ready -o json
kubectl macro get-pod-not-ready -A -o wide
kubectl macro get-pod-not-ready -l 'app=echo'
```



### **Usage & Options**

**Usage**

kubectl macro get-pod-not-ready [options]

**Options**

```
 -A, --all-namespaces=false: If present, list the requested object(s) across all namespaces. Namespace in current
 context is ignored even if specified with --namespace.
 -h, --help: Print the help information.
 -n, --namespace='': If present, the namespace scope for this CLI request.
     --no-headers=false: When using the default or custom-column output format, don't print headers (default print
 headers).
 -o, --output='': Output format. One of:
 json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
 -l, --selector='': Selector (label query) to filter on, not including uninitialized ones.
     --show-kind=false: If present, list the resource type for the requested object(s).
     --show-labels=false: When printing, show all labels as the last column (default hide labels column)
     --sort-by='': If non-empty, sort list types using this field specification.  The field specification is expressed
 as a JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath expression
 must be an integer or a string.
     --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The
 template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
     --version: Print the version information.
 -w, --watch=false: After listing/getting the requested object, watch for changes. Uninitialized objects are excluded
 if no object name is provided.
     --watch-only=false: Watch for changes to the requested object(s), without listing/getting first.

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# To get all pods that are not ready in a namespace.
kubectl macro get-pod-not-ready -n foo
# To get all pods that are not ready in all namespaces.
kubectl macro get-pod-not-ready -A
# To get all pods that are not ready with output format specified.
kubectl macro get-pod-not-ready -o json
kubectl macro get-pod-not-ready -A -o wide
# To get all pods that match specified labels and are not ready.
kubectl macro get-pod-not-ready -l 'app=echo'

```

### **Dependencies**

To run this macro, it requires below dependencies to be installed at first:

n/a

### **Code**

?> To install this macro, you can download it [here](bin/get-pod-not-ready.sh ':ignore get-pod-not-ready'), or copy the following code into a local file named as `get-pod-not-ready.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/get-pod-not-ready.sh ':include :type=code shell')

<!-- tabs:end -->
