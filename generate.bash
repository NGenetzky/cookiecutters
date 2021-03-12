#!/bin/bash
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Bash Strict Mode
    set -eu -o pipefail
    IFS=$'\n\t'
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TEMPLATE='cookiecutter-ansible-playbook'
readonly \
    SCRIPT_DIR \
    TEMPLATE

main(){
    cd "${SCRIPT_DIR}"

    cookiecutter --verbose --no-input \
        --debug-file "debug.log" \
        --config-file "cookiecutter.yml" \
        --output-dir "templates" \
        "${TEMPLATE}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
