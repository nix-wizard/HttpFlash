#!/usr/bin/bash

set -o errexit -o nounset -o pipefail

replace_all() {
	local placeholder=$1
	local replacement=$2
	local content

	replacement=${replacement//&/\\&}
	content=$(</dev/stdin)
	printf '%s\n' "${content//$placeholder/$replacement}"
}

declare=""
object=""
i=0
while IFS= LC_ALL=C read -r -d '' -u 9 file
do
	file="${file:27}"

	if [[ $declare != "" ]]; then
		declare="$declare"$'\n'
	fi
	declare="$declare[Embed(source=\"assets/${file}\", mimeType=\"application/octet-stream\")] private static const File$i:Class;"
	if [[ $object != "" ]]; then
		object="$object,"$'\n'
	fi
	object="$object\"$file\": new File$i() as ByteArray"
	((i=i+1))
done 9< <( find ./src/network/nixwiz/assets -type f -print0 )

template="$(<"./src/network/nixwiz/Files.as.template")"
data="$(replace_all '// DECLARE' "$declare" <<<"$template" | \
	replace_all '// OBJECT' "$object")"

printf '%s\n' "$data" > ./src/network/nixwiz/Files.as

mxmlc -source-path=src -o bin/Main.swf -debug src/network/nixwiz/Main.as

(cd proxy; npm start | ts "%.T") &
pid=$!
sleep 1
RUST_LOG='avm_trace=info' ruffle bin/Main.swf --tcp-connections allow
wait "$pid"