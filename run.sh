#!/usr/bin/bash

set -o errexit -o nounset -o pipefail

echo '$ build.sh'
./build.sh

(cd proxy; npm start | ts "%.T") &
pid=$!
sleep 2
RUST_LOG='avm_trace=info' ruffle bin/Main.swf --tcp-connections allow
wait "$pid"