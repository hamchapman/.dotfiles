# hamchapman's dotfiles

## How to use

### On the old machine (if possible)

* Run `./package_for_new.sh` to create `~/Downloads/seed.tar.gz.gpg`. Choose a
  strong passphrase and transfer it separately from the archive. The archive
  contains SSH and GPG keys, AWS credentials, shell history, notes and the
  dotfiles secrets file when present; it does not contain the dotfiles checkout.

### On the new machine

* Clone these dotfiles into `~/.dotfiles` using SSH or HTTPS:
  `git clone https://github.com/hamchapman/.dotfiles.git ~/.dotfiles`

**If you created a seed:**

* Install GnuPG (for example with `brew install gnupg`), then copy the encrypted
  archive to `~/Downloads/seed.tar.gz.gpg` and run `~/.dotfiles/use_seed.sh`.
  Existing files are retained rather than overwritten. Delete the archive from
  both machines once you have verified the restored files.

* Run `~/.dotfiles/macos.sh` from the dotfiles directory.

After editing `git/gitconfig.template`, run `~/.dotfiles/bin/refresh-gitconfig`
to update the generated Git config used by the current machine.

**Manual steps:**

* Sign in to GitHub CLI with `gh auth login --hostname github.com`, choosing
  SSH as the preferred Git protocol. Use `gh auth status` to check that the
  login is stored in the system keyring. GitHub HTTPS operations use that login;
  other HTTPS hosts use macOS Keychain.
* Set Finder prefs
* Set Safari prefs (e.g. enable developer menu, load previous windows on start,
  etc)

## Credits

Shamelessly hacked together from various parts of other people's dotfiles,
including but not limited to:

 * [Jack Franklin](https://github.com/jackfranklin/dotfiles)
 * [Mathias Bynens](https://github.com/mathiasbynens/dotfiles)
 * [Keith Smiley](https://github.com/keith/dotfiles)
