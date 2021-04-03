##
# @Name: get-pod-restarts
# @Description: Get the pods that the restart number matches specified criteria.
#
# This macro can be used to get the pods that the restart number matches specified criteria. This
# is useful when you want to quickly figure out which pods are not healthy in a namespace or across
# namespaces based on the assumption that a pod in health should not restart too many times.
#
# For example, to list all pods that the restart number is greater than 100 in a namespace:
# ```shell
# kubectl macro get-pod-restarts -gt 100
# ```
#
# All bash-style numeric comparing operators are supported, e.g. `eq`, `gt`, `ge`, `lt`, `le`.
#
# When list the pods, you can also specify `-o/--output` and other options supported by `kubectl get`
# to customize the returned list since this macro actually calls `kubectl get` to get the pods. For
# example:
# ```shell
# kubectl macro get-pod-restarts -ge 1000 -o json
# kubectl macro get-pod-restarts -l 'app=echo' -eq 0
# ```
#
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro get-pod-restarts [options]
# @Options:
#   -A, --all-namespaces=false: If present, list the requested object(s) across all namespaces. Namespace in current
#   context is ignored even if specified with --namespace.
#   -eq, -lt, -gt, -ge, -le: Check if the actual value is equal to, less than, greater than, no less than, or no greater than expected value.
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
#   # To get all pods not restarted in a namespace.
#   kubectl macro get-pod-restarts -eq 0 -n foo
#   # To get all pods restarted greater than 1000 times in all namespaces.
#   kubectl macro get-pod-restarts -gt 1000 -A
#   # To get all pods restarted no less than 1000 times with output format specified.
#   kubectl macro get-pod-restarts -ge 1000 -o json
#   kubectl macro get-pod-restarts -ge 1000 -o name
#   kubectl macro get-pod-restarts -ge 1000 --no-headers
#   # To get all pods match specified labels and not restarted.
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
