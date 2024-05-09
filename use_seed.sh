#!/usr/bin/env bash

main() {
  local package_filename="seed.zip"
  local downloads_dir="$HOME/Downloads"
  local package_path="${downloads_dir}/${package_filename}"
  local unzipped_dir="${downloads_dir}/seed"

  if [ ! -f "${package_path}" ]; then
    echo "File packaged from old machine not found at expected path: ${package_path}"
    exit 1
  fi

  unzip "${package_path}"

  cp -R "${unzipped_dir}/.ssh" "$HOME"
  cp -R "${unzipped_dir}/.aws" "$HOME"
  cp "${unzipped_dir}/.zsh_history" "$HOME"
  cp -R "${unzipped_dir}/.gnupg" "$HOME"
  cp "${unzipped_dir}/.zsh_history" "$HOME"
  cp -R "${unzipped_dir}/.dotfiles" "$HOME"
  cp "${unzipped_dir}/.notes.md" "$HOME"
  cp -R "${unzipped_dir}/.cargo" "$HOME"
}

main
