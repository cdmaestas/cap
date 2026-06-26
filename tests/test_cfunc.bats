#!/usr/bin/env bats

REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"

setup() {
    # shellcheck source=/dev/null
    source "${REPO_ROOT}/libexec/sh/cfunc"
}

@test "cinfo outputs to stdout" {
    run cinfo "hello world"
    [[ "${status}" -eq 0 ]]
    [[ "${output}" =~ "hello world" ]]
}

@test "cerror outputs to stderr" {
    run bash -c "source '${REPO_ROOT}/libexec/sh/cfunc'; cerror 'bad thing' 2>&1 >/dev/null"
    [[ "${output}" =~ "bad thing" ]]
}

@test "cdebug outputs to stdout" {
    run cdebug "debug message"
    [[ "${status}" -eq 0 ]]
    [[ "${output}" =~ "debug message" ]]
}

@test "cpass outputs to stdout" {
    run cpass "all good"
    [[ "${status}" -eq 0 ]]
    [[ "${output}" =~ "all good" ]]
}

@test "cwarn outputs to stdout" {
    run cwarn "heads up"
    [[ "${status}" -eq 0 ]]
    [[ "${output}" =~ "heads up" ]]
}

@test "check_validvar passes with non-empty value" {
    run check_validvar MYVAR "somevalue"
    [[ "${status}" -eq 0 ]]
}

@test "check_validvar fails with empty value" {
    run check_validvar MYVAR ""
    [[ "${status}" -ne 0 ]]
}

@test "check_validvar fails with fewer than 2 args" {
    run check_validvar MYVAR
    [[ "${status}" -ne 0 ]]
}

@test "parsecli parses --tool flag" {
    parsecli --tool slurm --rpm
    [[ "${TOOL}" == "slurm" ]]
    [[ "${RPM}" -eq 1 ]]
}

@test "parsecli parses --prefix flag" {
    parsecli --tool pdsh --prefix /opt/cap5
    [[ "${TOOL}" == "pdsh" ]]
    [[ "${PREFIX}" == "/opt/cap5" ]]
}

@test "parsecli parses --clean flag" {
    parsecli --tool genders --clean
    [[ "${CLEAN}" -eq 1 ]]
    [[ "${DISTCLEAN}" -eq 0 ]]
}

@test "parsecli parses --distclean flag" {
    parsecli --tool genders --distclean
    [[ "${DISTCLEAN}" -eq 1 ]]
}

@test "parsecli resets state between calls" {
    parsecli --tool foo --rpm
    parsecli --tool bar
    [[ "${TOOL}" == "bar" ]]
    [[ "${RPM}" -eq 0 ]]
}

@test "pkg_search rejects unknown method" {
    run pkg_search unknown somepackage
    [[ "${status}" -ne 0 ]]
}

@test "pkg_search fails with fewer than 2 args" {
    run pkg_search yum
    [[ "${status}" -ne 0 ]]
}
