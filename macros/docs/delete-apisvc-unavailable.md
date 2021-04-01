## Macro: delete-apisvc-unavailable

Delete unavailable API services.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


This macro is designed to delete all API services that are not available. This is useful when you
have API services that do not function for some reason and you want to delete them and re-create 
them.

API services can be failed for many reasons. To check your API services:
```shell
kubectl get apiservice
```

This will list all API services defined in your cluster. By checking the `AVAILABLE` column in the
result list. You may see some API services are marked `False`. For example, below two API services
are marked `False` due to `MissingEndpoints` and `FailedDiscoveryCheck`:
```shell
NAME                                SERVICE                             AVAILABLE                      AGE
v1alpha1.clusterregistry.k8s.io     kube-system/multicluster-hub-core   False (MissingEndpoints)       2d
v1beta1.webhook.certmanager.k8s.io  kube-system/cert-manager-webhook    False (FailedDiscoveryCheck)   2d
```

This macro can iterate over all API services marked `False` and delete them. For each API service 
to be deleted, by default you will be prompted with a message to confirm whether or not to delete.
This can be suppressed by specifying `-y/--assumeyes` option.

You can also specify other options supported by `kubectl delete` since esentially it calls `kubectl
delete` to complete the work. For example, use `--dry-run` option to print the API services to be 
deleted and make assessment before you really decide to delete them.



### **Usage & Options**

**Usage**

kubectl macro delete-apisvc-unavailable [options]

**Options**

```
 -y, --assumeyes: Answer yes for all questions.
     --dry-run='none': Must be "none", "server", or "client". If client strategy, only print the object that would be
 sent, without sending it. If server strategy, submit server-side request without persisting the resource.
 -h, --help: Print the help information.
     --version: Print the version information.

```

### **Examples**

Here are some examples that you can take as reference to understand how to use this macro in practice.
```shell
# To delete all unavailable API services.
kubectl macro delete-apisvc-unavailable
# To delete all unavailable API services without prompt.
kubectl macro delete-apisvc-unavailable -y
# To delete all unavailable API services in dry run mode.
kubectl macro delete-apisvc-unavailable --dry-run=client

```

### **Dependencies**

To run this macro, it requires below dependencies to be installed at first:

* `awk`

### **Code**

?> To install this macro, you can download it [here](bin/delete-apisvc-unavailable.sh ':ignore delete-apisvc-unavailable'), or copy the following code into a local file named as `delete-apisvc-unavailable.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/delete-apisvc-unavailable.sh ':include :type=code shell')

<!-- tabs:end -->
