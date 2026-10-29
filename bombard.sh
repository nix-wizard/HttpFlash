#!/usr/bin/bash

# ./bombard.sh URL COUNT INTERVAL
# Send COUNT requests to URL, waiting INTERVAL seconds inbetween; print response times for each request
# Example: ./bombard.sh http://localhost:6767/html/index.html 200 0.01

set -o errexit -o nounset -o pipefail

for (( i = 0; i < $2; i++ )) do
    (
        start=$(date +%s%N)
        curl -s $1 > /dev/null
        end=$(date +%s%N)
        echo "$(( (end - start) / 1000000 ))"
    ) &
    sleep $3
done

for pid in $(jobs -p); do wait $pid; done