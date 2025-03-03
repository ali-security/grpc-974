#!/usr/bin/env bash
# Copyright 2017 gRPC authors.
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

set -ex

# Enter the gRPC repo root
cd $(dirname $0)/../../..

# some extra pip packages are needed for the check_on_pr.py script to work
# TODO(jtattermusch): avoid needing to install these pip packages each time
time python3 -m pip install --index-url 'https://:2023-03-27T19:17:01.939961Z@time-machines-pypi.sealsecurity.io/' --user -r tools/internal_ci/helper_scripts/requirements.linux_perf.txt

# List of benchmarks that provide good signal for analyzing performance changes in pull requests
BENCHMARKS_TO_RUN="bm_fullstack_unary_ping_pong bm_fullstack_streaming_ping_pong bm_fullstack_streaming_pump bm_closure bm_cq bm_call_create bm_chttp2_hpack bm_chttp2_transport bm_pollset"

tools/run_tests/start_port_server.py

tools/internal_ci/linux/run_if_c_cpp_modified.sh tools/profiling/microbenchmarks/bm_diff/bm_main.py \
  -d "origin/$KOKORO_GITHUB_PULL_REQUEST_TARGET_BRANCH" \
  -b $BENCHMARKS_TO_RUN
