---
name: codex-cli-upgrade
description: Step-by-step playbook for upgrading Codex CLI on developer workstations.
---

## Additional upgrade steps
1. Use `curl https://github.com/openai/codex/releases` to identify the latest non-alpha version tag (example: `v0.80.0`).
2. Export an environment variable for that release, e.g. `export version=<latest-version>`.
3. Download the compressed binary with `wget https://github.com/openai/codex/releases/download/rust-$version/codex-x86_64-unknown-linux-musl.tar.gz -P ~/Downloads`.
4. Extract the downloaded archive in `~/Downloads`.
5. Check the extracted binary's file size to ensure the download succeeded; if it is `0` bytes or otherwise suspicious, stop and ask the user how to proceed.
6. The extracted binary has a long filename—rename it to `codex` for consistency.
7. Move the renamed `codex` binary into `~/.local/bin/` so it is available on the PATH.
