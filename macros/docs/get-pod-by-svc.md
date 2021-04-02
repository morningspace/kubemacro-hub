## Macro: get-pod-by-svc

Get all pods associated with a service.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


This macro can be used to get all pods associated with a specified service. This is useful when
you want to inspect the pods associated with a service.

The Kubernetes service is implemented by the corresponding pods. To inspect this, you can print
the service definition and look for `spec.selector` to know which pods are associated with this
service. Take the following service as an example:
```shell
kubectl get svc prometheus-adapter -n openshift-monitoring -o yaml
```
The pods should have `name` label with value `prometheus-adapter`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: prometheus-adapter
  namespace: openshift-monitoring
spec:
  clusterIP: 172.30.179.161
  ports:
  - name: https
    port: 443
    protocol: TCP
    targetPort: 6443
  selector:
    name: prometheus-adapter
  sessionAffinity: None
  type: ClusterIP
```

You can list all pods with this label and perform further action against these pods:
```shell
kubectl get pod -l name=prometheus-adapter  -n openshift-monitoring
NAME                                  READY   STATUS    RESTARTS   AGE
prometheus-adapter-6856976f54-42jzh   1/1     Running   0          3d
prometheus-adapter-6856976f54-d428c   1/1     Running   0          3d
```

It is very tedious to go through all above steps every time when you need to inspect the pods. 
This macro is aimed to automate the processing by just asking you a service name. Additionally, 
when you inspect pods, you can also specify options such as `-o/--output`, etc. provided by macro 
[get-pod-by-svc](docs/get-pod-by-svc) as this macro calls get-pod-by-svc to get the pods.
You can even pipe the output of this macro with `xargs` for more complicated use case. For example,
use `-o name` option to list the pod names then use `kubectl describe` to describe the pods:
```shell
kubectl macro get-pod-by-svc prometheus-adapter -n openshift-monitoring -o name | xargs -t kubectl describe -n openshift-monitoring
```



### **Usage & Options**

**Usage**

kubectl macro get-pod-by-svc (NAME) [options]

**Options**

```
 -h, --help: Print the help information.
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
# To get pods associated with a service.
kubectl macro get-pod-by-svc prometheus-adapter -n openshift-monitoring
# To get pods associated with a service with output format specified.
kubectl macro get-pod-by-svc prometheus-adapter -n openshift-monitoring -o wide
kubectl macro get-pod-by-svc prometheus-adapter -n openshift-monitoring -o jsonpath='{.items[*].metadata.name}'
# To pipe the output and describe the pods.
kubectl macro get-pod-by-svc prometheus-adapter -n openshift-monitoring -o name | xargs -t kubectl describe -n openshift-monitoring

```

### **Dependencies**

To run this macro, it requires below dependencies to be installed at first:

* `jq`

### **Code**

?> To install this macro, you can download it [here](bin/get-pod-by-svc.sh ':ignore get-pod-by-svc'), or copy the following code into a local file named as `get-pod-by-svc.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/get-pod-by-svc.sh ':include :type=code shell')

<!-- tabs:end -->
