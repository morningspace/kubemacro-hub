##
# @Name: get-apires-name-dup
# @Description: Get all API resources with names duplicated.
#
# Get all API resources with names duplicated
#
# @Usage: kubectl macro get-apires-name-dup [options]
# @Options:
# @Examples:
# @Dependencies: sort,head,awk,uniq,grep
##
function get-apires-name-dup {
  local line
  local lines="$(kubectl api-resources 2>/dev/null | sort -k1,1)"
  local headline=$(echo "$lines" | head -n 1)
  local dup_lines="$(echo "$lines" | awk {'print $1'} | uniq -c | grep -v '1 ')"
  local dup_apires_index=0
  while IFS= read -r line; do
    local parts=(${line})
    local dup_apires_num=${parts[0]}
    local dup_apires_name=${parts[1]}
    echo "$dup_apires_index) $dup_apires_num $dup_apires_name found:"
    echo "$headline"
    echo "$lines" | grep "^${parts[1]}"
    echo
    (( dup_apires_index++ ))
  done <<< "$dup_lines"
  echo "$dup_apires_index duplicated API resource(s) found in total."
}
