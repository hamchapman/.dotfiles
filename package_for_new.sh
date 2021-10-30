#!/usr/bin/env bash

main() {
  local package_filename="seed.zip"
  local package_path="$HOME/Downloads/${package_filename}"
  local temp_packaging_dir="$HOME/.dotfiles/tmp/package_prep"

  rm -rf "${temp_packaging_dir}" 2> /dev/null

  mkdir -p "${temp_packaging_dir}"

  cp -R "$HOME/.ssh" "${temp_packaging_dir}"
  rm -f "${temp_packaging_dir}/.ssh/known_hosts"
  cp -R "$HOME/.aws" "${temp_packaging_dir}"
  cp "$HOME/.zsh_history" "${temp_packaging_dir}"
  cp -R "$HOME/.gnupg" "${temp_packaging_dir}"
  cp "$HOME/.dotfiles/zsh/secret.zsh" "${temp_packaging_dir}"
  cp -R "$HOME/Library/Application Support/Code/Backups" "${temp_packaging_dir}"

  (
    cd "${temp_packaging_dir}" \
      && zip -r "$package_filename" . \
      && cp "$package_filename" "$package_path"
  )
}

main
