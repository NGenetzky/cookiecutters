#!/bin/sh
# lint-python.sh - Lint Python source files with flake8.
#
# Usage:
#   lint-python.sh [FILE_OR_DIR ...]
#
# If one or more FILE_OR_DIR arguments are given, only those paths are
# linted. Otherwise, every Python file tracked by git is discovered
# automatically. Cookiecutter template placeholder directories (whose
# path contains a Jinja2 expression such as
# "{{cookiecutter.project_slug}}") are always skipped, since they hold
# template source rather than valid standalone Python.
#
# This script does not hardcode any repository-specific paths, so it can
# be reused as-is in other repositories.
#
# Requires flake8 to be installed and available on PATH.

set -eu

if [ "$#" -gt 0 ]; then
    exec flake8 "$@"
fi

set --
while IFS= read -r file; do
    [ -n "$file" ] || continue
    case "$file" in
        *'{{'*) continue ;;
    esac
    set -- "$@" "$file"
done <<EOF
$(git ls-files -- '*.py')
EOF

if [ "$#" -eq 0 ]; then
    echo "lint-python.sh: no Python files found to lint" >&2
    exit 0
fi

exec flake8 "$@"
