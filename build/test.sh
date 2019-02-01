#!/bin/bash

# Copyright 2019 Cortex Labs, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. >/dev/null && pwd)"

function run_go_tests() {
  (cd $ROOT && GO111MODULE=on go test ./... && echo -e "\ngo vet..." && GO111MODULE=on go vet ./... && echo "go tests passed")
}

function run_python_tests() {
  docker build $ROOT -f $ROOT/images/test/Dockerfile -t cortexlabs/test
  docker run cortexlabs/test
}

CMD=${1:-""}

if [ "$CMD" = "go" ]; then
  run_go_tests
elif [ "$CMD" = "python" ]; then
  run_python_tests
else
  run_go_tests
  run_python_tests
fi