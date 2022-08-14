#!/bin/bash

inotifywait -qq -e close_write "${VPN_2FA_FILE}"
cat "${VPN_2FA_FILE}" | tr -d "\n"
