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
  ansible-playbook ./ansible/playbooks/time_machine.yaml -K --extra-vars "time_machine_full=yes"
else
  ansible-playbook ./ansible/playbooks/time_machine.yaml
fi
