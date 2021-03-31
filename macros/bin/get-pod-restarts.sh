##
# @Name: get-pod-restarts
# @Description: Get the pods that the restart number matches specified criteria.
#
# This macro can help you find the pods that the restart number matches specified criteria.
# For example, to list all pods that the restart number is greater than 100 in current namespace:
# ```shell
# kubectl macro get-pod-restarts -gt 100
# ```
#
# Usually pods restarted many times indicate that they are not healthy and need your further action.
#
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro get-pod-restarts [options]
# @Options:
# @Examples:
#   # Get all pods that did not restart in default namespace.
#   kubectl macro get-pod-restarts -eq 0 -n default
#   # Get all pods that restarted greater than 1000 in all namespaces.
#   kubectl macro get-pod-restarts -gt 1000 -A
#   # Get all pods that restarted no less than 1000 with output format specified.
#   kubectl macro get-pod-restarts -ge 1000 -o json
#   kubectl macro get-pod-restarts -ge 1000 -A -o name
#   kubectl macro get-pod-restarts -ge 1000 -A --no-headers
#   # Get all pods that match specified labels and did not restart.
#   kubectl macro get-pod-restarts -l 'app=echo' -eq 0
# @Dependencies: get-pod-not-ready
##
function get-pod-restarts {
  operator=""
  expected_val=""
  local args=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
    "-eq")
      operator="equal to"
      expected_val=$2; shift; shift ;;
    "-lt")
      operator="less than"
      expected_val=$2; shift; shift ;;
    "-gt")
      operator="greater than"
      expected_val=$2; shift; shift ;;
    "-ge")
      operator="no less than"
      expected_val=$2; shift; shift ;;
    "-le")
      operator="no greater than"
      expected_val=$2; shift; shift ;;
    *)
      args+=("$1"); shift ;;
    esac
  done

  # verify input
  [[ -z $operator || -z $expected_val ]] && echo "You must specify an operator and an expected value." && return 1

  test-pod-by-func ${args[@]} --func test-restarts
}

function test-restarts {
  local restarts=$5
  case "$operator" in
  "equal to")
    (( restarts == expected_val )) && return 0 ;;
  "less than")
    (( restarts < expected_val )) && return 0 ;;
  "greater than")
    (( restarts >  expected_val )) && return 0 ;;
  "no less than")
    (( restarts >= expected_val )) && return 0 ;;
  "no greater than")
    (( restarts <=  expected_val )) && return 0 ;;
  esac    
}
