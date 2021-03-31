##
# @Name: delete-pod-by-apisvc
# @Description: Delete all pods belonging to an API service.
#
# Delete all pods belonging to an API service.
#
# @Author: [MorningSpace](https://github.com/morningspace/)
# @Usage: kubectl macro delete-pod-by-apisvc (NAME) [options]
# @Options:
# @Examples:
#   # Delete pods belonging to an API service.
#   kubectl macro delete-pod-by-apisvc v1beta1.certificates.k8s.io
#   # Fore delete pods belonging to an API service in dryrun mode.
#   kubectl macro delete-pod-by-apisvc v1beta1.certificates.k8s.io --force
#   # Delete pods belonging to an API service in dryrun mode.
#   kubectl macro delete-pod-by-apisvc v1beta1.certificates.k8s.io --dry-run=client
# @Dependencies: jq,delete-pod-by-svc
##
function delete-pod-by-apisvc {
  local apisvc=$1
  [[ -z $apisvc ]] && echo "You must specify an API service." >&2 && return 1

  local res="$(kubectl get apiservices $apisvc -o json)"
  local svc=$(echo $res | jq -r .spec.service.name)
  local ns=$(echo $res | jq -r .spec.service.namespace)
  [[ -z $svc || -z $ns || $svc == null || $ns == null ]] && echo "No service belonging to API service $apisvc found." >&2 && return 1
  
  echo "Found $svc service belonging to API service $apisvc in $ns namespace." >&2

  delete-pod-by-svc $svc -n $ns ${@:2}
}
