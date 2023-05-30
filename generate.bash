#!/bin/bash
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Bash Strict Mode
    set -eu -o pipefail
    IFS=$'\n\t'
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly \
    SCRIPT_DIR

main(){
    cd "${SCRIPT_DIR}"
    TEMPLATE="$1"

    cookiecutter --verbose --no-input \
        --config-file "cookiecutter.yml" \
        --debug-file "build/debug.log" \
        --output-dir "build/${TEMPLATE}" \
        "${TEMPLATE}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
