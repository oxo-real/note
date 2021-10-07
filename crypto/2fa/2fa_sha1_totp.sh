#!/bin/sh

sha="sha1"

TOTP_SECRET=$1
TOTP_INTERVAL=${2:-30}


get_input() {

  set -e

  ## redirect stdout to stderr
  exec 3>&1 1>&2

  export LC_ALL=C

  echo() {
    printf '%s\n' "$*"
  }

}


process_secret() {

  TOTP_SECRET=$(echo "${TOTP_SECRET}" | tr -d ' ')

}


process_interval() {

  if [ ! "${TOTP_INTERVAL}" -gt 0 ] 2>&-; then
    echo "interval is not a positive integer: ${TOTP_INTERVAL}"
    exit 4
  else
    # remove leading zeros
    TOTP_INTERVAL=$(echo "${TOTP_INTERVAL}" | sed 's/^00*//')
  fi

}


calculate_period() {

  TOTP_PERIOD=$(( ($(date +%s)) / TOTP_INTERVAL ))

}


hex_pack() {

  xxd -p | tr -cd 0-9A-Fa-f

}


hex_unpack() {

    xxd -r -p

}


calculate_digest() {

  #sha1-hmac: hexkey = 20bytes
  #sha256-hmac: hexkey = 20bytes
  #sha512-hmac: hexkey = 20bytes

  local hexkey=$1 period=$2

  printf %016X "${period}" | hex_unpack |

    openssl dgst -$sha -hmac "$(echo "${hexkey}" | hex_unpack)" |

    cut -d ' ' -f 2

}


calculate_token() {

  # totp https://tools.ietf.org/html/rfc6238

  local secret=$1 period=$2

  # base64/32/16 https://tools.ietf.org/html/rfc4648
  # base32 A-Z2-7
  local key=$(echo "${secret}" | base32 -d | hex_pack)
  [ -z "${key}" ] && exit 1

  ## digest is a 160-bit hexadecimal number string
  local digest=$(calculate_digest "${key}" "${period}" | tr -cd 0-9A-Fa-f)
  [ "${#digest}" -ne 40 ] && exit 2

  ## read last 4 bits and convert it into an unsigned integer
  local start=$(( (0x$(echo "${digest}" | cut -b 40)) * 2 + 1))
  [ "${start}" -gt 33 ] && exit 3

  ## read a 32-bit positive integer and take at most six rightmost digits
  local hexes=$(echo "${digest}" | cut -b "${start}-$(( start + 7 ))")
  local token=$(( ((0x${hexes}) & 0x7FFFFFFF) % 1000000 ))

  ## add leading zeros as padding to the token number, if needed
  printf '%06d\n' "${token}" >&3

}


get_input
process_secret
process_interval
calculate_period
calculate_token "${TOTP_SECRET}" "${TOTP_PERIOD}"
