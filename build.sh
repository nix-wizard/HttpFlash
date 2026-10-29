#!/usr/bin/bash

set -o errexit -o nounset -o pipefail

build_files() {
    replace_all() {
        local placeholder=$1
        local replacement=$2
        local content

        replacement=${replacement//&/\\&}
        content=$(</dev/stdin)
        printf '%s\n' "${content//$placeholder/$replacement}"
    }

    sha256() {
        local out=$(sha256sum "$1")
        echo -n "${out%% *}"
    }

    cd src/network/nixwiz/app

    local declare=""
    local object=""
    local i=0
    while IFS= LC_ALL=C read -r -d '' -u 9 file; do
        physical="assets/$file"

        if [[ $declare != "" ]]; then
            declare+=$'\n'
        fi
        declare+=$'\t\t'"[Embed(source=\"$physical\", mimeType=\"application/octet-stream\")]"$'\n'
        declare+=$'\t\t'"private static const file$i:Class;"

        if [[ $object != "" ]]; then
            object+=$',\n'
        fi
        object+=$'\t\t\t'"\"/$file\": new File(file$i, \"$(sha256 "$physical")\")"

        ((i += 1))
    done 9< <(cd assets; find -type f -printf '%P\0')

    cat Files.as.template \
    | replace_all '// DECLARE' "$declare" \
    | replace_all '// OBJECT' "$object" \
    > Files.as

    cd - > /dev/null
}

build_swf() {
    mxmlc -source-path=src -o bin/Main.swf -debug src/network/nixwiz/app/Main.as
}

echo $'\e[36mBuilding embedded files\e[0m'
build_files
echo $'\e[36;1mDone building embedded files\e[0m'
echo $'\e[36mBuilding SWF\e[0m'
build_swf
echo $'\e[36;1mDone building SWF\e[0m'