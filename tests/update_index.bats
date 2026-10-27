#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
}

@test "update-index.sh displays help message with -h flag" {
  run bash "$REPO_ROOT/scripts/update-index.sh" -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "update-index.sh passes --check when index is synchronized" {
  run bash "$REPO_ROOT/scripts/update-index.sh" --check
  [ "$status" -eq 0 ]
  [[ "$output" =~ "scripts/index.md is fully up-to-date." ]]
}
