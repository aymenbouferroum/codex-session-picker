# Codex Session Picker (`codexr`)

Interactive picker to **resume OpenAI Codex CLI sessions** from your local
`~/.codex/sessions` history. Shows timestamp, line count, size, and full path.
Use arrow keys to select, press **Enter** to resume.

Works best with [`fzf`](https://github.com/junegunn/fzf). Falls back to a simple,
non-interactive mode if `fzf` is not installed.

## Demo

```
2025-09-06 16:02:37         3 lines       627 bytes  /home/abouferr/.codex/sessions/2025/09/06/rollout-2025-09-06T16-02-37-9a3e917e-8b51-4853-a7b3-df0f1846dcfc.jsonl
2025-09-06 15:59:55       290 lines    423603 bytes  /home/abouferr/.codex/sessions/2025/09/06/rollout-2025-09-06T15-06-14-a9e3b0fa-c4e0-44e1-bb8a-22c00b000d8c.jsonl
2025-09-06 15:04:57         3 lines       627 bytes  /home/abouferr/.codex/sessions/2025/09/06/rollout-2025-09-06T15-04-57-67f6336d-9014-4235-82b9-eda12d9b1d68.jsonl
```

## Requirements

- Bash (>=4)
- GNU `find`, `awk`, `wc`, and `date`
- OpenAI Codex CLI installed and configured
- Optional (recommended): [`fzf`](https://github.com/junegunn/fzf)

Install `fzf` on Debian/Ubuntu:
```bash
sudo apt update && sudo apt install -y fzf
```

## Installation

### Quick install
```bash
git clone https://github.com/<your-username>/codex-session-picker.git
cd codex-session-picker
./install.sh
# Restart your shell or:
source ~/.bashrc  # or ~/.zshrc
```

This adds a `codexr` function to your shell.

## Usage

Open the interactive picker:
```bash
codexr
```

- Use **↑ / ↓** to move, **Enter** to resume the selected session.
- In fallback mode (no `fzf`), the newest session is chosen automatically. Use:
  ```bash
  codexr 2   # resume the 2nd newest session
  codexr 5   # resume the 5th newest session
  ```

Under the hood, the tool runs:
```bash
codex -c experimental_resume="/full/path/to/rollout-....jsonl"
```

## Troubleshooting

- **No sessions found**  
  Ensure files exist under `~/.codex/sessions/**/rollout-*.jsonl`.

- **`date -d` not supported**  
  This script uses GNU `date`. On macOS, install coreutils (`brew install coreutils`)
  or use a GNU environment.

- **Want a different preview?**  
  Edit `codexr.sh` and change the `--preview` command (e.g., switch `tail` to `head`,
  or change the number of lines).

## Uninstall

Remove the sourced block from your `~/.bashrc` / `~/.zshrc`, then delete the repo.

## License

[MIT](./LICENSE)
