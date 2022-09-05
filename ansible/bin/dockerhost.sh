#!/usr/bin/env bash

optstring="f"

f=0

while getopts ${optstring} arg; do
  case "${arg}" in
    f)
      f=1
      ;;
  esac
done

if [ $f -eq 1 ]; then
  ansible-playbook playbooks/dockerhost.yaml -K --extra-vars "dockerhost_full=yes"
else
  ansible-playbook playbooks/dockerhost.yaml
fi
