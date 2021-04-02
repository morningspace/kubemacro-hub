##
# @Name: get-pod-status
# @Description: Get the pods that pod status matches specified criteria.
#
# This macro can be used to get the pods that the pod status matches specified criteria. This is
# useful when you want to quickly filter out pods by status in a namespace or across namespaces.
# 
# For example, to get all pods being terminating in a namespace:
# ```shell
# kubectl macro get-pod-status -eq Terminating -n foo
# ```
#
# The bash-style string comparing operators, `eq` and `ne`, are supported. As another example, to
# list all pods across namespaces that pod status is not equal to `Running`:
# ```shell
# kubectl macro get-pod-status -ne Running -A
# ```
#
# It also supports pod status match by specifying a regular expression. For example, to get all
# pods that pod status ends with `BackOff`:
# ```shell
# kubectl macro get-pod-status -m '.*BackOff' -n foo
# ```
# Or pod status is either `Pending` or `Completed`:
# ```shell
# kubectl macro get-pod-status -m 'Pending|Completed' -n foo
# ```
#
# When list the pods, you can also specify `-o/--output` and other options supported by `kubectl
# get` to customize the returned list since this macro actually calls `kubectl get` to get the pods.
# For example:
# ```shell
# kubectl macro get-pod-status -m 'Running' -o json
# kubectl macro get-pod-status -m '.*Error' -A -o wide
# kubectl macro get-pod-status -ne Running -l 'app=echo'
# ```
#
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro get-pod-status [options]
# @Options:
#   -A, --all-namespaces=false: If present, list the requested object(s) across all namespaces. Namespace in current
#   context is ignored even if specified with --namespace.
#   -eq, -ne: Check if the actual value is equal to or not equal to the expected value.
#   -h, --help: Print the help information.
#   -m, --match: Check if the actual value matches the regular expression.
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
#   -w, --watch=false: After listing/getting the requested object, watch for changes. Uninitialized objects are excluded
#   if no object name is provided.
#       --watch-only=false: Watch for changes to the requested object(s), without listing/getting first.
#       --version: Print the version information.
# @Examples:
#   # To get all pods that pod status is equal to Terminating in a namespace.
#   kubectl macro get-pod-status -eq Terminating -n foo
#   # To get all pods that pod status is not equal to Running in all namespaces.
#   kubectl macro get-pod-status -ne Running -A
#   # To get all pods that pod status matches regular expression.
#   kubectl macro get-pod-status -m '^Terminating$' -n foo
#   kubectl macro get-pod-status -m '.*BackOff' -n foo
#   kubectl macro get-pod-status -m 'Pending|Completed' -n foo
#   # To get all pods that pod status matches regular expression with output format specified.
#   kubectl macro get-pod-status -m 'Running' -o json
#   kubectl macro get-pod-status -m '.*Error' -A -o wide
#   # To get all pods that match specified labels and are not running.
#   kubectl macro get-pod-status -ne Running -l 'app=echo'
# @Dependencies: get-pod-not-ready
##
function get-pod-status {
  operator=''
  expected_val=''
  regex=''
  local args=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -eq)
      operator="equal to"
      expected_val=$2; shift; shift ;;
    -ne)
      operator="not equal to"
      expected_val=$2; shift; shift ;;
    -m|--match)
      regex="$2"; shift; shift ;;
    *)
      args+=("$1"); shift ;;
    esac
  done

  # verify input
  if [[ -n $operator && -z $expected_val ]]; then
    echo "You must specify an expected value for $operator operator." && return 1
  elif [[ -z $operator && -z $expected_val && -z $regex ]]; then
    echo "You must specify a regular expression or an operator with expected value." && return 1
  fi

  test-pod-by-func ${args[@]} --func test-status
}

function test-status {
  if [[ $operator == "equal to" ]]; then
    [[ $4 == $expected_val ]] && return 0
  elif [[ $operator == "not equal to" ]]; then
    [[ $4 != $expected_val ]] && return 0
  else
    [[ $4 =~ $regex ]] && return 0
  fi
}
