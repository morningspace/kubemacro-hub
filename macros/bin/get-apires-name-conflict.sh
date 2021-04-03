##
# @Name: get-apires-name-conflict
# @Description: Get all API resources with name conflicted.
#
# This macro is designed to get API resources that belong to different API groups but have the same
# name. This is useful if you want to check any API resource naming conflict in your cluster.
# 
# Having different API resources with the same name is annoying when you want to list instances of
# these resources. For example, by listing API resources:
# ```shell
# kubectl api-resources
# ```
# You may notice that you have two `ingress` resources:
# ```shell
# NAME          SHORTNAMES   APIGROUP             NAMESPACED   KIND
# ingresses     ing          extensions           true         Ingress
# ingresses     ing          networking.k8s.io    true         Ingress
# ```
# When you run `kubectl get` to get the resources using the resource name or short name, you may
# notice the returned result is not what you expect. You want one type of ingress resources, but
# it returns the other type. To fix it, you need to provide the full resource name appended with
# the API group. For example:
# ```shell
# kubectl get ingresses.extensions
# kubectl get ingresses.networking.k8s.io
# ```
#
# This macro can list all these API resources to give you a view that which API resources have
# such an issue. For example:
# ```shell
# get-apires-name-conflict
# 0) 2 events found:
# NAME          SHORTNAMES   APIGROUP             NAMESPACED   KIND
# events        ev                                true         Event
# events        ev           events.k8s.io        true         Event
#
# 1) 2 ingresses found:
# NAME          SHORTNAMES   APIGROUP             NAMESPACED   KIND
# ingresses     ing          extensions           true         Ingress
# ingresses     ing          networking.k8s.io    true         Ingress
# ```
#
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro get-apires-name-conflict [options]
# @Options:
#   -h, --help: Print the help information.
#       --version: Print the version information.
# @Examples:
#   # To get all API resources with name conflicted.
#   kubectl macro get-apires-name-conflict
# @Dependencies: sort,head,awk,uniq,grep
##
function get-apires-name-conflict {
  # List all api resources and sort by name field
  local lines="$(kubectl api-resources 2>/dev/null | sort -k1,1)"
  local headline=$(echo "$lines" | head -n 1)

  # Filter out api resources that have name conflict
  local lines_conflict="$(echo "$lines" | awk {'print $1'} | uniq -c | grep -v '1 ')"
  local counter=0
  local line

  # Enumerate and print details
  while IFS= read -r line; do
    local parts=(${line})
    local apires_num=${parts[0]}
    local apires_name=${parts[1]}
    echo "$counter) $apires_num $apires_name found:"
    echo "$headline"
    echo "$lines" | grep "^${parts[1]}"
    echo
    (( counter++ ))
  done <<< "$lines_conflict"
  echo "$counter duplicated API resource(s) found in total."
}
