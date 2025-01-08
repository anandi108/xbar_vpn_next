#!/usr/bin/env bash


main() {
    if [[ "$1" =~ ^-r|--raw$ ]]; then
        shift
        for file in "$@"; do
            img2str "$file" && echo
        done
        return $?
    fi

    if [ ${#@} -lt 1 ]; then
        local basedir="$(readlink -f "$BASH_SOURCE" | xargs dirname)"
        img2var "$basedir/icons/"*
    else
        img2var "$@"
    fi
}

img2str() {
    local file="${1}"
    if [ ! -f "$file" ]; then
        return 1
    fi
    base64 "$file" | tr -d '\n'
}

img2var() {
    local files=( "$@" )

    local file=''
    for file in "${files[@]}"; do
        if [ ! -f "$file" ]; then
            continue
        fi
        local name="$(basename ${file%.*})"
        echo -n "IMG_${name//-/_}='" | tr '[:lower:]' '[:upper:]'
        img2str "$file"
        echo -e "'\n"
    done
}

main "$@"
