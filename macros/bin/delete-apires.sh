##
# @Name: delete-apires
# @Description: Delete API resources in a namespace.
#
# This macro can be used to delete API resources in a namespace. This is useful when you want to
# gracefully delete a namespace or a namespace that is stuck in `Terminating` status.
#
# The normal `kubectl delete` can be used to delete a namespace, but it does not always succeed.
# Sometimes, the namespace can be stuck in `Terminating` status because some API resources in this
# namespace are failed to be deleted. This will ultimately prevent the whole namespace from being
# deleted. This macro can enumerate all API resources that match certain criteria in a namespace,
# then delete the corresponding instances of each resource. For example, to delete all resources in
# `foo` namespace:
# ```shell
# kubectl macro delete-apires -n foo
# ```
#
# When looks for resources, by default the macro will delete all resources in a namespace. You can
# specify `--include` and/or `--exclude` option with regular expression to filter the resources to
# be deleted. For example, to delete the `endpoints` resource and all resources whose names start
# with `deployments`:
# ```shell
# kubectl macro delete-apires --include '^endpoints$|^deployments.*$'
# ```
# And, to delete all resources whose names start with `service` but exclude those having `coreos` or
# `account` in their names:
# ```shell
# kubectl macro delete-apires --include '^service' --exclude '.*coreos.*|account'
# ```
#
# When delete the resource instance, you can also specify `--force` option to force delete, or use
# `-F/--no-finalizer` option to clear the finalizer of the instance. This is helpful when you got some
# resource instances stuck in `Terminating` status which prevent them from being deleted with normal
# `kubectl delete`.
# 
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro delete-apires [options]
# @Options:
#       --dry-run='none': Must be "none", "server", or "client". If client strategy, only print the object that would be
#   sent, without sending it. If server strategy, submit server-side request without persisting the resource.
#       --force: Immediately remove resources from API and bypass graceful deletion.
#       --include: Include resources to be deleted by specifying a regular expression.
#   -n, --namespace='': If present, the namespace scope for this CLI request.
#   -F, --no-finalizer, clear finalizers of the resources.
#       --exclude: Exclude resources to be deleted by specifying a regular expression.
#   -h, --help: Print the help information.
#       --version: Print the version information.
# @Examples:
#   # To delete all API resources in foo namespace.
#   kubectl macro delete-apires -n foo
#   # To delete the `endpoints` resource and all resources whose names start with `deployments`.
#   kubectl macro delete-apires --include '^endpoints$|^deployments.*$'
#   # To delete all resources whose names start with `service` but exclude those having `coreos` or `account` in their names.
#   kubectl macro delete-apires --include '^service' --exclude '.*coreos.*|account'
#   # To force delete all resources in current namespace.
#   kubectl macro delete-apires --force
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
    delete-res $instance $arg_ns $arg_force $arg_no_finalizer && (( deleted++ ))
  done

  return $deleted
}
