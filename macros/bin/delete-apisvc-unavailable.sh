##
# @Name: delete-apisvc-unavailable
# @Description: Delete unavailable API services.
#
# This macro is designed to delete all API services that are not available. This is useful when you
# have API services that do not function for some reason and you want to delete them and re-create 
# them.
#
# API services can be failed for many reasons. To check your API services:
# ```shell
# kubectl get apiservice
# ```
#
# This will list all API services defined in your cluster. By checking the `AVAILABLE` column in the
# result list. You may see some API services are marked `False`. For example, below two API services
# are marked `False` due to `MissingEndpoints` and `FailedDiscoveryCheck`:
# ```shell
# NAME                                SERVICE                             AVAILABLE                      AGE
# v1alpha1.clusterregistry.k8s.io     kube-system/multicluster-hub-core   False (MissingEndpoints)       2d
# v1beta1.webhook.certmanager.k8s.io  kube-system/cert-manager-webhook    False (FailedDiscoveryCheck)   2d
# ```
# 
# This macro can iterate over all API services marked `False` and delete them. For each API service 
# to be deleted, by default you will be prompted with a message to confirm whether or not to delete.
# This can be suppressed by specifying `-y/--assumeyes` option.
# 
# You can also specify other options supported by `kubectl delete` since esentially it calls `kubectl
# delete` to complete the work. For example, use `--dry-run` option to print the API services to be 
# deleted and make assessment before you really decide to delete them.
#
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro delete-apisvc-unavailable [options]
# @Options:
#   -y, --assumeyes: Answer yes for all questions.
#       --dry-run='none': Must be "none", "server", or "client". If client strategy, only print the object that would be
#   sent, without sending it. If server strategy, submit server-side request without persisting the resource.
#   -h, --help: Print the help information.
#       --version: Print the version information.
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
  local dry_run=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -y|--assumeyes)
      assumeyes=1; shift ;;
    --dry-run*)
      dry_run=1; args+=("$1"); shift ;;
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
      if [[ $assumeyes == 1 || $dry_run == 1 ]] || confirm "Are you sure to delete API service $apisvc?"; then
        kubectl delete apiservice $apisvc ${args[@]} && (( deleted++ ))
      fi
    done

    echo "$deleted API service(s) deleted."
  else
    echo "Unavailable API service not found."
  fi
}
