#!/bin/sh
# lint-markdown.sh - Lint Markdown documentation files with markdownlint-cli2.
#
# Usage:
#   lint-markdown.sh [FILE_OR_DIR_OR_GLOB ...]
#
# If one or more arguments are given, they are passed directly to
# markdownlint-cli2 as globs/paths, restricting the lint run to just those
# files or directories. Otherwise, every Markdown file tracked by git is
# discovered automatically. Cookiecutter template placeholder directories
# (whose path contains a Jinja2 expression such as
# "{{cookiecutter.project_slug}}") are always skipped.
#
# This script does not hardcode any repository-specific paths, so it can be
# reused as-is in other repositories.
#
# Requires Node.js (for npx) to be available on PATH. markdownlint-cli2
# itself is fetched on demand via npx.

set -eu

if [ "$#" -gt 0 ]; then
    exec npx --yes markdownlint-cli2 "$@"
fi

set --
while IFS= read -r file; do
    [ -n "$file" ] || continue
    case "$file" in
        *'{{'*) continue ;;
    esac
    set -- "$@" "$file"
done <<EOF
$(git ls-files -- '*.md')
EOF

if [ "$#" -eq 0 ]; then
    echo "lint-markdown.sh: no Markdown files found to lint" >&2
    exit 0
fi

exec npx --yes markdownlint-cli2 "$@"
