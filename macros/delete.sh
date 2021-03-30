##
# @Name: delete
# @Description: Delete resource.
# @Usage: kubectl macro delete ([-f FILENAME] | [-k DIRECTORY] | TYPE [(NAME | -l label | --all)]) [options]
# @Options:
# @Examples:
#   # Delete one or more resources.
#   kubectl macro delete pod/foo
#   kubectl macro delete pod/bar pod/baz
#   kubectl macro delete pods --all
#   # To force delete a resource.
#   kubectl macro delete pod echo --force
#   # To force delete a resource and clear its finalizers.
#   kubectl macro delete pod echo --force --no-finalizer -n default
# @Reference:
#   https://kubernetes.io/docs/tasks/run-application/force-delete-stateful-set-pod/
##
function delete {
  local args=()
  local arg_ns=''
  local force=0
  local no_finalizer=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -n|--namespace)
      arg_ns="$1 $2"
      args+=("$1 $2")
      shift
      shift ;;
    --force)
      force=1
      shift ;;
    -F|--no-finalizer)
      no_finalizer=1
      shift ;;
    *)
      args+=("$1")
      shift ;;
    esac
  done

  if [[ $force == 1 ]]; then
    # force delete
    kubectl delete ${args[@]} --wait=false --grace-period=0 --force || return 1
  elif [[ $no_finalizer == 0 ]]; then
    # normal delete
    kubectl delete ${args[@]} $arg_force || return 1
  fi

  [[ $no_finalizer == 0 ]] && return 0

  while IFS= read -r line; do
    [[ -z $line ]] && return 1

    # patch finalizer
    kubectl patch $line $arg_ns -p '{"metadata":{"finalizers":[]}}' --type=merge
  done <<< "$(kubectl delete ${args[@]} --dry-run=client -o name)"
}
