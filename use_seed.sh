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

  # Create seed directory and extract ZIP file there
  mkdir -p "${unzipped_dir}"
  unzip -o "${package_path}" -d "${unzipped_dir}"

  # Ensure all target directories exist in home
  mkdir -p "$HOME/.aws"
  mkdir -p "$HOME/.cargo"
  mkdir -p "$HOME/.dotfiles"
  mkdir -p "$HOME/.gnupg"
  mkdir -p "$HOME/.ssh"

  # Copy directories to HOME
  cp -R "${unzipped_dir}/.aws" "$HOME"
  cp -R "${unzipped_dir}/.cargo" "$HOME"
  cp -R "${unzipped_dir}/.dotfiles" "$HOME"
  cp -R "${unzipped_dir}/.gnupg" "$HOME"
  cp -R "${unzipped_dir}/.ssh" "$HOME"

  # Copy files to HOME
  cp "${unzipped_dir}/.notes.md" "$HOME"
  cp "${unzipped_dir}/.zsh_history" "$HOME"

  echo "Seed files successfully copied to HOME directory"
}

main
