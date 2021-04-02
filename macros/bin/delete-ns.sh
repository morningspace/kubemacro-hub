##
# @Name: delete-ns
# @Description: Force delete a namespace.
#
# This macro is designed to force delete a namespace that is stuck in `Terminating` status.
#
# A namespace can keep `Terminating` for some reason. To force delete such a namespace, this
# macro runs `kubectl delete` to trigger the deletion of the namespace if you haven't done so,
# then clear the finalizers attached to the namespace.
#
# Some references about this idea can be found as below:
# - https://stackoverflow.com/questions/55853312/how-to-force-delete-a-kubernetes-namespace
# - https://github.com/kubernetes/kubernetes/issues/60807#issuecomment-572615776
#
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro delete-ns (NAME) [options]
# @Options:
#   -h, --help: Print the help information.
#       --version: Print the version information.
# @Examples:
#   # To delete `foo` namespace.
#   kubectl macro delete-ns foo
# @Dependencies: tr,sed
##
function delete-ns {
  local ns=$1
  [[ -z $ns ]] && echo "You must specify a namespace." >&2 && return 1

  # Try delete
  kubectl delete ns $ns || return 1

  # Clear finalizer
  echo "Try to clear finalizer for $ns namespace..."
  kubectl get namespace $ns -o json | \
    tr -d "\n" | \
      sed "s/\"finalizers\": \[[^]]*\]/\"finalizers\": []/" | \
        kubectl replace --raw /api/v1/namespaces/$ns/finalize -f - || return 1
}
