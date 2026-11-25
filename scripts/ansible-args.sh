#!/usr/bin/env bash
# Populate $ANSIBLE_ARGS with this repository's inventory, secrets and vault options.
#
# Source this file, do not execute it:
#
#   source scripts/ansible-args.sh <prod|test> <pass|prompt>
#
#   pass      use runtime/<env>/vault_pass.txt
#   password  alias for pass
#   prompt    ask for the vault password
#
# Then run ansible with it:
#
#   ansible-playbook $ANSIBLE_ARGS site.yml
#   ansible-playbook $ANSIBLE_ARGS site.yml --tags core_apps

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
    printf 'source this file instead: source %s <prod|test> <pass|prompt>\n' "${BASH_SOURCE[0]}" >&2
    exit 2
fi

_homelab_set_ansible_args() {
    local env=${1-} vault_auth=${2-}
    local usage='usage: source scripts/ansible-args.sh <prod|test> <pass|prompt>'
    local repo_root inventory secrets vault_pass

    if [[ -z $env || -z $vault_auth ]]; then
        printf '%s\n' "$usage" >&2
        unset ANSIBLE_ARGS
        return 2
    fi

    repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
    inventory="$repo_root/inventories/$env/hosts.yml"
    secrets="$repo_root/runtime/$env/secrets.yml"
    vault_pass="$repo_root/runtime/$env/vault_pass.txt"

    if [[ ! -f $inventory ]]; then
        printf 'missing inventory: %s\n' "$inventory" >&2
        unset ANSIBLE_ARGS
        return 1
    fi

    if [[ ! -f $secrets ]]; then
        printf 'missing secrets file: %s\n' "$secrets" >&2
        unset ANSIBLE_ARGS
        return 1
    fi

    case $vault_auth in
    pass|password)
        if [[ ! -f $vault_pass ]]; then
        printf 'missing vault password file: %s\n' "$vault_pass" >&2
        unset ANSIBLE_ARGS
        return 1
        fi
        ANSIBLE_ARGS="-i $inventory -e @$secrets --vault-password-file $vault_pass"
        ;;
    prompt)
        ANSIBLE_ARGS="-i $inventory -e @$secrets --ask-vault-password"
        ;;
    *)
        printf 'invalid vault auth %q: use pass or prompt\n' "$vault_auth" >&2
        printf '%s\n' "$usage" >&2
        unset ANSIBLE_ARGS
        return 2
        ;;
    esac

    printf 'ANSIBLE_ARGS=%s\n' "$ANSIBLE_ARGS" >&2
}

_homelab_set_ansible_args "$@"
_ansible_args_rc=$?
unset -f _homelab_set_ansible_args
return "$_ansible_args_rc"
