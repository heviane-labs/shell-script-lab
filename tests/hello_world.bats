#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
}

@test "hello-world.sh executes successfully with exit code 0" {
  run bash "$REPO_ROOT/scripts/hello-world.sh"
  [ "$status" -eq 0 ]
}

@test "hello-world.sh output contains welcome message" {
  run bash "$REPO_ROOT/scripts/hello-world.sh"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Welcome to the Shell Script Laboratory!" ]]
}

