#!/usr/bin/env bats

REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/.." && pwd)"

@test "install.sh exits 1 with no args" {
    run bash "${REPO_ROOT}/install.sh"
    [[ "${status}" -eq 1 ]]
}

@test "install.sh prints usage to stderr with no args" {
    run bash "${REPO_ROOT}/install.sh" 2>&1
    [[ "${output}" =~ "Usage:" ]]
}

@test "install.sh creates expected directory structure" {
    local tmpdir
    tmpdir=$(mktemp -d)
    run bash "${REPO_ROOT}/install.sh" "${tmpdir}" /opt/cap5
    [[ "${status}" -eq 0 ]]
    [[ -d "${tmpdir}/opt/cap5/bin" ]]
    [[ -d "${tmpdir}/opt/cap5/src" ]]
    [[ -d "${tmpdir}/opt/cap5/libexec" ]]
    [[ -d "${tmpdir}/opt/cap5/share/doc" ]]
    [[ -d "${tmpdir}/opt/cap5/etc" ]]
    rm -rf "${tmpdir}"
}

@test "install.sh creates usr symlinks" {
    local tmpdir
    tmpdir=$(mktemp -d)
    run bash "${REPO_ROOT}/install.sh" "${tmpdir}" /opt/cap5
    [[ "${status}" -eq 0 ]]
    [[ -L "${tmpdir}/usr/bin/deploy" ]]
    [[ -L "${tmpdir}/usr/src/cap5" ]]
    [[ -L "${tmpdir}/usr/libexec/cap5" ]]
    rm -rf "${tmpdir}"
}

@test "install.sh defaults _cap_home to /opt/cap5" {
    local tmpdir
    tmpdir=$(mktemp -d)
    run bash "${REPO_ROOT}/install.sh" "${tmpdir}"
    [[ "${status}" -eq 0 ]]
    [[ -d "${tmpdir}/opt/cap5/bin" ]]
    rm -rf "${tmpdir}"
}
