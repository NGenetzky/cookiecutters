#!/usr/bin/env bash
# test-python.bash - Run pytest across the Python project(s) in this repository.
#
# Usage:
#   test-python.bash [PYTEST_ARG ...]
#
# When arguments are given, they are passed straight through to pytest as
# targets/options, letting callers restrict the run to specific files or
# directories.
#
# When no arguments are given, every directory that contains a pytest
# configuration file (pytest.ini, tox.ini, setup.cfg or pyproject.toml) is
# treated as an independent Python project. Cookiecutter template
# placeholder directories (whose path contains a Jinja2 expression such as
# "{{cookiecutter.project_slug}}") are always skipped. For each discovered
# project, its requirements-dev.txt (if present) is installed and pytest is
# run from within that project's directory.
#
# This script does not hardcode any repository-specific paths, so it can be
# reused as-is in other repositories.
#
# Requires Python, pip, and pytest to be installed and available on PATH.

set -euo pipefail

mapfile -t config_files < <(
    git ls-files -- '*pytest.ini' '*tox.ini' '*setup.cfg' '*pyproject.toml' |
        grep -v '{{' || true
)

declare -A project_dirs=()
for config_file in "${config_files[@]:-}"; do
    [ -n "$config_file" ] || continue
    project_dirs["$(dirname "$config_file")"]=1
done

for project_dir in "${!project_dirs[@]}"; do
    if [ -f "$project_dir/requirements-dev.txt" ]; then
        echo "== Installing dependencies from $project_dir/requirements-dev.txt =="
        python -m pip install --upgrade -r "$project_dir/requirements-dev.txt"
    fi
done

if [ "$#" -gt 0 ]; then
    pytest "$@"
    exit $?
fi

if [ "${#project_dirs[@]}" -eq 0 ]; then
    echo "test-python.bash: no pytest configuration found" >&2
    exit 0
fi

status=0
for project_dir in "${!project_dirs[@]}"; do
    echo "== Testing $project_dir =="
    (cd "$project_dir" && pytest) || status=$?
done

exit "$status"
