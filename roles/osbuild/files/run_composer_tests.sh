#!/bin/bash
set -euxo pipefail

/usr/libexec/tests/osbuild-composer/osbuild-tests | tee -a /tmp/composer_tests.log 2>&1 > /dev/null
