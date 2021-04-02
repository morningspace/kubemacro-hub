## Macro: get-pod-status

Get the pods that pod status matches specified criteria.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


This macro can be used to get the pods that the pod status matches specified criteria. This is
useful when you want to quickly filter out pods by status in a namespace or across namespaces.

For example, to get all pods being terminating in a namespace:
```shell
kubectl macro get-pod-status -eq Terminating -n foo
```

The bash-style string comparing operators, `eq` and `ne`, are supported. As another example, to
list all pods across namespaces that pod status is not equal to `Running`:
```shell
kubectl macro get-pod-status -ne Running -A
```

It also supports pod status match by specifying a regular expression. For example, to get all
pods that pod status ends with `BackOff`:
```shell
kubectl macro get-pod-status -m '.*BackOff' -n foo
```
Or pod status is either `Pending` or `Completed`:
```shell
kubectl macro get-pod-status -m 'Pending|Completed' -n foo
```

When list the pods, you can also specify `-o/--output` and other options supported by `kubectl
get` to customize the returned list since this macro actually calls `kubectl get` to get the pods.
For example:
```shell
kubectl macro get-pod-status -m 'Running' -o json
kubectl macro get-pod-status -m '.*Error' -A -o wide
kubectl macro get-pod-status -ne Running -l 'app=echo'
```



### **Usage & Options**

**Usage**

kubectl macro get-pod-status [options]

**Options**

```
 -A, --all-namespaces=false: If present, list the requested object(s) across all namespaces. Namespace in current
 context is ignored even if specified with --namespace.
 -eq, -ne: Check if the actual value is equal to or not equal to the expected value.
 -h, --help: Print the help information.
 -m, --match: Check if the actual value matches the regular expression.
 -n, --namespace='': If present, the namespace scope for this CLI request.
     --no-headers=false: When using the default or custom-column output format, don't print headers (default print
 headers).
 -o, --output='': Output format. One of:
 json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
     --show-kind=false: If present, list the resource type for the requested object(s).
     --show-labels=false: When printing, show all labels as the last column (default hide labels column)
     --sort-by='': If non-empty, sort list types using this field specification.  The field specification is expressed
 as a JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath expression
 must be an integer or a string.
     --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The
 template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
 -w, --watch=false: After listing/getting the requested object, watch for changes. Uninitialized objects are excluded
 if no object name is provided.
     --watch-only=false: Watch for changes to the requested object(s), without listing/getting first.
     --version: Print the version information.

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# To get all pods that pod status is equal to Terminating in a namespace.
kubectl macro get-pod-status -eq Terminating -n foo
# To get all pods that pod status is not equal to Running in all namespaces.
kubectl macro get-pod-status -ne Running -A
# To get all pods that pod status matches regular expression.
kubectl macro get-pod-status -m '^Terminating$' -n foo
kubectl macro get-pod-status -m '.*BackOff' -n foo
kubectl macro get-pod-status -m 'Pending|Completed' -n foo
# To get all pods that pod status matches regular expression with output format specified.
kubectl macro get-pod-status -m 'Running' -o json
kubectl macro get-pod-status -m '.*Error' -A -o name
kubectl macro get-pod-status -m '.*Error' -A -o wide
# To get all pods that match specified labels and are not running.
kubectl macro get-pod-status -ne Running -l 'app=echo'

```

### **Dependencies**

To run this macro, it requires below dependencies to be installed at first:

* [get-pod-not-ready](docs/get-pod-not-ready.md)

### **Code**

?> To install this macro, you can download it [here](bin/get-pod-status.sh ':ignore get-pod-status'), or copy the following code into a local file named as `get-pod-status.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/get-pod-status.sh ':include :type=code shell')

<!-- tabs:end -->
