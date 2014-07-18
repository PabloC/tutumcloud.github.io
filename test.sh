#!/bin/sh
set -e
test ! -d docs || { echo "docs folder found!" && exit 1; }
test -f index.html || { echo "index.html not found!" && exit 1; }
echo "OK"