##
# @Name: get-pod-by-apisvc
# @Description: Get all pods belonging to an API service.
#
# Get all pods belonging to an API service.
#
# @Author: [MorningSpace](https://github.com/morningspace/)
# @Usage: kubectl macro get-pod-by-apisvc (NAME) [options]
# @Options:
# @Examples:
#   # Get pods belonging to an API service.
#   kubectl macro get-pod-by-apisvc v1beta1.certificates.k8s.io
#   # Get pods belonging to an API service with output format specified.
#   kubectl macro get-pod-by-apisvc v1beta1.certificates.k8s.io -o wide
#   kubectl macro get-pod-by-apisvc v1beta1.certificates.k8s.io -o jsonpath='{.items[*].metadata.name}{"\n"}'
#   # Pipe the output to kubectl describe.
#   kubectl macro get-pod-by-apisvc v1beta1.certificates.k8s.io -o name | xargs -t kubectl describe
# @Dependencies: jq,get-pod-by-svc
##
function get-pod-by-apisvc {
  local apisvc=$1
  [[ -z $apisvc ]] && echo "You must specify an API service." >&2 && return 1

  local res="$(kubectl get apiservices $apisvc -o json)"
  local svc=$(echo $res | jq -r .spec.service.name)
  local ns=$(echo $res | jq -r .spec.service.namespace)
  [[ -z $svc || -z $ns || $svc == null || $ns == null ]] && echo "No service belonging to API service $apisvc found." >&2 && return 1
  
  echo "Found $svc service belonging to API service $apisvc in $ns namespace." >&2

  get-pod-by-svc $svc -n $ns ${@:2}
}
