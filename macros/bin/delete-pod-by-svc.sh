##
# @Name: delete-pod-by-svc
# @Description: Delete all pods belonging to a service.
#
# Delete all pods belonging to a service.
#
# @Author: [MorningSpace](https://github.com/morningspace/)
# @Usage: kubectl macro delete-pod-by-svc (NAME) [options]
# @Options:
# @Examples:
#   # Delete pods belonging to service echo in default namespace
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
