#!/bin/bash
set -euxo pipefail

/usr/libexec/tests/osbuild-composer/osbuild-tests 2>&1 | tee /tmp/composer_tests.log >/dev/null
