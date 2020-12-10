#!/bin/sh
set -e

wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /tmp/ v0.11.0

if [ -n "${GITHUB_WORKSPACE}" ] ; then
    cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1
fi

if [ -z "${INPUT_COMMAND}" ]; then
    echo "No command specified"
    exit 1
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

ARGS="-name=\"linter-name (misspell)\" \\
      -reporter=\"${INPUT_REPORTER:-github-pr-check}\" \\
      -filter-mode=\"${INPUT_FILTER_MODE}\" \\
      -fail-on-error=\"${INPUT_FAIL_ON_ERROR}\" \\
      -level=\"${INPUT_LEVEL}\" \\
      ${INPUT_REVIEWDOG_FLAGS}"

if [ "$INPUT_FORMAT" ]; then
    ARGS="$ARGS -f=\"${INPUT_FORMAT}\""    
elif [ "$INPUT_ERRORFORMAT" ]; then
    ARGS="$ARGS -efm=\"${INPUT_ERRORFORMAT}\""
fi

if [ "$INPUT_NAME" ]; then
    ARGS="$ARGS -name=\"${INPUT_NAME}\""    
fi

sh -c "${INPUT_COMMAND} | /tmp/reviewdog ${ARGS}"
