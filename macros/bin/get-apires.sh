##
# @Name: get-apires
# @Description: Get API resources in a namespace.
#
# This macro can be used to get API resources in a namespace. This is useful when you want to know
# what API resources are included in a namespace.
#
# Using `kubectl get all` can list down all the pods, services, statefulsets, etc. in a namespace
# but not all the resources are listed using this command. This marco uses `kubectl api-resources`
# to enumerate all resources that match certain criteria in a namespace and combine with `kubectl
# get` to list every instance of every matched resource. For example, to get all resources
# in `foo` namespace:
# ```shell
# kubectl macro get-apires -n foo
# ```
# 
# When looks for resources, by default the macro will list all resources in a namespace. You can
# specify `--include` and/or `--exclude` option with regular expression to filter the resources to
# be listed. For example, to list the `endpoints` resource and all resources whose names start with
# `deployments`:
# ```shell
# kubectl macro get-apires --include '^endpoints$|^deployments.*$'
# ```
# And, to list all resources whose names start with `service` but exclude those having `coreos` or
# `account` in their names:
# ```shell
# kubectl macro get-apires --include '^service' --exclude '.*coreos.*|account'
# ```
# 
# When list the resource instances, you can also specify `-o/--output` and other options supported by
# `kubectl get` to customize the output format of the returned list since this macro actually calls
# `kubectl get` to get the resources. For example:
# ```shell
# kubectl macro get-apires -n foo -o wide
# kubectl macro get-apires -n foo -o yaml
# ```
#
# Some references about this idea can be found as below:
# - https://www.studytonight.com/post/how-to-list-all-resources-in-a-kubernetes-namespace
#
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro get-apires [options]
# @Options:
#   -h, --help: Print the help information.
#       --include: Include resources to be deleted by specifying a regular expression.
#   -n, --namespace='': If present, the namespace scope for this CLI request.
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
#       --exclude: Exclude resources to be deleted by specifying a regular expression.
# @Examples:
#   # To get all API resources in a namespace.
#   kubectl macro get-apires -n foo
#   # To get API resources whose names match specified regular expression in a namespace.
#   kubectl macro get-apires -n foo --include '^endpoints$|^deployments.*$'
#   kubectl macro get-apires -n foo --include '^service' --exclude '.*coreos.*|account'
#   # To get API resources in a namespace with output format specified.
#   kubectl macro get-apires -n foo -o wide
#   kubectl macro get-apires -n foo -o yaml
##
function get-apires {
  process-apires $@ --func get-apires-instances
}

function get-apires-instances {
  kubectl get $@
  res=($(kubectl get $@ -o name))
  return ${#res[@]}
}

function process-apires {
  local ns="current"
  local include='.*'
  local exclude=''
  local process_func
  local args=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -n|--namespace)
      ns=$2
      args+=("-n $ns"); shift; shift ;;
    --include)
      include=$2; shift; shift ;;
    --exclude)
      exclude=$2; shift; shift ;;
    --func)
      process_func=$2; shift; shift ;;
    *)
      args+=("$1"); shift;;
    esac
  done

  echo "Collecting API resources in $ns namespace..." >&2

  local list=()
  local apires
  for apires in $(kubectl api-resources --verbs=list --namespaced -o name 2>/dev/null); do
    [[ $apires =~ $include && ( -z $exclude || ! $apires =~ $exclude ) ]] && list+=("$apires")
  done

  echo "Found ${#list[@]} API resource(s)." >&2

  local apires_count=0
  local apires_processed=0
  local total_processed=0
  for apires in ${list[@]}; do
    echo "$apires_count) Looking for $apires..." >&2

    if [[ -n $process_func ]]; then
      apires_processed=0
      $process_func $apires ${args[@]}
      (( apires_processed += $? ))
      (( total_processed += apires_processed ))
    fi

    echo "$apires_processed instance(s) processed." >&2
    echo >&2

    (( apires_count++ ))
  done

  echo "$total_processed instance(s) processed in total." >&2

}
