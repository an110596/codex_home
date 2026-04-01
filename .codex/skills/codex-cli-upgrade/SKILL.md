---
name: codex-cli-upgrade
description: Step-by-step playbook for upgrading Codex CLI on developer workstations.
---

## Additional upgrade steps
1. Use `curl -s https://api.github.com/repos/openai/codex/releases/latest` to identify the latest stable tag (read `tag_name`, example: `rust-v0.98.0`).
2. Export an environment variable for that release, e.g. `export version=<latest-tag>`.
3. Create a temporary download directory with `tmpdir="$(mktemp -d)"`.
4. Download the compressed binary with `wget https://github.com/openai/codex/releases/download/$version/codex-x86_64-unknown-linux-musl.tar.gz -P "$tmpdir"`.
5. Extract the downloaded archive in `"$tmpdir"`.
6. Check the extracted binary's file size to ensure the download succeeded; if it is `0` bytes or otherwise suspicious, stop and ask the user how to proceed.
7. The extracted binary has a long filename—rename it to `codex` for consistency.
8. Move the renamed `codex` binary into `~/.local/bin/` so it is available on the PATH.
9. Verify the install with `codex --version`.
10. If `codex` warns about PATH not updating, ensure `~/.local/bin` is on PATH and restart the shell.
11. If `codex` warns about temp permissions (e.g., under `~/.codex/tmp`), inspect and fix ownership/permissions before retrying.
12. Clean up the temporary directory with `rm -rf "$tmpdir"`.
