# host-man

A small CLI for managing bracketed blocks of entries in `/etc/hosts`.

## What it does

`hostman` adds, removes, and lists blocks of `/etc/hosts` entries, each
bracketed by `# BEGIN <marker>` / `# END <marker>` comments. Since it writes
to `/etc/hosts`, it requires root privileges (typically via `sudo`).

It was originally factored out of [boundary-man](https://github.com/cerby-engineering/boundary-man),
which shells out to `sudo hostman` to manage `/etc/hosts` entries for its
Boundary-tunneled targets.

## Installation

### Via Homebrew (recommended)

```bash
brew tap cerby-engineering/tap
brew install host-man
```

This installs the `hostman` binary.

### From Source

Prerequisites: `gnu make` and `golang`

```bash
make link
```

## Usage

```bash
# Add a block of host entries (replaces any existing block with the same marker)
sudo hostman add my-marker '["127.0.0.1 foo.example.com","127.0.0.1 bar.example.com"]'

# List all marked blocks
hostman ls

# List blocks matching a glob, including their host entries
hostman ls -a 'my-*'

# Remove a block
sudo hostman rm my-marker
```

## Passwordless sudo

To avoid password prompts on every `sudo hostman` invocation (subject to the
usual sudo ticket timeout), add the following to your sudoers file (run
`sudo visudo`):

```
%admin ALL=(root) NOPASSWD: /opt/homebrew/bin/hostman
```

Adjust the path to wherever `hostman` is installed (e.g. `~/.bin/hostman` if
installed via `make link`).
