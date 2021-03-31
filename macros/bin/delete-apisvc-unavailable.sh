##
# @Name: delete-apisvc-unavailable
# @Description: Delete all API services that are unavailable.
#
# Delete all API services that are unavailable.
#
# @Usage: kubectl macro delete-apisvc-unavailable [options]
# @Options:
#   -y, --assumeyes       answer yes for all questions
# @Examples:
#   # To delete all unavailable API services.
#   kubectl macro delete-apisvc-unavailable
#   # To delete all unavailable API services without prompt.
#   kubectl macro delete-apisvc-unavailable -y
#   # To delete all unavailable API services in dry run mode.
#   kubectl macro delete-apisvc-unavailable --dry-run=client
# @Dependencies: awk
##
function delete-apisvc-unavailable {
  local args=()
  local assumeyes=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -y|--assumeyes)
      assumeyes=1; shift ;;
    *)
      args+=("$1"); shift ;;
    esac
  done

  echo "Detecting unavailable API service..."
  local list=($(kubectl get apiservices | grep False | awk '{print $1}'))
  if [[ ${#list[@]} != 0 ]]; then
    echo "Found ${#list[@]} unavailable API service(s)."

    local deleted=0
    for apisvc in ${list[@]}; do
      if [[ $assumeyes == 1 ]] || confirm "Are you sure to delete API service $apisvc?"; then
        kubectl delete apiservice $apisvc ${args[@]} && (( deleted++ ))
      fi
    done

    echo "$deleted API service(s) deleted."
  else
    echo "Unavailable API service not found."
  fi
}
