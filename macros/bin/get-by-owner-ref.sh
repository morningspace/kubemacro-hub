##
# @Name: get-by-owner-ref
# @Description: Get resource in a namespace along with its ancestors via owner references.
#
# This macro can be used to get resource in a namespace along with its ancestors by navigating the
# resource `metadata.ownerReferences` field.
#
# Some Kubernetes objects are owners of other objects. For example, a ReplicaSet is the owner of a
# set of Pods. The owned objects are called dependents of the owner object. Every dependent object
# has a `metadata.ownerReferences` field that points to the owning object.
#
# Using this macro, when you have one resource object, you can reveal its parents and ancestors by
# walking through the owner references of each object on the chain. The result will be presented as
# a tree. For example, to list pod `echo-5ffc7f444f-pj5xj` and its ancestors:
# ```shell
# kubectl macro get-by-owner-ref pod echo-5ffc7f444f-pj5xj -n foo
# pod/echo-5ffc7f444f-pj5xj
# └──ReplicaSet/echo-5ffc7f444f
#    └──Deployment/echo
# ```
#
# Because `kubectl get` is used in this macro, you can also specify some of the options supported by
# `kubectl get` to customize the returned result. For example, to get all pods that match specified
# label along with their ancestors:
# ```shell
# kubectl macro get-by-owner-ref pod -l 'app=echo'
# ```
# This will print the trees for all pods where the pod label `app` is equal to `echo`.
#
# You can even list all objects for a certain resource along with their ancestors in a namespace:
# ```shell
# kubectl macro get-by-owner-ref pods -n foo
# ```
# This will print the trees for all pods in `foo` namespace.
#
# @Author: [morningspace](https://github.com/morningspace/)
# @Usage: kubectl macro get-by-owner-ref (TYPE [(NAME | -l label)]) [options]
# @Options:
#   -h, --help: Print the help information.
#   -n, --namespace='': If present, the namespace scope for this CLI request.
#   -l, --selector='': Selector (label query) to filter on, not including uninitialized ones.
#       --version: Print the version information.
# @Examples:
#   # To get a pod in a namespace along with its ancestors.
#   kubectl macro get-by-owner-ref pod echo -n foo
#   # To get all pods in a namespace along with its ancestors.
#   kubectl macro get-by-owner-ref pod -n foo
#   # To get all pods that match specified label along with their ancestors.
#   kubectl macro get-by-owner-ref pod -l 'app=echo'
# @Dependencies: jq
##
function get-by-owner-ref {
  local args=()
  local arg_ns=''

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -n|--namespace)
      arg_ns="$1 $2"
      args+=("$1 $2")
      shift
      shift ;;
    -o*|-A|--all-namespaces)
      shift ;;
    *)
      args+=("$1")
      shift ;;
    esac
  done

  local res_arr=($(kubectl get ${args[@]} -oname))
  for res in ${res_arr[@]}; do
    echo "$res"
    do-get-by-owner-ref '' $res $arg_ns
    echo >&2
  done
}

function do-get-by-owner-ref {
  local pattern=$1
  local res="`kubectl get ${@:2} -o json 2>/dev/null`"
  local refs="`echo $res | jq .metadata.ownerReferences`"

  [[ -z $refs ]] && return

  local kinds=($(echo "$refs" | jq -r '.[].kind'))
  local names=($(echo "$refs" | jq -r '.[].name'))
  local num=${#kinds[@]}
  local i=0
  local j=0
  for (( i=0; i<num; i++ )); do
    local kind="${kinds[$i]}"
    local name="${names[$i]}"

    for (( j=0; j<${#pattern}; j++ )); do
      local last_element="${pattern:$j:1}"
      [[ $last_element == 0 ]] && printf "│  " || printf "   "
    done

    local next_pattern
    if (( i < num - 1 )); then
      printf "├──$kind/$name\n"
      next_pattern="${pattern}0"
    else
      printf "└──$kind/$name\n"
      next_pattern="${pattern}1"
    fi

    do-get-by-owner-ref $next_pattern $kind/$name ${@:3}
  done
}
