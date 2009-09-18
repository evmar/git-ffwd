#!/bin/bash

set -e

PWD=`pwd`
GIT_FFWD=$PWD/../git-ffwd

setup() {
  rm -rf testrepo
  mkdir testrepo
  (
    cd testrepo
    git init -q
    echo "foo" > file
    git add file
    git commit -q -m "import"
  )
}

# Usage: test_expect_success "description of test" "test code".
test_expect_success() {
  echo "TESTING: $1"
  exit_code=0
  sh -c "$2" || exit_code=$?
  if [ $exit_code != 0 ]; then
    echo "FAILURE: $1"
    return $exit_code
  fi
}
