## get-by-owner-ref

Get resources by OwnerReferences.

<!-- tabs:start -->

### **Description**


Get resources by OwnerReferences.



### **Usage & Options**

#### Usage

kubectl macro get-by-owner-ref [options]

#### Options

```

```

### **Examples**

```shell
# Get pod echo and its parents by navigating OwnerReferences.
kubectl macro get-by-owner-ref pod echo -n default
# Get all pods that match specified criteria and their parents by navigating OwnerReferences.
kubectl macro get-by-owner-ref pod -l 'app=echo'

```

### **Dependencies**

* jq

### **Installation**

To install this macro:
```shell
$ kubectl macro install get-by-owner-ref
```

Alternaltively, you can install it manually by downloading it [here](../bin/get-by-owner-ref.sh), then put into `$HOME/.kubemacro`. KubeMacro will pick up it automatically.

### **Code**

[filename](../bin/get-by-owner-ref.sh ':include :type=code shell')

<!-- tabs:end -->
