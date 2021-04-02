## Macro: get-pod-by-apisvc

Get all pods associated with an API service.

Author: [morningspace](https://github.com/morningspace/)

<!-- tabs:start -->

### **Description**


This macro can be used to get all pods associated with a specified API service. This is useful
when you want to inspect the pods associated with an API service.

The non-local API service is usually implemented by the corresponding Kubernetes service and pods.
To inspect this, you can choose such an API service from the list returned by running `kubectl get
apiservices`. Those that the `SERVICE` column marked something other than `Local` are considered
as non-local API service. For example, in our case, `v1beta1.metrics.k8s.io` is non-local:
```shell
kubectl get apiservices
NAME                          SERVICE                                   AVAILABLE   AGE
v1beta1.metrics.k8s.io        openshift-monitoring/prometheus-adapter   True        3d
v1beta1.networking.k8s.io     Local                                     True        3d
```

Print its definition and look for `spec.service` to know which Kubernetes service at the back that
implements this API service:
```shell
kubectl get apiservice v1beta1.metrics.k8s.io -o yaml
```
In our case, it is `prometheus-adapter` in `openshift-monitoring` namespace:
```yaml
apiVersion: apiregistration.k8s.io/v1
kind: APIService
metadata:
  name: v1beta1.metrics.k8s.io
spec:
  group: metrics.k8s.io
  groupPriorityMinimum: 100
  service:
    name: prometheus-adapter
    namespace: openshift-monitoring
    port: 443
  version: v1beta1
  versionPriority: 100
```

Then, print the Kubernetes service definition and look for `spec.selector`, you will know which pods
are associated with this service:
```shell
kubectl get svc prometheus-adapter -n openshift-monitoring -o yaml
```
In our case, the pods should have `name` label with value `prometheus-adapter`:
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

Now, you can list all pods with this label and perform further action against these pods:
```shell
kubectl get pod -l name=prometheus-adapter  -n openshift-monitoring
NAME                                  READY   STATUS    RESTARTS   AGE
prometheus-adapter-6856976f54-42jzh   1/1     Running   0          3d
prometheus-adapter-6856976f54-d428c   1/1     Running   0          3d
```

It is very tedious to go through all above steps every time when you need to inspect the pods. This
macro is aimed to automate the processing by just asking you an API service name. Additionally, when
you inspect pods, you can also specify options such as `-o/--output`, etc. supported by macro 
[get-pod-by-svc](docs/get-pod-by-svc) since this macro calls get-pod-by-svc to get the pods.
You can even pipe the output of this macro with `xargs` for more complicated use case. For example,
use `-o name` option to list the pod names then use `kubectl describe` to describe the pods:
```shell
kubectl macro get-pod-by-apisvc v1beta1.metrics.k8s.io -o name | xargs -t kubectl describe -n openshift-monitoring
```



### **Usage & Options**

**Usage**

kubectl macro get-pod-by-apisvc (NAME) [options]

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
# To get pods associated with an API service.
kubectl macro get-pod-by-apisvc v1beta1.metrics.k8s.io
# To get pods associated with an API service with output format specified.
kubectl macro get-pod-by-apisvc v1beta1.metrics.k8s.io -o wide
kubectl macro get-pod-by-apisvc v1beta1.metrics.k8s.io -o jsonpath='{.items[*].metadata.name}'
# To pipe the output and describe the pods.
kubectl macro get-pod-by-apisvc v1beta1.metrics.k8s.io -o name | xargs -t kubectl describe -n openshift-monitoring

```

### **Dependencies**

To run this macro, it requires below dependencies to be installed at first:

* `jq`
* [get-pod-by-svc](docs/get-pod-by-svc.md)

### **Code**

?> To install this macro, you can download it [here](bin/get-pod-by-apisvc.sh ':ignore get-pod-by-apisvc'), or copy the following code into a local file named as `get-pod-by-apisvc.sh`, then put it in `$HOME/.kubemacro` directory for KubeMacro to pick up.

[filename](../bin/get-pod-by-apisvc.sh ':include :type=code shell')

<!-- tabs:end -->
