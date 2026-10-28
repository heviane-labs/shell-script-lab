#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
}

@test "script-to-clone-all-repositories.sh displays help message with -h flag" {
  run bash "$REPO_ROOT/scripts/script-to-clone-all-repositories.sh" -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "script-to-clone-all-repositories.sh fails when unknown option is provided" {
  run bash "$REPO_ROOT/scripts/script-to-clone-all-repositories.sh" --unknown-arg
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Unknown option" ]]
}

@test "script-to-clone-all-repositories.sh supports --dry-run mode" {
  run bash "$REPO_ROOT/scripts/script-to-clone-all-repositories.sh" --target heviane-labs --dry-run
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Dry Run Mode:    true" ]]
  [[ "$output" =~ "Completed processing" ]]
}
