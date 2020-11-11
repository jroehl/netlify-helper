#!/usr/bin/env bash

# Script creates or updates standard site snippets passed as array
# https://open-api.netlify.com/#tag/snippet

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

  result="$(netlify api listSiteSnippets --data "{ \"site_id\": \"${site_id}\" }")"

  for row in $(echo "${data}" | jq -r '.[] | @base64'); do
    _jq() {
      echo ${row} | base64 --decode | jq -r "${@}"
    }
    local title=$(_jq '.title')

    local snippet_id="$(echo ${result} | jq --arg title "${title}" '.[] | select(.title == $title) | .id')"

    if [[ "${snippet_id}" != "" && ! -z ${upsert+x} ]]; then
      local method="updateSiteSnippet"
      local payload=$(
        _jq -a --arg snippet_id "${snippet_id}" --arg site_id "${site_id}" \
          '. | { site_id: $site_id, snippet_id: $snippet_id, body: . }'
      )
    else
      local method="createSiteSnippet"
      local payload=$(
        _jq -a --arg site_id ${site_id} \
          '. | { site_id: $site_id, body: . }'
      )
    fi

    echo "\"${site_id}\" -> ${dry_run}\"${method}\" - \"${title}\" ${upsert}"
    if [ ! -z ${dry_run+x} ]; then
      echo ${payload} | jq
    else
      netlify api ${method} --data "${payload}" | jq
    fi
    echo
  done
}

main "$@"
