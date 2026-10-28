#!/usr/bin/bash

set -o errexit -o nounset -o pipefail

mxmlc -o bin/Main.swf -debug src/Main.as

(cd proxy; npm start | ts "%.T") &
pid=$!
sleep 1
RUST_LOG='avm_trace=info' ruffle bin/Main.swf --tcp-connections allow
wait "$pid"