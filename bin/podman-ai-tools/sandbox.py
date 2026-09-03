#!/usr/bin/env python3
"""Run an AI coding agent (claude, opencode, ...) in a minimal podman sandbox.

The current working directory is mounted read-write at /work. The container
home lives in the named volume "agent-sandbox-home" so agent logins/settings
persist across runs (log in interactively once inside each agent).

The shell starts in /home/node, where a README.md and a copy of the
Containerfile explain the layout and point on to /work.

Extra directories can be mounted with -v. A bare path is mounted at the same
path inside the sandbox; otherwise podman's host:container[:opts] syntax
applies. The container path must be absolute.

Ports are published with -p, using podman's syntax. A bare port number is
published on the same port on the host, bound to localhost.

Usage:
    cd path/to/my-project
    sandbox.py                              # plain bash in the sandbox
    sandbox.py claude
    sandbox.py opencode
    sandbox.py --build                      # rebuild the image and exit
                                            # (picks up Containerfile changes)
    sandbox.py --fresh                      # rebuild from scratch and exit
                                            # (picks up latest package versions)
    sandbox.py -v ~/notes claude            # also at /home/toki/notes inside
    sandbox.py -v ~/notes:/notes:ro claude  # ... at /notes, read-only
    sandbox.py -p 8000 claude               # 127.0.0.1:8000 -> container 8000
    sandbox.py -p 3000:80 claude            # 127.0.0.1:3000 -> container 80
    sandbox.py -p 0.0.0.0:8000:8000 claude  # ... reachable from the network
"""
import argparse
import os
import subprocess
import sys
from pathlib import Path

IMAGE = "agent-sandbox"
# This is a "named volume" that becomes something like
#   `~/.local/share/containers/storage/volumes/agent-sandbox-home/`.
HOME_VOLUME = "agent-sandbox-home"
SCRIPT_DIR = Path(__file__).resolve().parent


def die(msg):
    print(f"!! {msg}", file=sys.stderr)
    sys.exit(1)


def parse_args():
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=__doc__,
    )
    parser.add_argument("--build", action="store_true",
                        help="rebuild the image and exit")
    parser.add_argument("--fresh", action="store_true",
                        help="rebuild the image from scratch (no cache, pull "
                             "latest base) and exit")
    parser.add_argument("-v", "--volume", action="append", default=[], metavar="MOUNT",
                        help="extra mount: a host path, or podman's "
                             "host:container[:opts] syntax; repeatable")
    parser.add_argument("-p", "--publish", action="append", default=[], metavar="PORT",
                        help="publish a port: a bare port number (bound to "
                             "localhost), or podman's [host:]hostport:ctrport "
                             "syntax; repeatable")
    parser.add_argument("command", nargs=argparse.REMAINDER,
                        help="command to run in the sandbox (default: bash)")
    return parser.parse_args()


def unshared_fuse_mount(path):
    """The fuse.* filesystem `path` sits on, if it lacks allow_other."""
    best = ("", "", "")
    for line in Path("/proc/self/mountinfo").read_text().splitlines():
        fields = line.split()
        dash = fields.index("-")
        point, fstype, super_opts = fields[4], fields[dash + 1], fields[dash + 3]
        if (path == Path(point) or Path(point) in path.parents) \
                and len(point) > len(best[0]):
            best = (point, fstype, super_opts)
    return best[1] if best[1].startswith("fuse") \
        and "allow_other" not in best[2].split(",") else None


def mount_arg(spec):
    """Turn a mount spec into the value of a podman -v flag."""
    host, _, rest = spec.partition(":")
    host_path = Path(host).expanduser()
    if not host_path.exists():
        die(f"Nothing to mount at {host_path} — check the -v argument {spec!r}.")
    host_path = host_path.resolve()
    # Without allow_other, a fuse mount is invisible to every uid but yours,
    # including the sandbox's namespace root — which is the uid that has to
    # create the mountpoint. Podman then dies with an opaque conmon/OCI error.
    fuse = unshared_fuse_mount(host_path)
    if fuse:
        print(f">> Note: {host_path} is on a {fuse} mount without allow_other.\n"
              f"   If podman fails to create the container, uncomment "
              f"user_allow_other in /etc/fuse.conf\n"
              f"   and remount it with -o allow_other.", file=sys.stderr)
    if not rest:
        return f"{host_path}:{host_path}"
    if not rest.startswith("/"):
        die(f"Container path must be absolute in -v {spec!r} "
            f"(use {host}:/somewhere, or just {host} to mirror the host path).")
    return f"{host_path}:{rest}"


def publish_arg(spec):
    """Turn a port spec into the value of a podman -p flag."""
    # Podman's own default for a bare "8000" is 0.0.0.0 — exposing the sandbox
    # to the whole network. Ask for that explicitly instead.
    if spec.isdigit():
        return f"127.0.0.1:{spec}:{spec}"
    if not spec.partition("/")[0].rpartition(":")[2].isdigit():
        die(f"Malformed port in -p {spec!r} (use 8000, 3000:80, "
            f"or 0.0.0.0:8000:8000).")
    return spec


def ensure_image(build, fresh=False):
    if fresh or build or subprocess.run(["podman", "image", "exists", IMAGE]).returncode != 0:
        extra = ["--pull", "--no-cache"] if fresh else []
        print(f">> Building {IMAGE}{' from scratch' if fresh else ''} ...")
        subprocess.run(["podman", "build", *extra, "-t", IMAGE, str(SCRIPT_DIR)], check=True)


def main():
    args = parse_args()
    if args.build or args.fresh:
        flag = "--fresh" if args.fresh else "--build"
        if args.command:
            die(f"{flag} only rebuilds the image; do not pass a command.")
        ensure_image(args.build, args.fresh)
        return

    mounts = [arg for spec in args.volume for arg in ("-v", mount_arg(spec))]
    ports = [arg for spec in args.publish for arg in ("-p", publish_arg(spec))]
    if ports:
        print(">> Note: a server in the sandbox must listen on 0.0.0.0, not "
              "127.0.0.1,\n   or the published port will refuse connections.",
              file=sys.stderr)
    ensure_image(False)

    # keep-id:uid=1000 maps the host user onto the image's "node" user, so
    # files created under /work end up owned by you on the host.
    run = ["podman", "run", "--rm", "-it",
           "--userns=keep-id:uid=1000,gid=1000",
           "--user", "1000:1000",
           "-e", "HOME=/home/node",
           "-v", f"{HOME_VOLUME}:/home/node",
           "-v", f"{Path.cwd()}:/work",
           *mounts, *ports,
           IMAGE, *args.command]
    os.execvp(run[0], run)


if __name__ == "__main__":
    main()
