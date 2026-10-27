#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
}

@test "system-info.sh executes successfully with exit code 0" {
  run bash "$REPO_ROOT/scripts/system-info.sh"
  [ "$status" -eq 0 ]
}

@test "system-info.sh reports active shell" {
  run bash "$REPO_ROOT/scripts/system-info.sh"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Active Shell:" ]]
}
