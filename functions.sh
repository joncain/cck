#!/bin/bash

print_error()
{
  echo "Error: $1"
  exit 1
}

ensure_date_arg()
{
  #
  # Ensure we have the import date arg
  #
  if [ "$1" = "" ]; then
   print_error "Missing argument - Pass the import date"
  fi
}

parse_import_date()
{
  #
  # Parse the import date
  #
  IMPORT_DATE=`(date "+%Y-%m-%d" --date="$1") 2> /dev/null`
}

get_tag()
{
  ffprobe ${1} 2>&1 | sed -E -n 's/^ *'$2' *: (.*)/\1/p' | tr -d '\n'
}
