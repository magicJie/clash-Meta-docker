#!/bin/sh

exec "$@"

if [ -n "SUBSCRIBE_URL" ]; then
  wget -qO $MIHOMO_CONFIG_DIRECTORY/config.yaml ${SUBSCRIBE_URL}
fi
/usr/local/bin/mihomo -d $MIHOMO_CONFIG_DIRECTORY