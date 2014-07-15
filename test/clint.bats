#!/usr/bin/env bats

@test "print help command" {
  run ./example.bash help
  [[ $status == 0 ]]
  [[ $output =~ usage: ]]
}

@test "print help option" {
  run ./example.bash --help
  [[ $status == 0 ]]
  [[ $output =~ usage: ]]
}

@test "print version command" {
  run ./example.bash version
  [[ $status == 0 ]]
  [[ $output =~ 0.0.1 ]]
}

@test "print version option" {
  run ./example.bash --version
  [[ $status == 0 ]]
  [[ $output =~ 0.0.1 ]]
}

@test "missing command" {
  run ./example.bash
  [[ $status != 0 ]]
  [[ "$output" =~ "missing command" ]]
}

@test "unknown command" {
  run ./example.bash fudge
  [[ $status != 0 ]]
  [[ "$output" =~ "unknown command" ]]
}

@test "unknown option" {
  run ./example.bash --fudge
  [[ $status != 0 ]]
  [[ $output =~ "unknown option" ]]
}

@test "extra argument" {
  run ./example.bash --help=1
  [[ $status != 0 ]]
  [[ $output =~ "extra argument" ]]
}

@test "missing parameter" {
  run ./example.bash print
  [[ $status != 0 ]]
  [[ $output =~ "missing parameter" ]]
}

@test "missing argument" {
  run ./example.bash print --times
  [[ $status != 0 ]]
  [[ $output =~ "missing argument" ]]
}

@test "print default times" {
  run ./example.bash print fudge
  [[ $status == 0 ]]
  [[ $(echo "$output" | wc -l) -eq 2 ]]
}

@test "print option times" {
  run ./example.bash print --times=3 fudge
  [[ $status == 0 ]]
  [[ $(echo "$output" | wc -l) -eq 3 ]]
}
