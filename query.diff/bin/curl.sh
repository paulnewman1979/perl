#!/bin/sh

server=localhost
port=4080
version=1
debug="-v"
proto=1

# See http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts "s:p:v:a:H:hq" opt; do
    case $opt in
        s) server="$OPTARG" ;;
        p) port="$OPTARG" ;;
        v) version="$OPTARG" ;;
        a) append="$OPTARG" ;;
        H) header="$OPTARG" ;;
        q) debug="-s" ;;
        2) proto=2 ;;
        *) echo "Usage: $0 [-s hostname] [-p port] [-v version] [-a parameters] [-q] curl_arguments..." >&2
           exit 1 ;;
    esac
done

shift `expr $OPTIND - 1`

url="http://$server:$port/?version=$version"

[ -n "$append" ] && url="$url&$append"
echo "# URL: $url" >&2
echo "# CURL arguments: -d" "\$REPLY" $debug "$url" "$@" >&2

while read -r; do
    curl -H "$header" -d "$REPLY" $debug "$url"
    echo
done

