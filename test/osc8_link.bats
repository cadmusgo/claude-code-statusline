#!/usr/bin/env bats

# OSC 8 clickable directory link tests
# Tests for the statusline's clickable VS Code + Finder directory links

SCRIPT="$BATS_TEST_DIRNAME/../statusline.sh"

# Helper: generate mock JSON and pipe to statusline.sh
run_statusline() {
  local dir="${1:-/Users/test/my-project}"
  local json
  json=$(cat <<EOF
{
  "model": {"display_name": "Claude Sonnet 4"},
  "context_window": {"used_percentage": 25, "context_window_size": 200000},
  "cost": {"total_cost_usd": 0.5, "total_lines_added": 10, "total_lines_removed": 3, "total_duration_ms": 60000},
  "workspace": {"current_dir": "$dir"},
  "worktree": {"branch": "main"},
  "rate_limits": {"five_hour": {"used_percentage": 10}, "seven_day": {"used_percentage": 5}}
}
EOF
  )
  echo "$json" | bash "$SCRIPT"
}

@test "output contains OSC 8 vscode link" {
  run run_statusline "/Users/test/my-project"
  [ "$status" -eq 0 ]
  # OSC 8 開始標記: \033]8;;vscode://file...
  [[ "$output" == *"]8;;vscode://file/Users/test/my-project"* ]]
}

@test "output contains OSC 8 file link for Finder" {
  run run_statusline "/Users/test/my-project"
  [ "$status" -eq 0 ]
  # OSC 8 開始標記: \033]8;;file://...
  [[ "$output" == *"]8;;file:///Users/test/my-project"* ]]
}

@test "output contains OSC 8 closing tags" {
  run run_statusline "/Users/test/my-project"
  [ "$status" -eq 0 ]
  # OSC 8 結束標記: \033]8;;\a
  [[ "$output" == *"]8;;"* ]]
}

@test "URL encodes spaces in path" {
  run run_statusline "/Users/test/my project"
  [ "$status" -eq 0 ]
  [[ "$output" == *"my%20project"* ]]
}

@test "fallback to plain text when cwd is relative" {
  run run_statusline "."
  [ "$status" -eq 0 ]
  # Should NOT contain OSC 8 vscode link
  [[ "$output" != *"]8;;vscode://"* ]]
}

@test "ASCII mode shows editor symbol" {
  CLAUDE_STATUSLINE_ASCII=1 run run_statusline "/Users/test/proj"
  [ "$status" -eq 0 ]
  [[ "$output" == *"[e]"* ]]
  [[ "$output" == *"[d]"* ]]
}

@test "directory name is visible in output" {
  run run_statusline "/Users/test/my-project"
  [ "$status" -eq 0 ]
  [[ "$output" == *"my-project"* ]]
}
