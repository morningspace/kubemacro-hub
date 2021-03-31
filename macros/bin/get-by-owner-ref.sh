##
# @Name: get-by-owner-ref
# @Description: Get resources by OwnerReferences.
#
# Get resources by OwnerReferences.
#
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro get-by-owner-ref [options]
# @Options:
# @Examples:
#   # Get pod echo and its parents by navigating OwnerReferences.
#   kubectl macro get-by-owner-ref pod echo -n default
#   # Get all pods that match specified criteria and their parents by navigating OwnerReferences.
#   kubectl macro get-by-owner-ref pod -l 'app=echo'
# @Dependencies: jq
##
function get-by-owner-ref {
  local args=()
  local arg_ns=''

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -n|--namespace)
      arg_ns="$1 $2"
      args+=("$1 $2")
      shift
      shift ;;
    -o*|-A|--all-namespaces)
      shift ;;
    *)
      args+=("$1")
      shift ;;
    esac
  done

  local res_arr=($(kubectl get ${args[@]} -oname))
  for res in ${res_arr[@]}; do
    echo "$res"
    do-get-by-owner-ref '' $res $arg_ns
    echo >&2
  done
}

function do-get-by-owner-ref {
  local pattern=$1
  local refs="`kubectl get ${@:2} -o jsonpath={.metadata.ownerReferences} 2>/dev/null`"

  [[ -z $refs ]] && return

  local kinds=($(echo "$refs" | jq -r '.[].kind'))
  local names=($(echo "$refs" | jq -r '.[].name'))
  local num=${#kinds[@]}
  local i=0
  local j=0
  for (( i=0; i<num; i++ )); do
    local kind="${kinds[$i]}"
    local name="${names[$i]}"

    for (( j=0; j<${#pattern}; j++ )); do
      local last_element="${pattern:$j:1}"
      [[ $last_element == 0 ]] && printf "│  " || printf "   "
    done

    local next_pattern
    if (( i < num - 1 )); then
      printf "├──$kind/$name\n"
      next_pattern="${pattern}0"
    else
      printf "└──$kind/$name\n"
      next_pattern="${pattern}1"
    fi

    do-get-by-owner-ref $next_pattern $kind/$name ${@:3}
  done
}
