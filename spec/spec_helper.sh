# shellcheck shell=sh
set -eu

PROJECT_ROOT="$(git rev-parse --show-toplevel)"
export PROJECT_ROOT

# shellcheck source=../bash-mock/in-tempdir.shlib
. "${PROJECT_ROOT}/bash-mock/in-tempdir.shlib"

# shellcheck source=../bash-mock/mock-first-with-rest.shlib
. "${PROJECT_ROOT}/bash-mock/mock-first-with-rest.shlib"

spec_helper_precheck() {
  : minimum_version "0.28.1"
}