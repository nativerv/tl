#!/bin/sh

set -u

TL_PRIMARY_TARGET_LANGUAGE="${TL_PRIMARY_TARGET_LANGUAGE:-"en"}"
TL_SECONDARY_TARGET_LANGUAGE="${TL_SECONDARY_TARGET_LANGUAGE:-"fr"}"

instance='https://translate.googleapis.com'
endpoint='translate_a/single'

print_usage() {
  printf -- "usage: %s [-dh] [-f FROM] [-t TO] TEXT\n" "$(basename "${0}")"
  printf -- " Translate TEXT from language FROM to language TO using Google Translate API\n"
  printf -- "Flags:\n"
  printf -- '  -f FROM    source language [DEFAULT: %s]\n' "auto"
  printf -- '  -t TO      target language [DEFAULT: %s]\n' "${TL_PRIMARY_TARGET_LANGUAGE}"
  printf -- '  -s         output a single translation  \n'
  printf -- '  -h         show this message and exit   \n'
  printf -- '  -d         enable debug mode (set -x)   \n'
  printf -- 'Environment variables:\n'
  printf -- ' TL_PRIMARY_TARGET_LANGUAGE    the default TO language.\n'
  printf -- ' TL_SECONDARY_TARGET_LANGUAGE  the default TO language if the FROM language is detected to be same as TL_PRIMARY_TARGET_LANGUAGE\n'
}

translate() {
  curl \
    --silent \
    --get \
    --request GET \
    --data-urlencode "client=gtx" \
    --data-urlencode "sl=${from}" \
    --data-urlencode "tl=${to}" \
    --data-urlencode "dt=t" \
    --data-urlencode "dt=bd" \
    --data-urlencode "dj=1" \
    --data-urlencode "q=${text}" \
    "${instance}/${endpoint}"
}

# Parse args
while getopts 'hdsf:t:' flag; do
  case "${flag}" in
    h) print_usage && exit 0 ;;
    f) from="${OPTARG}" ;;
    t) to="${OPTARG}" ;;
    d) set -x ;;
    s) single=true ;;
    *) print_usage && exit 1 ;;
  esac
done
shift $(( OPTIND - 1 ))

text="${*-"$(cat)"}"
from="${from:-"auto"}"
to="${to:-"${TL_PRIMARY_TARGET_LANGUAGE}"}"

# Make a request
response="$(translate)"

[ -n "${DEBUG-}" ] && printf '%s' "${response}" | jq .

# Guard for target language being same as detected 
# source language - switch to TL_SECONDARY_TARGET_LANGUAGE
response_src_lang="$(printf '%s' "${response}" | jq -r ".src")"
if [ "${response_src_lang}" = "${to}" ]; then
  to="${TL_SECONDARY_TARGET_LANGUAGE}"
  response="$(translate)"
fi

# Text => Join translated sentences and print
# Word => Join translation variants and print them as table

# Text case
if [ "$(printf '%s' "${response}" | jq -r '.dict')" = 'null' ] || [ "${single-}" = true ]; then
  printf '%s' "${response}" | jq -r '.sentences[]?.trans'

# Word case
else
  # Equivalent js code of the below (with my custom `njq` json processor, `this` containing the root object):
  # njq 'this.dict[0].entry.forEach(entry => { print(`${entry.word}\t${entry.reverse_translation.join(", ")}\n`); })' 2>/dev/null

  # Get all dict entries and print their word in table with comma-separated reverse translation variants
  printf '%s' "${response}" \
    | jq -r '.dict[] | .pos + "\t" + (.entry[] | (.word + "\t" + (.reverse_translation | join(","))))' \
    | column -W3 -t -s "$(printf '\t')"
fi
