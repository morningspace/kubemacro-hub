##
# @Name: delete-res
# @Description: Delete or force delete resource.
#
# This macro is designed to simplify the force deletion of Kubernetes resource which can not be
# deleted gracefully by the normal `kubectl delete`. For example, the resources that are stuck in
# `Terminating`. It is also fully compatible with the normal `kubectl delete` so that it supports
# both delete and force delete.
# 
# For example, to delete one or more resources in a namespace:
# ```shell
# kubectl macro delete-res pod/bar -n foo
# kubectl macro delete-res pod/bar pod/baz -n foo
# kubectl macro delete-res pods --all -n foo
# ```
# It does exactly the same thing as `kubectl delete` does.
#
# To force delete a resource, just need to specify the `--force` option:
# ```shell
# kubectl macro delete-res my-resource --force
# ```
#
# In some cases, you may have to clear the finalizers of a resource to make the force delete work:
# ```shell
# kubectl macro delete-res pod bar --force --no-finalizer -n foo
# ```
#
# Some references about this idea can be found as below:
# - https://kubernetes.io/docs/tasks/run-application/force-delete-stateful-set-pod/
#
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro delete-res ([-f FILENAME] | [-k DIRECTORY] | TYPE [(NAME | -l label | --all)]) [options]
# @Options:
#       --all=false: Delete all resources, including uninitialized ones, in the namespace of the specified resource types.
#       --cascade=true: If true, cascade the deletion of the resources managed by this resource (e.g. Pods created by a
#   ReplicationController).  Default true.
#       --dry-run='none': Must be "none", "server", or "client". If client strategy, only print the object that would be
#   sent, without sending it. If server strategy, submit server-side request without persisting the resource.
#       --field-selector='': Selector (field query) to filter on, supports '=', '==', and '!='.(e.g. --field-selector
#   key1=value1,key2=value2). The server only supports a limited number of field queries per type.
#   -f, --filename=[]: containing the resource to delete.
#       --force=false: If true, immediately remove resources from API and bypass graceful deletion. Note that immediate
#   deletion of some resources may result in inconsistency or data loss and requires confirmation.
#       --grace-period=-1: Period of time in seconds given to the resource to terminate gracefully. Ignored if negative.
#   Set to 1 for immediate shutdown. Can only be set to 0 when --force is true (force deletion).
#       --ignore-not-found=false: Treat "resource not found" as a successful delete. Defaults to "true" when --all is
#   specified.
#   -k, --kustomize='': Process a kustomization directory. This flag can't be used together with -f or -R.
#   -F, --no-finalizer, clear finalizers of the resources.
#       --now=false: If true, resources are signaled for immediate shutdown (same as --grace-period=1).
#   -o, --output='': Output mode. Use "-o name" for shorter output (resource/name).
#       --raw='': Raw URI to DELETE to the server.  Uses the transport specified by the kubeconfig file.
#   -R, --recursive=false: Process the directory used in -f, --filename recursively. Useful when you want to manage
#   related manifests organized within the same directory.
#   -l, --selector='': Selector (label query) to filter on, not including uninitialized ones.
#       --timeout=0s: The length of time to wait before giving up on a delete, zero means determine a timeout from the
#   size of the object
#       --wait=true: If true, wait for resources to be gone before returning. This waits for finalizers.
# @Examples:
#   # Delete one or more resources in a namespace.
#   kubectl macro delete-res pod/bar -n foo
#   kubectl macro delete-res pod/bar pod/baz -n foo
#   kubectl macro delete-res pods --all -n foo
#   # To force delete a resource.
#   kubectl macro delete-res my-resource --force -n foo
#   # To force delete a resource and clear its finalizers.
#   kubectl macro delete-res pod bar --force --no-finalizer -n foo
##
function delete-res {
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
