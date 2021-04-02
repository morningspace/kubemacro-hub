## Macro: get-apires

Get API resources in a namespace.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


This macro can be used to get API resources in a namespace. This is useful when you want to know
what API resources are included in a namespace.

Using `kubectl get all` can list down all the pods, services, statefulsets, etc. in a namespace
but not all the resources are listed using this command. This marco uses `kubectl api-resources`
to enumerate all resources that match certain criteria in a namespace and combine with `kubectl
get` to list every instance of every matched resource. For example, to get all resources
in `foo` namespace:
```shell
kubectl macro get-apires -n foo
```

When looks for resources, by default the macro will list all resources in a namespace. You can
specify `--include` and/or `--exclude` option with regular expression to filter the resources to
be listed. For example, to list the `endpoints` resource and all resources whose names start with
`deployments`:
```shell
kubectl macro get-apires --include '^endpoints$|^deployments.*$'
```
And, to list all resources whose names start with `service` but exclude those having `coreos` or
`account` in their names:
```shell
kubectl macro get-apires --include '^service' --exclude '.*coreos.*|account'
```

When list the resource instances, you can also specify `-o/--output` and other options provided by
`kubectl get` to customize the output format of the returned list since this macro actually calls
`kubectl get` to get the resources. For example:
```shell
kubectl macro get-apires -n foo -o wide
kubectl macro get-apires -n foo -o yaml
```

Some references about this idea can be found as below:
- https://www.studytonight.com/post/how-to-list-all-resources-in-a-kubernetes-namespace



### **Usage & Options**

**Usage**

kubectl macro get-apires [options]

**Options**

```
 -h, --help: Print the help information.
     --include: Include resources to be deleted by specifying a regular expression.
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
     --exclude: Exclude resources to be deleted by specifying a regular expression.

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# To get all API resources in a namespace.
kubectl macro get-apires -n foo
# To get API resources whose names match specified regular expression in a namespace.
kubectl macro get-apires -n foo --include '^endpoints$|^deployments.*$'
kubectl macro get-apires -n foo --include '^service' --exclude '.*coreos.*|account'
# To get API resources in a namespace with output format specified.
kubectl macro get-apires -n foo -o wide
kubectl macro get-apires -n foo -o yaml

```

### **Dependencies**

To run this macro, it requires below dependencies to be installed at first:

n/a

### **Code**

?> To install this macro, you can download it [here](bin/get-apires.sh ':ignore get-apires'), or copy the following code into a local file named as `get-apires.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/get-apires.sh ':include :type=code shell')

<!-- tabs:end -->
