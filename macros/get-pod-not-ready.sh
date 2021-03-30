##
# @Name: get-pod-not-ready
# @Description: Get all pods that are not ready.
# @Usage: kubectl macro get-pod-not-ready [options]
# @Options:
# @Examples:
#   # Get all pods that are not ready in default namespace.
#   kubectl macro get-pod-not-ready -n default
#   # Get all pods that are not ready in all namespaces.
#   kubectl macro get-pod-not-ready -A
#   # Get all pods that are not ready with output format specified.
#   kubectl macro get-pod-not-ready -o json
#   kubectl macro get-pod-not-ready -A -o name
#   kubectl macro get-pod-not-ready -A --no-headers
#   # Get all pods that match specified labels and are not ready.
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
