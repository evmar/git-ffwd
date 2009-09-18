#!/bin/bash

set -e

. ./test-lib.sh

setup

(
  set -e
  cd testrepo

  git checkout -q -b test
  echo "some work done on a branch" >> file2
  git add file2; git commit -q -m "branch work"
  echo "some other work done on a branch" >> file2
  git add file2; git commit -q -m "branch work"

  git checkout -q master
  echo "master work" >> file
  git add file; git commit -q -m "master work"

  test_expect_success "master has new 'upstream' stuff" \
    "git rev-list test..master | grep -q ."

  test_expect_success "ffwding test branch" \
    "$GIT_FFWD test"

  test_expect_success "master now has no new 'upstream' stuff" \
    'nr=$(git rev-list test..master | wc -l); test $nr = 0'
)
SUCCESS=$?

if [ $SUCCESS == 0 ]; then
  echo PASS
fi
