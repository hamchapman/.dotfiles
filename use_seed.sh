#!/usr/bin/env bash
# Restore a seed into a freshly cloned dotfiles checkout.
set -euo pipefail
umask 077
transfer_home=${DOTFILES_TRANSFER_HOME:-$HOME}
archive="$transfer_home/Downloads/seed.tar.gz.gpg"
[[ -f "$archive" ]] || { echo "Encrypted seed not found: $archive" >&2; exit 1; }
[[ -d "$transfer_home/.dotfiles/zsh" ]] || { echo 'Clone the dotfiles before restoring the seed.' >&2; exit 1; }
command -v gpg >/dev/null || { echo 'Install GnuPG before restoring.' >&2; exit 1; }
tmp=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-restore.XXXXXXXX")
trap 'rm -rf "$tmp"' EXIT
# Decrypt completely before extraction, so wrong passwords cannot cause a
# partial restore. Both temporary files are protected by umask and removed.
gpg --decrypt --output "$tmp/seed.tar.gz" "$archive"
mkdir "$tmp/files"
tar -xzf "$tmp/seed.tar.gz" -C "$tmp/files"
# Copy files individually so existing files can be reported and retained. On
# macOS, cp -n returns failure when it skips a file, even without an error.
while IFS= read -r -d '' source; do
  relative=${source#"$tmp/files"/}
  destination="$transfer_home/$relative"
  if [[ -e "$destination" || -L "$destination" ]]; then
    printf 'Keeping existing %s\n' "$relative"
    continue
  fi
  mkdir -p "$(dirname "$destination")"
  cp -pP "$source" "$destination"
done < <(find "$tmp/files" \( -type f -o -type l \) -print0)
printf 'Seed restored. Existing files were retained; remove the encrypted archive when no longer needed.\n'
