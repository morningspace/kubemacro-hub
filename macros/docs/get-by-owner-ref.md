## Macro: get-by-owner-ref

Get resource in a namespace along with its ancestors via owner references.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


This macro can be used to get resource in a namespace along with its ancestors by navigating the
resource `metadata.ownerReferences` field.

Some Kubernetes objects are owners of other objects. For example, a ReplicaSet is the owner of a
set of Pods. The owned objects are called dependents of the owner object. Every dependent object
has a `metadata.ownerReferences` field that points to the owning object.

Using this macro, when you have one resource object, you can reveal its parents and ancestors by
walking through the owner references of each object on the chain. The result will be presented as
a tree. For example, to list pod `echo-5ffc7f444f-pj5xj` and its ancestors:
```shell
kubectl macro get-by-owner-ref pod echo-5ffc7f444f-pj5xj -n foo
pod/echo-5ffc7f444f-pj5xj
└──ReplicaSet/echo-5ffc7f444f
   └──Deployment/echo
```

Because `kubectl get` is used in this macro, you can also specify some of the options supported by
`kubectl get` to customize the returned result. For example, to get all pods that match specified
label along with their ancestors:
```shell
kubectl macro get-by-owner-ref pod -l 'app=echo'
```
This will print the trees for all pods where the pod label `app` is equal to `echo`.

You can even list all objects for a certain resource along with their ancestors in a namespace:
```shell
kubectl macro get-by-owner-ref pods -n foo
```
This will print the trees for all pods in `foo` namespace.



### **Usage & Options**

**Usage**

kubectl macro get-by-owner-ref (TYPE [(NAME | -l label)]) [options]

**Options**

```
 -h, --help: Print the help information.
 -n, --namespace='': If present, the namespace scope for this CLI request.
 -l, --selector='': Selector (label query) to filter on, not including uninitialized ones.
     --version: Print the version information.

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# To get a pod in a namespace along with its ancestors.
kubectl macro get-by-owner-ref pod echo -n foo
# To get all pods in a namespace along with its ancestors.
kubectl macro get-by-owner-ref pod -n foo
# To get all pods that match specified label along with their ancestors.
kubectl macro get-by-owner-ref pod -l 'app=echo'

```

### **Dependencies**

To run this macro, it requires below dependencies to be installed at first:

* `jq`

### **Code**

?> To install this macro, you can download it [here](bin/get-by-owner-ref.sh ':ignore get-by-owner-ref'), or copy the following code into a local file named as `get-by-owner-ref.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/get-by-owner-ref.sh ':include :type=code shell')

<!-- tabs:end -->
