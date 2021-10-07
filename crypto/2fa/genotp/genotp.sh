#!/bin/bash
#
##
###
### generate one time password
### thank reis
###
##
#

# usage: genotp.sh -m totp -a <hash> -d <digits> -p <period> -c 0 -s <key>
# with:
# hash: sha1, sha256 or sha512
# digits: number of output digits (effective 1-10 or more with leading zeroes)
# period: default 30s
# key: base32 encoded input string or file containing string
#secret_file="$HOME/_git/private/vault/totp.key"


parse_datetime() {
  # parse_datetime <datetime>
  # - datetime: unix epoch or iso-8601 formatted string

  local dt_str="$1"
  local dt

  # try to parse epoch
  dt=$(date +%s --date="@$dt_str" 2>/dev/null)

  if [[ $? == 0 ]]; then
    printf "$dt"
    return 0
  fi

  # try to parse iso
  dt=$(date +%s --date="$dt_str" 2>/dev/null)

  if [[ $? == 0 ]]; then
    printf "$dt"
    return 0
  fi

  return 1

}


parse_secret() {
  # parse_secret <secret>
  # - secret: base32 encoded;
  #           may contain spaces;
  #           may use lowercase letters

  local secret="$@"

  echo -n "${secret}" \
    | tr a-z A-Z \
    | sed -e 's/ //g' \
    | base32 -d \
    | hexdump -ve '/1 "%02X"'

}


hmac() {
  # hmac <key> <msg> [alg]
  # - key: hex encoded key
  # - msg: must be hex encoded
  #        -> on bash, it's not possible to save
  #           strings that have \0 on variables,
  #           but it passes them through pipes;
  #           so, in order to pass to openssl a
  #           msg that has the \0 character, the
  #           conversion must be done here
  # - alg: defaults to sha1, can also be sha256 or sha512

  local key="$1"
  local msg="$2"
  local alg="${3:-sha1}"

  # initial sed transforms the hex encoded message into a series of \x??\x??...
  # the outer printf transforms that in the actual byte sequence
  # final sed removes '(stdin)= ' from the output
  printf "$(printf "$msg" | sed -e 's/\(..\)/\\x\1/g')" \
    | openssl dgst \
    -${alg} \
    -mac HMAC \
    -macopt "hexkey:$key" \
    | sed -e 's/^.* //'

}


dynamic_truncate() {
  # dynamic_truncate <hex_str> <digits>
  # truncates the hex string as per RFC4225, DynamicTruncate
  ## get last 4 bits from hmac hash ($hex_str)
  ## get the integer number (0-f > 1-10) of those bits; this is the offset
  ## starting from the offset get the first 4 bytes from the hmac hash ($hex_str)

  local hex_str="$1"
  local digits="$2"

  local offset=$((2 * 0x${hex_str: -1}))
  echo $(( ( (0x${hex_str:$offset:8}) & 0x7FFFFFFF) % (10**$digits) ))

}


hotp() {
  # hotp <key> <counter> [digits:6] [alg:sha1]
  # - key: hex encoded key
  # - counter: number

  local key=$1
  local counter=$2
  local digits=${3:-6}
  local alg=${4:-sha1}

  local cnt_hex_string=$(printf "%016X" "$counter")
  local digest=$(hmac "$key" "$cnt_hex_string" "$alg")
  local number=$(dynamic_truncate "$digest" "$digits")
  printf "%0${digits}d" "$number"

}


totp() {
  # totp <key> [datetime:now] [period:30] [digits:6] [alg:sha1]
  # - key: hex encoded key
  # - datetime: unix epoch (seconds)
  ## totp is hotp with: counter = epoch / timestep

  local key=$1
  local datetime="$2"
  local period=${3:-30}
  local digits=${4:-6}
  local alg=${5:-sha1}

  if [[ "$datetime" == "" ]]; then
    datetime=$(date +%s)
  fi

  local counter=$(($datetime / $period))

  hotp "$key" "$counter" "$digits" "$alg"

}


epoch_now() {
  # epoch_now

  date +%s

}


