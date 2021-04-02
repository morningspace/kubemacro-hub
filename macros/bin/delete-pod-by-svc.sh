##
# @Name: delete-pod-by-svc
# @Description: Delete all pods associated with a service.
#
# This macro can be used to delete all pods associated with a specified service. This is useful
# when you have some services do not function because the pods at the back are failed, and you
# want to force restart these pods.
#
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro delete-pod-by-svc (NAME) [options]
# @Options:
# @Examples:
#   # Delete pods associated with service echo in default namespace
#   kubectl macro delete-pod-by-svc echo -n default
# @Dependencies: jq,get-pod-by-svc,delete-res
##
function delete-pod-by-svc {
  local svc=$1
  local args=(${@:2})
  # get pods by service
  local pods=($(get-pod-by-svc $svc -o name))
  # delete pods
  [[ -n ${pods[@]} ]] && delete ${pods[@]} ${args[@]} || return 1
}
