##
# @Name: get-pod-not-ready
# @Description: Get the pods that are not ready.
#
# This macro can be used to get the pods that are not ready. This is useful when you want to quickly
# figure out which pods are not healthy in a namespace or across namespaces.
#
# Usually to check whether a pod is healthy or not can be done by running `kubectl get` and checking
# the `STATUS` column. But it does not always mean a pod is healthy when you see its status is running.
# For example, a pod with multiple containers can be in `Running` status even some of its containers
# have not been started yet. A pod not in `Running` status, e.g. `Completed`, does not mean it is not
# in health.
#
# This macro considers all the situations when it detects a pod status to determine whether the pod is
# actually ready or not.
#
# When list the pods, you can also specify `-o/--output` and other options supported by `kubectl get`
# to customize the returned list since this macro actually calls `kubectl get` to get the pods. For
# example:
# ```shell
# kubectl macro get-pod-not-ready -o json
# kubectl macro get-pod-not-ready -A -o wide
# kubectl macro get-pod-not-ready -l 'app=echo'
# ```
#
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro get-pod-not-ready [options]
# @Options:
#   -A, --all-namespaces=false: If present, list the requested object(s) across all namespaces. Namespace in current
#   context is ignored even if specified with --namespace.
#   -h, --help: Print the help information.
#   -n, --namespace='': If present, the namespace scope for this CLI request.
#       --no-headers=false: When using the default or custom-column output format, don't print headers (default print
#   headers).
#   -o, --output='': Output format. One of:
#   json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...
#   -l, --selector='': Selector (label query) to filter on, not including uninitialized ones.
#       --show-kind=false: If present, list the resource type for the requested object(s).
#       --show-labels=false: When printing, show all labels as the last column (default hide labels column)
#       --sort-by='': If non-empty, sort list types using this field specification.  The field specification is expressed
#   as a JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath expression
#   must be an integer or a string.
#       --template='': Template string or path to template file to use when -o=go-template, -o=go-template-file. The
#   template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
#       --version: Print the version information.
#   -w, --watch=false: After listing/getting the requested object, watch for changes. Uninitialized objects are excluded
#   if no object name is provided.
#       --watch-only=false: Watch for changes to the requested object(s), without listing/getting first.
# @Examples:
#   # To get all pods that are not ready in a namespace.
#   kubectl macro get-pod-not-ready -n foo
#   # To get all pods that are not ready in all namespaces.
#   kubectl macro get-pod-not-ready -A
#   # To get all pods that are not ready with output format specified.
#   kubectl macro get-pod-not-ready -o json
#   kubectl macro get-pod-not-ready -A -o wide
#   # To get all pods that match specified labels and are not ready.
#   kubectl macro get-pod-not-ready -l 'app=echo'
##
function get-pod-not-ready {
  test-pod-by-func $@ --func test-not-ready
}

function test-not-ready {
  local ns=$1
  local name=$2
  local containers=$3
  local total_containers=${containers#*/}
  local ready_containers=${containers%/*}
  local status=$4
  local restarts=$5

  if (( $ready_containers == $total_containers )); then
    [[ $status != Completed && $status != Running ]] && return 0
  else
    [[ $status != Completed ]] && return 0
  fi
  
  return 1
}

function test-pod-by-func {
  local args=()
  local arg_ns=''
  local arg_output=''
  local arg_no_headers=''
  local ns='~' # represents current namespace
  local test_func

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -n|--namespace)
      ns=$2
      arg_ns="$1 $2"
      args+=("$1 $2")
      shift
      shift ;;
    -A|--all-namespaces)
      ns='*'   # represents all namespaces
      arg_ns="$1"
      args+=("$1")
      shift ;;
    -o|--output)
      arg_output="$1 $2"
      shift
      shift ;;
    -o*|--output=*)
      arg_output="$1"
      shift ;;
    --no-headers)
      arg_no_headers="$1"
      shift ;;
    --func)
      test_func="$2"
      shift
      shift ;;
    *)
      args+=("$1")
      shift ;;
    esac
  done

  local line
  local lines="$(kubectl get pods ${args[@]} --no-headers)"
  local parts=()
  local ns_arr=()
  local pod_arr=()

  [[ -z $lines ]] && return

  while IFS= read -r line; do
    [[ $ns == '*' ]] && parts=($line) || parts=($ns $line)

    if [[ -z $test_func ]] || ([[ -n $test_func ]] && $test_func ${parts[@]}); then
      local row_ns=${parts[@]:0:1}
      local row_name=${parts[@]:1:1}

      ns_arr+=("$row_ns")
      pod_arr+=("pod/$row_name")
    fi
  done <<< "$lines"

  [[ ${#pod_arr[@]} == 0 ]] && echo "Found 0 pod(s) in 0 namespace(s)." >&2 && return 0

  if [[ $ns == '~' || $ns != '*' ]]; then
    kubectl get ${pod_arr[@]} $arg_output $arg_no_headers $arg_ns
    echo "Found ${#pod_arr[@]} pod(s) in 1 namespace(s)." >&2
  else
    local pod_count=0
    local ns_count=0
    local pod_num_in_ns=0
    local pods_in_ns=()
    local ns=${ns_arr[0]}

    for (( pod_count = 0; pod_count < ${#pod_arr[@]}; pod_count ++ )); do
      if [[ $ns == ${ns_arr[$pod_count]} ]]; then
        pods_in_ns+=("${pod_arr[pod_count]}")
        (( pod_num_in_ns++ ))
      else
        echo "$ns_count) Found $pod_num_in_ns pod(s) in $ns namespace." >&2
        kubectl get ${pods_in_ns[@]} $arg_output $arg_no_headers -n $ns
        echo >&2

        ns=${ns_arr[$pod_count]}
        pods_in_ns=("${pod_arr[pod_count]}")
        pod_num_in_ns=1
        (( ns_count++ ))
      fi
    done

    echo "$ns_count) Found $pod_num_in_ns pod(s) in $ns namespace." >&2
    kubectl get ${pods_in_ns[@]} $arg_output $arg_no_headers -n $ns
    echo >&2

    (( ns_count++ ))

    echo "Found $pod_count pod(s) in $ns_count namespace(s)." >&2
  fi
}
