#!/usr/bin/env bash
# Runs on every VS Code attach (postAttachCommand). By then VS Code has copied
# the host ~/.gitconfig and forwarded the host SSH agent (1Password) inside.
set -euo pipefail

# Substrings of 1Password SSH key titles, as shown in `ssh-add -L` comments.
SIGNING_KEY_MATCH="${SIGNING_KEY_MATCH:-JPaiv GH Personal Signing}"
TUNI_KEY_MATCH="${TUNI_KEY_MATCH:-TUNI Gitlab}"

# ------------------------------------------------------------ ssh permissions
# ~/.ssh is bind-mounted from the host. ssh refuses loose modes on it.
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
find "$HOME/.ssh" -type f ! -name "*.pub" -exec chmod 600 {} +

# ------------------------------------------------------------------ ssh hosts
# Pinned GitHub host keys from the repo, not ssh-keyscan. keyscan trusts
# whatever answers on first connect. Source: https://api.github.com/meta
# (ssh_keys). Refresh the file from there if GitHub rotates a key.
touch "$HOME/.ssh/known_hosts"
cat "$(dirname "${BASH_SOURCE[0]}")/github_known_hosts" >> "$HOME/.ssh/known_hosts"
sort -u -o "$HOME/.ssh/known_hosts" "$HOME/.ssh/known_hosts"
chmod 600 "$HOME/.ssh/known_hosts"

# --------------------------------------------------------- agent: git signing
if [[ -S "${SSH_AUTH_SOCK:-}" ]] && agent_keys="$(ssh-add -L 2>/dev/null)"; then
  # GitHub only verifies commits signed with a key registered as a signing key
  # on an account where the commit's author email is verified.
  signing_key="$(grep -F -- "$SIGNING_KEY_MATCH" <<<"$agent_keys" | head -n1 | awk '{print $1, $2}' || true)"

  if [[ -n "$signing_key" ]]; then
    git config --global --unset-all gpg.ssh.program 2>/dev/null || true
    git config --global gpg.format ssh
    git config --global user.signingkey "key::$signing_key"
    git config --global commit.gpgsign true
    git config --global tag.gpgsign true

    # Lets `git log --show-signature` verify commits. Run from the workspace,
    # so a repo-local user.email wins over the host one.
    git_email="$(git config --get user.email || true)"
    if [[ -n "$git_email" ]]; then
      mkdir -p "$HOME/.config/git"
      printf '%s %s\n' "$git_email" "$signing_key" > "$HOME/.config/git/allowed_signers"
      git config --global gpg.ssh.allowedSignersFile "$HOME/.config/git/allowed_signers"
    else
      echo "WARN: git user.email not set. Run: git config user.email you@example.com" >&2
    fi

    echo "==> git signing: $SIGNING_KEY_MATCH (${signing_key:0:32}…)"
  else
    echo "WARN: no '$SIGNING_KEY_MATCH' key in the SSH agent. Git signing left as copied from the host." >&2
  fi

  # --------------------------------------------------------- agent: TUNI key
  if grep -qF -- "$TUNI_KEY_MATCH" <<<"$agent_keys"; then
    echo "==> ssh: '$TUNI_KEY_MATCH' key available for course-gitlab.tuni.fi"
  else
    echo "WARN: no '$TUNI_KEY_MATCH' key in the SSH agent. course-gitlab.tuni.fi clones will fail." >&2
  fi
else
  echo "WARN: no SSH agent keys at ${SSH_AUTH_SOCK:-<unset>}. Unlock 1Password, then reopen the container." >&2
fi

# ----------------------------------------------------------------- smoke test
ver() {
  local out
  out="$("$@" 2>/dev/null | head -n1)" || true
  printf '%-14s %s\n' "$1" "${out:-MISSING}"
}

echo
ver task --version
ver gcc --version
ver g++ --version
ver clang-format --version
ver python3 --version
ver black --version
ver ghc --version
ver cabal --version
ver hlint --version
ver ormolu --version
ver node --version
ver prettier --version
ver eslint --version
ver tsc --version
ver yamllint --version
ver gh --version
