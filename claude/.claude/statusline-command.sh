#!/bin/sh
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
today=$(date "+%a %b %d")
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // empty')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // empty')

# Shorten model name: drop leading "Claude " if present
short_model=$(echo "$model" | sed 's/^Claude //')

# Shorten home directory to ~
home="$HOME"
short_cwd=$(echo "$cwd" | sed "s|^$home|~|")

# Remote marker: shown only over SSH, so no marker means a local session
host_display=""
if [ -n "${SSH_CONNECTION:-}${SSH_CLIENT:-}${SSH_TTY:-}" ]; then
  host=$(uname -n)
  host_display="ssh:${host%%.*} | "
fi

# Git branch (skip optional locks)
git_branch=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  git_branch=$(git -C "$cwd" -c core.hooksPath=/dev/null symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# Build context usage display
ctx_display=""
if [ -n "$used_pct" ]; then
  ctx_int=$(printf "%.0f" "$used_pct")
  ctx_display=" | ctx:${ctx_int}%"
fi

# Build git display
git_display=""
if [ -n "$git_branch" ]; then
  git_display=" | git:${git_branch}"
fi

# Build rate limit display
five_h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rate_display=""
if [ -n "$five_h" ]; then
  five_int=$(printf "%.0f" "$five_h")
  rate_display=" | 5h:${five_int}%"
fi

# Build cost display
cost_display=""
if [ -n "$cost_usd" ]; then
  cost_display=$(printf " | \$%.2f" "$cost_usd")
fi

# Build diff stats display
diff_display=""
if [ -n "$lines_added" ] && [ -n "$lines_removed" ] && { [ "$lines_added" != "0" ] || [ "$lines_removed" != "0" ]; }; then
  diff_display=" | +${lines_added} -${lines_removed}"
fi

printf "\033[1;93m%s\033[0m\033[1;94m%s\033[0m\033[0;32m%s\033[0m\033[0;32m%s\033[0m\033[0;33m%s\033[0m\033[0;36m%s\033[0m\033[0;35m%s\033[0m\033[0;37m%s\033[0m\033[0;90m%s\033[0m" \
  "$host_display" \
  "$short_cwd" \
  " | $today" \
  "$git_display" \
  "$rate_display" \
  "$ctx_display" \
  "$cost_display" \
  "$diff_display" \
  " | $short_model"
