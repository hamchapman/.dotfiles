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

  if [ -d "${unzipped_dir}/Backups" ]; then
    echo "VSCode backups found in package from old machine. Grab them if you want them!"
  fi
}

main
