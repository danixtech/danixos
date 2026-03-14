#!/usr/bin/env bash
# ======================================================
# DanixOS :: System Summary
# ======================================================
# DANIX_DESC: Displays quick hardware summary
# DANIX_MENU: false
# ======================================================

set -euo pipefail

HOST=$(hostname)

CPU=$(lscpu | awk -F: '/Model name/ {print $2}' | xargs)

CORES=$(nproc)

RAM=$(free -h | awk '/Mem:/ {print $2}')

DISKS=$(lsblk -d -o NAME | grep -v NAME | wc -l)

printf "\n"
printf "System Summary\n"
printf "--------------\n"
printf " Hostname : %s\n" "$HOST"
printf " CPU      : %s\n" "$CPU"
printf " Cores    : %s\n" "$CORES"
printf " Memory   : %s\n" "$RAM"
printf " Disks    : %s detected\n" "$DISKS"
printf "\n"

#
# vim: set syntax=bash
#
