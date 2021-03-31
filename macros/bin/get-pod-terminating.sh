##
# @Name: get-pod-terminating
# @Description: Get all pods that are terminating.
#
# Get all pods that are terminating.
#
# @Usage: kubectl macro get-pod-terminating [options]
# @Options:
# @Examples:
#   # Get all pods that are terminating in default namespace.
#   kubectl macro get-pod-terminating -n default
#   # Get all pods that are terminating in all namespaces.
#   kubectl macro get-pod-terminating -gt 1000 -A
#   # Get all pods that are terminating with output format specified.
#   kubectl macro get-pod-terminating -o json
#   kubectl macro get-pod-terminating -A -o name
#   kubectl macro get-pod-terminating -A --no-headers
#   # Get all pods that match specified labels and are terminating.
#   kubectl macro get-pod-terminating -l 'app=echo'
# @Dependencies: get-pod-not-ready
##
function get-pod-terminating {
  test-pod-by-func $@ --func test-terminating
}

function test-terminating {
  [[ $4 == Terminating ]]
}
