##
# @Name: delete-pod-by-apisvc
# @Description: Delete all pods associated with an API service.
#
# This macro can be used to delete all pods associated with a specified API service. This is useful
# when you have some API services do not function because the pods at the back are failed, and you
# want to force restart these pods.
#
# The non-local API service is usually implemented by the corresponding Kubernetes service and pods.
# To inspect this, you can choose such an API service from the list returned by running `kubectl get
# apiservices`. Those that the `SERVICE` column marked something other than `Local` are considered
# as non-local API service. For example, in our case, `v1beta1.metrics.k8s.io` is non-local:
# ```shell
# kubectl get apiservices
# NAME                          SERVICE                                   AVAILABLE                 AGE
# v1beta1.metrics.k8s.io        openshift-monitoring/prometheus-adapter   False (MissingEndpoints)  3d
# v1beta1.networking.k8s.io     Local                                     True                      3d
# ```
#
# Print its definition and look for `spec.service` to know which Kubernetes service at the back that
# implements this API service:
# ```shell
# kubectl get apiservice v1beta1.metrics.k8s.io -o yaml
# ```
# In our case, it is `prometheus-adapter` in `openshift-monitoring` namespace:
# ```yaml
# apiVersion: apiregistration.k8s.io/v1
# kind: APIService
# metadata:
#   name: v1beta1.metrics.k8s.io
# spec:
#   group: metrics.k8s.io
#   groupPriorityMinimum: 100
#   service:
#     name: prometheus-adapter
#     namespace: openshift-monitoring
#     port: 443
#   version: v1beta1
#   versionPriority: 100
# ```
#
# Then, print the Kubernetes service definition and look for `spec.selector`, you will know which pods
# are associated with this service:
# ```shell
# kubectl get svc prometheus-adapter -n openshift-monitoring -o yaml
# ```
# In our case, the pods should have `name` label with value `prometheus-adapter`:
# ```yaml
# apiVersion: v1
# kind: Service
# metadata:
#   name: prometheus-adapter
#   namespace: openshift-monitoring
# spec:
#   clusterIP: 172.30.179.161
#   ports:
#   - name: https
#     port: 443
#     protocol: TCP
#     targetPort: 6443
#   selector:
#     name: prometheus-adapter
#   sessionAffinity: None
#   type: ClusterIP
# ```
#
# Now, you can list all pods with this label and decide whether or not to delete them to trigger the pod
# restart:
# ```shell
# kubectl get pod -l name=prometheus-adapter  -n openshift-monitoring
# NAME                                  READY   STATUS    RESTARTS   AGE
# prometheus-adapter-6856976f54-42jzh   0/1     Pending   0          3d
# prometheus-adapter-6856976f54-d428c   0/1     Pending   0          3d
# ```
#
# It is very tedious to go through all above steps every time when you need to restart the pods. This
# macro is aimed to automate the processing by just asking you an API service name. Additionally, when
# you delete pods, you can also specify options such as `--force`, `--dry-run`, etc. supported by macro
# [delete-res](docs/delete-res) since this macro calls delete-res to do the actual deletion.
#
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro delete-pod-by-apisvc (NAME) [options]
# @Options:
#       --dry-run='none': Must be "none", "server", or "client". If client strategy, only print the object that would be
#       --force: Immediately remove resources from API and bypass graceful deletion.
#   sent, without sending it. If server strategy, submit server-side request without persisting the resource.
#   -F, --no-finalizer, clear finalizers of the resources.
#   -h, --help: Print the help information.
#       --version: Print the version information.
# @Examples:
#   # To delete pods associated with an API service.
#   kubectl macro delete-pod-by-apisvc v1beta1.metrics.k8s.io
#   # To force delete pods associated with an API service.
#   kubectl macro delete-pod-by-apisvc v1beta1.metrics.k8s.io --force
#   # To delete pods associated with an API service in dry run mode.
#   kubectl macro delete-pod-by-apisvc v1beta1.metrics.k8s.io --dry-run=client
# @Dependencies: jq,delete-pod-by-svc
##
function delete-pod-by-apisvc {
  local apisvc=$1
  [[ -z $apisvc ]] && echo "You must specify an API service." >&2 && return 1

  local res="$(kubectl get apiservices $apisvc -o json)"
  local svc=$(echo $res | jq -r .spec.service.name)
  local ns=$(echo $res | jq -r .spec.service.namespace)
  [[ -z $svc || -z $ns || $svc == null || $ns == null ]] && echo "No service associated with API service $apisvc found." >&2 && return 1
  
  echo "Found $svc service associated with API service $apisvc in $ns namespace." >&2

  delete-pod-by-svc $svc -n $ns ${@:2}
}
