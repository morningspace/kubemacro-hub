##
# @Name: get-apires
# @Description: Get API resources in a namespace.
#
# Get API resources in a namespace.
#
# @Author: [MorningSpace](https://github.com/morningspace/)
# @Usage: kubectl macro get-apires [options]
# @Options:
# @Examples:
#   # Get all API resources in a namespace.
#   kubectl macro get-apires
#   # Get API resources whose names match specified regex in a namespace.
#   kubectl macro get-apires --include '^endpoints$|^deployments.*$'
#   kubectl macro get-apires --include '^service' --exclude '.*coreos.*|account'
#   # Get API resources in a namespace with output format specified.
#   kubectl macro get-apires -o wide
##
function get-apires {
  process-apires $@ --func get-apires-instances
}

function get-apires-instances {
  kubectl get $@
  res=($(kubectl get $@ -oname))
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
