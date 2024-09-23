#!/bin/bash
# set -x
set -e

# SIGTERM-handler
term_handler() {
  echo "SIGTERM-handler"
  exit 143; # 128 + 15 -- SIGTERM
}

trap term_handler SIGTERM

while true; do 
  # If you don't have sleep infinity, use following:
  #   tail -f /dev/null & wait ${!}
  sleep infinity & wait ${!}
done
