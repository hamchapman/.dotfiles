#!/usr/bin/env bash
# Package selected personal files for transfer, encrypted with GnuPG.
set -euo pipefail
umask 077
transfer_home=${DOTFILES_TRANSFER_HOME:-$HOME}
archive="$transfer_home/Downloads/seed.tar.gz.gpg"
command -v gpg >/dev/null || { echo 'Install GnuPG before packaging.' >&2; exit 1; }
[[ ! -e "$archive" ]] || { echo "Archive already exists: $archive" >&2; exit 1; }
mkdir -p "$transfer_home/Downloads"
tmp=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-seed.XXXXXXXX")
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/files"
copy_if_present() {
  local path=$1
  if [[ -e "$transfer_home/$path" ]]; then
    mkdir -p "$tmp/files/$(dirname "$path")"
    cp -Rp "$transfer_home/$path" "$tmp/files/$path"
  fi
}
copy_if_present .ssh
rm -f "$tmp/files/.ssh/known_hosts" "$tmp/files/.ssh/known_hosts.old"
copy_if_present .aws/credentials
copy_if_present .aws/config
copy_if_present .cargo/config
copy_if_present .zsh_history
copy_if_present .notes.md
copy_if_present .dotfiles/zsh/secret.zsh
# Avoid copying live agent sockets; retain key material and trust settings.
for item in private-keys-v1.d pubring.kbx pubring.kbx~ trustdb.gpg gpg.conf sshcontrol openpgp-revocs.d; do
  copy_if_present ".gnupg/$item"
done
# Write to a temporary file alongside the destination so a failure never leaves
# a partial archive at the expected path.
partial=$(mktemp "$transfer_home/Downloads/.seed.XXXXXXXX")
trap 'rm -rf "$tmp"; rm -f "$partial"' EXIT
(cd "$tmp/files" && tar -czf - .) | gpg --yes --symmetric --cipher-algo AES256 --output "$partial"
mv "$partial" "$archive"
printf 'Encrypted seed created at %s\n' "$archive"
