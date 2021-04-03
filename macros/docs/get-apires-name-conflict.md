## Macro: get-apires-name-conflict

Get all API resources with name conflicted.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


This macro is designed to get API resources that belong to different API groups but have the same
name. This is useful if you want to check any API resource naming conflict in your cluster.

Having different API resources with the same name is annoying when you want to list instances of
these resources. For example, by listing API resources:
```shell
kubectl api-resources
```
You may notice that you have two `ingress` resources:
```shell
NAME          SHORTNAMES   APIGROUP             NAMESPACED   KIND
ingresses     ing          extensions           true         Ingress
ingresses     ing          networking.k8s.io    true         Ingress
```
When you run `kubectl get` to get the resources using the resource name or short name, you may
notice the returned result is not what you expect. You want one type of ingress resources, but
it returns the other type. To fix it, you need to provide the full resource name appended with
the API group. For example:
```shell
kubectl get ingresses.extensions
kubectl get ingresses.networking.k8s.io
```

This macro can list all these API resources to give you a view that which API resources have
such an issue. For example:
```shell
get-apires-name-conflict
0) 2 events found:
NAME          SHORTNAMES   APIGROUP             NAMESPACED   KIND
events        ev                                true         Event
events        ev           events.k8s.io        true         Event

1) 2 ingresses found:
NAME          SHORTNAMES   APIGROUP             NAMESPACED   KIND
ingresses     ing          extensions           true         Ingress
ingresses     ing          networking.k8s.io    true         Ingress
```



### **Usage & Options**

**Usage**

kubectl macro get-apires-name-conflict [options]

**Options**

```
 -h, --help: Print the help information.
     --version: Print the version information.

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# To get all API resources with name conflicted.
kubectl macro get-apires-name-conflict

```

### **Dependencies**

To run this macro, it requires below dependencies to be installed at first:

* `sort`
* `head`
* `awk`
* `uniq`
* `grep`

### **Code**

?> To install this macro, you can download it [here](bin/get-apires-name-conflict.sh ':ignore get-apires-name-conflict'), or copy the following code into a local file named as `get-apires-name-conflict.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/get-apires-name-conflict.sh ':include :type=code shell')

<!-- tabs:end -->
