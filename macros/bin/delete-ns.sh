##
# @Name: delete-ns
# @Description: Delete a namespace.
#
# Delete a namespace.
#
# Reference:
# - https://stackoverflow.com/questions/55853312/how-to-force-delete-a-kubernetes-namespace
# - https://github.com/kubernetes/kubernetes/issues/60807#issuecomment-572615776
#
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro delete-ns (NAME) [options]
# @Options:
# @Examples:
#   # Delete a namespace.
#   kubectl macro delete-ns foo
# @Dependencies: tr,sed
##
function delete-ns {
  local ns=$1
  [[ -z $ns ]] && echo "You must specify a namespace." >&2 && return 1

  # Clear finalizer
  echo "Try to clear finalizer for $ns namespace..."
  kubectl get namespace $ns -o json | \
    tr -d "\n" | \
      sed "s/\"finalizers\": \[[^]]*\]/\"finalizers\": []/" | \
        kubectl replace --raw /api/v1/namespaces/$ns/finalize -f - || return 1

  # Try delete and return immediately
  kubectl delete ns deleteme --wait=false
}
