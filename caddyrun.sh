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
   CERT_HOST
   SERVICE_HOST
   SERVICE_PORT
   MODE
   

MODE can be fake, staging, production
fake = self signed, don't use letsencrypt
staging = letsencrypt staging
production = letsencrypt production
EOF
}

[[ -n "$CERT_HOST" ]] || { showhelp ; die "Missing CERT_HOST." ; }
[[ -n "$SERVICE_HOST" ]] || { showhelp ; die "Missing SERVICE_HOST." ; }
[[ -n "$SERVICE_PORT" ]] || { showhelp ; die "Missing SERVICE_PORT." ; }
[[ -n "$MODE" ]] || { MODE="fake" ; }

# write out Caddy file.

case "${MODE}" in

# --------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------
   "fake")
cat <<EOF >/etc/Caddyfile

${CERT_HOST}:443 {
   proxy / http://${SERVICE_HOST}:${SERVICE_PORT} {
		transparent
		header_upstream Host {host}
		header_upstream X-Real-IP {remote}
		header_upstream X-Forwarded-For {host}
		header_upstream X-Forwarded-Proto {scheme}
   }
   gzip
   tls self_signed
}

EOF

   cat /etc/Caddyfile

   caddy -quic --conf /etc/Caddyfile
   ;;

# --------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------
   "staging")
[[ -n "$EMAIL" ]] || { showhelp ; die "Missing EMAIL." ; }

cat <<EOF >/etc/Caddyfile

${CERT_HOST}:443 {
   proxy / http://${SERVICE_HOST}:${SERVICE_PORT} {
		transparent
		header_upstream Host {host}
		header_upstream X-Real-IP {remote}
		header_upstream X-Forwarded-For {host}
		header_upstream X-Forwarded-Proto {scheme}
   }
   gzip
   tls ${EMAIL}
}

EOF

   cat /etc/Caddyfile

   caddy -quic --conf /etc/Caddyfile -ca "https://acme-staging.api.letsencrypt.org/directory"
   ;;


# --------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------
   "production")
[[ -n "$EMAIL" ]] || { showhelp ; die "Missing EMAIL." ; }

cat <<EOF >/etc/Caddyfile

${CERT_HOST}:443 {
   proxy / http://${SERVICE_HOST}:${SERVICE_PORT} {
		transparent
		header_upstream Host {host}
		header_upstream X-Real-IP {remote}
		header_upstream X-Forwarded-For {host}
		header_upstream X-Forwarded-Proto {scheme}
   }
   gzip
   tls ${EMAIL}
}

EOF

   cat /etc/Caddyfile

   caddy -quic --conf /etc/Caddyfile
   ;;
   
# -----------------------------------------------
# --------------------------------------------------------------------------------------------

         *)
            showhelp
            die "Unrecognised mode ${MODE}"
            ;;
   esac





