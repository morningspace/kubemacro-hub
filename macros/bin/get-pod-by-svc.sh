##
# @Name: get-pod-by-svc
# @Description: Get all pods belonging to a service.
#
# Get all pods belonging to a service.
#
# @Author: [MorningSpace](https://github.com/morningspace/)
# @Usage: kubectl macro get-pod-by-svc (NAME) [options]
# @Options:
# @Examples:
#   # Get pods belonging to service echo in default namespace.
#   kubectl macro get-pod-by-svc echo -n default
#   # Get pods belonging to service echo in default namespace with output format specified.
#   kubectl macro get-pod-by-svc echo -o wide
#   kubectl macro get-pod-by-svc echo -o jsonpath='{.items[*].metadata.name}{"\n"}'
#   # Pipe the output to kubectl describe.
#   kubectl macro get-pod-by-svc echo -o name | xargs -t kubectl describe
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
