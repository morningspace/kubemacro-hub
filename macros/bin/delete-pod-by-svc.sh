##
# @Name: delete-pod-by-svc
# @Description: Delete all pods associated with a service.
#
# This macro can be used to delete all pods associated with a specified service. This is useful
# when you have some services do not function because the pods at the back are failed, and you
# want to force restart these pods.
#
# The Kubernetes service is implemented by the corresponding pods. To inspect this, you can print
# the service definition and look for `spec.selector` to know which pods are associated with this
# service. Take the following service as an example:
# ```shell
# kubectl get svc prometheus-adapter -n openshift-monitoring -o yaml
# ```
# The pods should have `name` label with value `prometheus-adapter`:
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
# You can list all pods with this label and decide whether or not to delete them to trigger the
# pod restart:
# ```shell
# kubectl get pod -l name=prometheus-adapter  -n openshift-monitoring
# NAME                                  READY   STATUS    RESTARTS   AGE
# prometheus-adapter-6856976f54-42jzh   0/1     Pending   0          3d
# prometheus-adapter-6856976f54-d428c   0/1     Pending   0          3d
# ```
#
# It is very tedious to go through all above steps every time when you need to restart the pods. This
# macro is aimed to automate the processing by just asking you a service name. Additionally, when you
# delete pods, you can also specify options such as `--force`, `--dry-run`, etc. supported by macro
# [delete-res](docs/delete-res) since this macro calls delete-res to do the actual deletion.
#
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro delete-pod-by-svc (NAME) [options]
# @Options:
#       --dry-run='none': Must be "none", "server", or "client". If client strategy, only print the object that would be
#       --force: Immediately remove resources from API and bypass graceful deletion.
#   sent, without sending it. If server strategy, submit server-side request without persisting the resource.
#   -F, --no-finalizer, clear finalizers of the resources.
#   -h, --help: Print the help information.
#       --version: Print the version information.
# @Examples:
#   # To delete pods associated with a service.
#   kubectl macro delete-pod-by-svc echo -n foo
#   # To force delete pods associated with a service.
#   kubectl macro delete-pod-by-svc echo --force
#   # To delete pods associated with a service in dry run mode.
#   kubectl macro delete-pod-by-svc echo --dry-run=client
# @Dependencies: get-pod-by-svc,delete-res
##
function delete-pod-by-svc {
  local svc=$1
  local args=(${@:2})

  # get pods by service
  local pods=($(get-pod-by-svc $svc -o name))

  # delete pods
  [[ -n ${pods[@]} ]] && delete ${pods[@]} ${args[@]} || return 1
}
