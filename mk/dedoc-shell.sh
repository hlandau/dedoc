#!/usr/bin/env bash
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  echo >&2 "This script must be sourced into your shell. Type:"
  echo >&2 "  $ . ${BASH_SOURCE[0]}"
  exit 1
fi
export DEDOC_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/.."; pwd)"
alias dedoc="$DEDOC_PATH/bin/dedoc"
