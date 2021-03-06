#!/usr/bin/env bash

# Copyright 2018 The Jetstack contributors.
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

set -o errexit
set -o nounset
set -o pipefail

BUILD_DIR="${1:-}"
if [ -z "${BUILD_DIR}" ]; then
    echo "Invalid usage. Use as $0 path/to/build/dir [additional arguments]"
    exit 1
fi
shift

WORKSPACE="$(bazel info workspace)"

echo "Activating service account..."
gcloud auth activate-service-account --key-file="${GOOGLE_APPLICATION_CREDENTIALS}"

echo "Generating docker credentials..."
gcloud auth configure-docker --quiet

echo "Executing builder..."
bazel run \
    //images/builder -- \
    --build-dir "${WORKSPACE}"/"${BUILD_DIR}" "$@"

echo "Build complete!"
