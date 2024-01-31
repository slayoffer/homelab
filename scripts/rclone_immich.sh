#!/bin/bash
rclone rc sync/copy srcFs=/data/immich dstFs=yandex:rclone/immich --rc-addr=:5572 --rc-user=user --rc-pass=rclone
