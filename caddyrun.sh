#!/bin/bash
set -o nounset
set -e


function die { echo "$1"; exit 1 ; }

function showhelp {
   cat <<EOF >&2

caddy

Run reverse proxy.
Environment variables needed:
   EMAIL
   SERVICE_HOST
   SERVICE_PORT
   MODE
   

MODE can be staging or production

EOF
}


[[ -v EMAIL ]] || { showhelp ; die "Missing EMAIL." ; }
[[ -v SERVICE_HOST ]] || { showhelp ; die "Missing SERVICE_HOST." ; }
[[ -v SERVICE_PORT ]] || { showhelp ; die "Missing SERVICE_PORT." ; }
[[ -v MODE ]] || { showhelp ; die "Missing MODE." ; }



#log stdout
#errors stdout
echo "Wheee!"





