# shellcheck shell=bash
# codexr: interactive Codex session picker + resume
# Lists ~/.codex/sessions/*/*/*/rollout-*.jsonl with timestamp, line count, bytes, and full path.
# If fzf is available: interactive picker with preview.
# Fallback: resume the Nth newest (default 1 = newest).

_codexr_list_sessions() {
  # Prints: "<YYYY-MM-DD HH:MM:SS> <LINES> lines <BYTES> bytes  <PATH>"
  # Sorted newest first.
  find ~/.codex/sessions -type f -name 'rollout-*.jsonl' -printf '%T@ %p\n' 2>/dev/null   | sort -nr   | awk '{
      epoch=$1; $1=""; sub(/^ /,"");
      path=$0;
      cmd = "date -d @" epoch " \"+%F %T\"";
      cmd | getline dt; close(cmd);
      cmd2 = "wc -lc < \"" path "\"";
      cmd2 | getline wcres; close(cmd2);
      split(wcres, a);
      printf "%-19s %8s lines %10s bytes  %s\n", dt, a[1], a[2], path;
    }'
}

codexr() {
  local nth="${1:-1}"
  local selection path

  if command -v fzf >/dev/null 2>&1; then
    selection=$(_codexr_list_sessions       | fzf --ansi --no-sort --reverse --height=20             --prompt="Select Codex session > "             --preview 'tail -n 60 "$(echo {} | awk "{print \$NF}")"'             --preview-window=down:50%)
    [[ -z "$selection" ]] && { echo "No selection."; return 1; }
    path=$(awk '{print $NF}' <<< "$selection")
  else
    path=$(_codexr_list_sessions | sed -n "${nth}p" | awk '{print $NF}')
    [[ -z "$path" ]] && { echo "No session found."; return 1; }
    echo "Resuming (#${nth}): $path"
  fi

  codex -c experimental_resume="$path"
}
