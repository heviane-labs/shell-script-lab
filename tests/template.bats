#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
}

@test "template.sh displays help message with -h flag" {
  run bash "$REPO_ROOT/scripts/template.sh" -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "template.sh accepts --name option" {
  run bash "$REPO_ROOT/scripts/template.sh" --name "Tester"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Hello, Tester!" ]]
}

@test "template.sh supports --dry-run mode" {
  run bash "$REPO_ROOT/scripts/template.sh" --dry-run
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Dry-run mode enabled" ]]
}

@test "template.sh fails on invalid option" {
  run bash "$REPO_ROOT/scripts/template.sh" --invalid-option
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Unknown option" ]]
}

