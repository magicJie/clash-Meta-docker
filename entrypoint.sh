#!/bin/sh

exec "$@"

if ! test -d "$MIHOMO_CONFIG_DIRECTORY"; then
  mkdir -p $MIHOMO_CONFIG_DIRECTORY
fi
if [ -n "SUBSCRIBE_URL" ]; then
  wget -qO $MIHOMO_CONFIG_DIRECTORY/config.yaml ${SUBSCRIBE_URL}
fi
/usr/local/bin/mihomo -d $MIHOMO_CONFIG_DIRECTORY