##
# @Name: get-pod-by-svc
# @Description: Get all pods associated with a service.
#
# This macro can be used to get all pods associated with a specified service. This is useful when
# you want to inspect the pods associated with a service.
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
# You can list all pods with this label and perform further action against these pods:
# ```shell
# kubectl get pod -l name=prometheus-adapter  -n openshift-monitoring
# NAME                                  READY   STATUS    RESTARTS   AGE
# prometheus-adapter-6856976f54-42jzh   1/1     Running   0          3d
# prometheus-adapter-6856976f54-d428c   1/1     Running   0          3d
# ```
#
# It is very tedious to go through all above steps every time when you need to inspect the pods. 
# This macro is aimed to automate the processing by just asking you a service name. Additionally, 
# when you inspect pods, you can also specify options such as `-o/--output`, etc. provided by macro 
# [get-pod-by-svc](docs/get-pod-by-svc) as this macro calls get-pod-by-svc to get the pods.
# You can even pipe the output of this macro with `xargs` for more complicated use case. For example,
# use `-o name` option to list the pod names then use `kubectl describe` to describe the pods:
# ```shell
# kubectl macro get-pod-by-svc prometheus-adapter -n openshift-monitoring -o name | xargs -t kubectl describe -n openshift-monitoring
# ```
#
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro get-pod-by-svc (NAME) [options]
# @Options:
#   -h, --help: Print the help information.
#       --no-headers=false: When using the default or custom-column output format, don't print headers (default print
#   headers).
#   -o, --output='': Output format. One of:
#   json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
#       --show-kind=false: If present, list the resource type for the requested object(s).
#       --show-labels=false: When printing, show all labels as the last column (default hide labels column)
#       --sort-by='': If non-empty, sort list types using this field specification.  The field specification is expressed
#   as a JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath expression
#   must be an integer or a string.
#       --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The
#   template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
#   -w, --watch=false: After listing/getting the requested object, watch for changes. Uninitialized objects are excluded
#   if no object name is provided.
#       --watch-only=false: Watch for changes to the requested object(s), without listing/getting first.
#       --version: Print the version information.
# @Examples:
#   # To get pods associated with a service.
#   kubectl macro get-pod-by-svc prometheus-adapter -n openshift-monitoring
#   # To get pods associated with a service with output format specified.
#   kubectl macro get-pod-by-svc prometheus-adapter -n openshift-monitoring -o wide
#   kubectl macro get-pod-by-svc prometheus-adapter -n openshift-monitoring -o jsonpath='{.items[*].metadata.name}'
#   # To pipe the output and describe the pods.
#   kubectl macro get-pod-by-svc prometheus-adapter -n openshift-monitoring -o name | xargs -t kubectl describe -n openshift-monitoring
# @Dependencies: jq
##
function get-pod-by-svc {
  local args=()
  local arg_ns=''

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -n|--namespace)
      arg_ns="$1 $2"
      args+=("$1 $2")
      shift
      shift ;;
    *)
      args+=("$1")
      shift ;;
    esac
  done

  local svc="${args[@]:0:1}"
  [[ -z $svc ]] && echo "You must specify a service." >&2 && return 1

  local resp="$(kubectl get service $svc $arg_ns -o json)"
  [[ -z $resp ]] && return 1

  local labels=($(echo $resp | jq -r '.spec | select(.selector != null) | .selector | to_entries[] | "\(.key)=\(.value)"'))
  [[ -z ${labels[@]} ]] && echo "No selector found in $svc service." >&2 && return 1

  local selector=$(IFS=',' ; echo "${labels[*]}")
  kubectl get pod -l "$selector" ${args[@]:1}
}
