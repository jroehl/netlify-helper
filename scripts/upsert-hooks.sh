#!/usr/bin/env bash

# Script creates or updates hooks according to json specification file
# https://open-api.netlify.com/#tag/hook

# exit when any command fails
set -e

function main() {

  for i in "$@"; do
    case $i in
    -s=* | --site-id=*)
      site_id="${i#*=}"
      shift # past argument=value
      ;;
    -d=* | --data=*)
      data="${i#*=}"
      shift # past argument=value
      ;;
    --dry-run)
      dry_run="<dry-run> "
      shift # past argument with no value
      ;;
    -u | --upsert)
      upsert="(upsert)"
      shift # past argument with no value
      ;;
    *)
      # unknown option
      ;;
    esac
  done

  result="$(netlify api listHooksBySiteId --data "{ \"site_id\": \"${site_id}\" }")"

  for row in $(echo "${data}" | jq -r '.[] | @base64'); do
    _jq() {
      echo ${row} | base64 --decode | jq -r "${@}"
    }
    local event=$(_jq '.event')
    local type=$(_jq '.type')
    local url=$(_jq '.data.url')
    local email=$(_jq '.data.email')

    local hook_id="$(
      echo ${result} | jq -r --arg typ "${type}" --arg evt "${event}" --arg url "${url}" --arg email "${email}" \
        'first(.[] | select(.type == $typ and .event == $evt and (.data.url == $url or .data.email == $email)) | .id)'
    )"

    local body=$(
      _jq -a --arg site_id "${site_id}" '.site_id = $site_id'
    )
    if [[ "${hook_id}" != "" && ! -z ${upsert+x} ]]; then
      local method="updateHook"
      local payload=$(
        echo ${body} | jq -a --arg hook_id "${hook_id}" \
          '. | { hook_id: $hook_id, body: . }'
      )
    else
      local method="createHookBySiteId"
      local payload=$(
        echo ${body} | jq -a --arg site_id "${site_id}" \
          '. | { site_id: $site_id, body: . }'
      )
    fi

    echo "\"${site_id}\" -> ${dry_run}\"${method}\" - \"${type}:${event}\" ${upsert}"
    if [ ! -z ${dry_run+x} ]; then
      echo ${payload} | jq
    else
      netlify api ${method} --data "${payload}" | jq
    fi
    echo
  done
}

main "$@"
