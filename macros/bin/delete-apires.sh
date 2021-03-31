##
# @Name: delete-apires
# @Description: Delete API resources in a namespace.
#
# Delete API resources in a namespace.
#
# @Usage: kubectl macro delete-apires [options]
# @Options:
# @Examples:
#   # Delete all API resources in a namespace.
#   kubectl macro delete-apires -n default
#   # Delete API resources whose names match specified regex in a namespace.
#   kubectl macro delete-apires --include '^endpoints$|^deployments.*$'
#   kubectl macro delete-apires --include '^service' --exclude '.*coreos.*|account'
# @Dependencies: get-apires,delete-res
##
function delete-apires {
  process-apires $@ --func delete-apires-instances
}

function delete-apires-instances {
  local arg_ns=''
  local arg_force=''
  local arg_no_finalizer=''
  local args=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -n|--namespace)
      arg_ns="$1 $2"
      args+=("$1 $2")
      shift
      shift ;;
    --force)
      arg_force=$1
      shift ;;
    -F|--no-finalizer)
      arg_no_finalizer=$1
      shift ;;
    *)
      args+=("$1"); shift;;
    esac
  done

  local deleted=0
  local instance

  for instance in $(kubectl get ${args[@]} -o name); do
    delete $instance $arg_ns $arg_force $arg_no_finalizer && (( deleted++ ))
  done

  return $deleted
}