usage() {

  printf "generate one time password\n"
  printf "\n"
  printf "usage: ${0##*/} [options]\n"
  printf "\n"
  printf "general options:\n"
  printf "  -h, --help                    displays this help screen\n"
  printf "  -t, --time DATETIME           generate a code for the specified instance\n"
  printf "                                  default: the current timestamp\n"
  printf "\n"
  printf "OTP options:\n"
  printf "  -s, --secret SECRET           (required) secret key\n"
  printf "                                  constraints: the key must be base32 encoded, can contain\n"
  printf "                                  upper- and lower-case letters, numbers, spaces, and\n"
  printf "                                  base32 padding with '=' if necessary\n"
  printf "  -m, --mode MODE               selects operating mode\n"
  printf "                                  possible options: totp, hotp\n"
  printf "                                  default: totp\n"
  printf "  -a, --alg ALG                 selects hashing algorithm\n"
  printf "                                  possible options: sha1, sha256, sha512\n"
  printf "                                  default: sha1\n"
  printf "  -d, --digits DIGITS           selects the number of digits on displayed otp value\n"
  printf "                                  default: 6\n"
  printf "  -p, --period PERIOD           defines the period for TOTP mode\n"
  printf "                                  default: 30\n"
  printf "  -c, --counter COUNTER         counter for HOTP, required if HOTP\n"
  printf "  -u, --uri URI                 OTP uri spec, see below\n"
  printf "\n"
  printf "\n"
  printf "remarks:\n"
  printf "If --uri is specified, no other otp settigns are allowed. If both\n"
  printf "the URI and other otp settings are specified, the behavior is undefined\n"
  printf "and the application might generate invalid codes or crash.\n"
  printf "\n"
  printf "If the --time option is specificed, the format should be a Unix Epoch (seconds) or\n"
  printf "alternatively an ISO-8601 formatted timstamp. Examples:\n"
  printf "  --time 1136239445\n"
  printf "  --time \"2006-01-02T15:04:05-07:00\"\n"
  printf "\n"
  printf "If no options are specified, an input URI is read from STDIN.\n"
  printf "\n"

  exit ${1:-0}

}


debug_stdin() {

  ## check if we have all parameters from hmac script
  params="secret mode alg digits period dt_str counter from_hmac"

  for parameter in $params;
  do
	p_value=${!parameter}
  	[[ -z $p_value ]] && \
		printf "$parameter:		<empty>\n" || \
		printf "$parameter:		$p_value\n"
  done

}


help_quit() {

  printf "%s\ntry ${0##*/} --help\n" "$1"
  exit 1

}


main() {

  ## if no flags, then input is on stdin
  #if [[ $# -eq 0 ]]; then
  #  ## for debugging only!
  #  debug_stdin
  #fi

  ## otherwise, parse flags
  ## $# is total number of flag elements
  ## this way is an alternative to getopts
  ## after processing shift two flag elements

  while [[ $# -gt 0 ]]; do

    case "$1" in

      -s|--secret)
        secret=$2
	## if secret is a file, then read contents into secret
        [[ -f $secret ]] && secret=$(< $secret)
        shift 2
        ;;

      -m|--mode)
        mode=$2
        shift 2
        ;;

      -a|--alg)
        alg=$2
        shift 2
        ;;

      -d|--digits)
        digits=$2
        shift 2
        ;;

      -p|--period)
        period=$2
        shift 2
        ;;

      -t|--time)
        dt_str=$2
        shift 2
        ;;

      -c|--counter)
        counter=$2
        shift 2
        ;;

       -h|--help)
        usage
        ;;

      *)
        help_quit "unrecognized option: $1"
        ;;

    esac

  done


  # modify datetime

  if [[ $dt_str == "" ]]; then

    datetime=$(date +%s)

  else

    datetime=$(parse_datetime "$dt_str")

    if [[ $? != 0 ]]; then

      help_quit "invalid datetime specification: $dt_str"

    fi

  fi


  # modify secret

  ## if secret is a file, then read contents into secret
  [[ -f $secret ]] && secret=$(<$secret)


  # use flags to generate otp
  local key
  # local code  ## to be able to export to hmac5,
  ## code is not set local but probably not secure!

  key=$(parse_secret "$secret")

  case "$mode" in

    hotp)
      code=$(hotp "$key" "$counter" "$digits" "$alg")
      ;;

    totp)
      code=$(totp "$key" "$datetime" "$period" "$digits" "$alg")
      ;;

    *)
      help_quit "unknown mode: $mode"
      ;;

  esac

  # output code
  if [[ -z $from_hmac ]]; then

    printf "$code" | wl-copy -o
    printf "%s\n" "$code" | sed 's/.\{4\}/& /g'

  #else

   # local code

  fi

  #exit 0
  return 0

  help_quit "unknown error"

}


main "$@"


# vim: ft=sh
