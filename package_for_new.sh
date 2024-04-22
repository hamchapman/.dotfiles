#!/usr/bin/env bash

PROJECT_ROOT_DIR="$(git rev-parse --show-toplevel)"

main() {
  local package_filename="seed.zip"
  local package_path="$HOME/Downloads/${package_filename}"
  local temp_packaging_dir="$HOME/Downloads/tmp/dotfiles_package_prep/"

  (cd "${PROJECT_ROOT_DIR}" \
    && git checkout main \
    && git pull
  )

  rm -rf "${temp_packaging_dir}" 2> /dev/null

  mkdir -p "${temp_packaging_dir}"

  cp -R "$HOME/.ssh" "${temp_packaging_dir}"
  rm -f "${temp_packaging_dir}/.ssh/known_hosts"
  cp -R "$HOME/.aws" "${temp_packaging_dir}"
  cp "$HOME/.zsh_history" "${temp_packaging_dir}"
  cp -R "$HOME/.gnupg" "${temp_packaging_dir}"
  rm -f "${temp_packaging_dir}/.gnupg/gpg-agent.conf"
  cp -R "$HOME/.dotfiles" "${temp_packaging_dir}"
  cp -R "$HOME/.notes.md" "${temp_packaging_dir}"

  (cd "${temp_packaging_dir}" \
    && zip -r "$package_filename" . \
    && cp "$package_filename" "$package_path"
  )
}

main
