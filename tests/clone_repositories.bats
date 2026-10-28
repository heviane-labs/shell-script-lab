#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
}

@test "clone-github-repos.sh displays help message with -h flag" {
  run bash "$REPO_ROOT/scripts/clone-github-repos.sh" -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "clone-github-repos.sh fails when unknown option is provided" {
  run bash "$REPO_ROOT/scripts/clone-github-repos.sh" --unknown-arg
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Unknown option" ]]
}

@test "clone-github-repos.sh supports --dry-run mode" {
  run bash "$REPO_ROOT/scripts/clone-github-repos.sh" --target heviane-labs --dry-run
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Dry Run Mode:    true" ]]
  [[ "$output" =~ "Completed processing" ]]
}

