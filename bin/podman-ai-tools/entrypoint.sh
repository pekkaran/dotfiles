#!/bin/sh
# Puts the sandbox docs in the /home/node/ starting folder so that the agent
# hopefully realizes to take a look.

cp -f /opt/sandbox/README.md /opt/sandbox/Containerfile "${HOME:-/home/node}/" 2>/dev/null || true

exec "$@"
