#!/bin/bash
set -e

echo "🚀 Starting Rclone Upload..."

if [ -n "$PLUGIN_FLAGS" ]; then
	echo "ℹ️  Additional flags detected: $PLUGIN_FLAGS"
fi

# 1. Rclone needs the password to be "obscured" (a weak encryption format it uses)
# We generate this on the fly so you can keep using your plain text env var.
OBSCURED_PASS=$(rclone obscure "$PLUGIN_PASSWORD")

# 2. Run the copy command
# :webdav: tells rclone to use the WebDAV protocol on the fly (no config file needed)
rclone copy "$PLUGIN_SOURCE" :webdav:"$PLUGIN_TARGET" \
	--webdav-url="$PLUGIN_URL" \
	--webdav-user="$PLUGIN_USERNAME" \
	--webdav-pass="$OBSCURED_PASS" \
	--webdav-vendor="other" \
	--progress \
	$PLUGIN_FLAGS

echo "✅ Upload complete!"
