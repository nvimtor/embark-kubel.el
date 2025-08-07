#!/bin/bash

if [ "${CODESPACES}" = true ]; then
  sudo setfacl --remove-default /tmp
fi

if [ $# -eq 0 ]; then
  while :; do sleep 2073600; done
else
  "$@" &
fi

wait -n
