# hamchapman's dotfiles

## How to use

### On the old machine (if possible)

* Run `package_for_new.sh` to generate `seed.zip` in `~/Downloads`, ready to be
  copied to the new machine

### On the new machine

**If `seed.zip` exists from old machine:**

* Copy the `seed.zip` file from the old machine to `~/Downloads` on the new
  machine
* Run `use_seed.sh`

**Always do the following:**

* Clone these dotfiles:
  * If you've already got ssh setup (this is true if you used a seed): `git clone git@github.com:hamchapman/.dotfiles.git`
  * Otherwise: `git clone https://github.com/hamchapman/.dotfiles.git`
* Run `macos.sh`

**Manual steps:**

* Set Finder prefs
* Set Safari prefs (e.g. enable developer menu, load previous windows on start,
  etc)
* Set touchbar prefs
* Set sync folder in Alfred prefs
* Set apps to launch at login:
    * Tailscale
    * Fantastical

## TODO

* Maybe swap to xcinfo from xcversion
* Add Time machine to menubar

## Credits

Shamelessly hacked together from various parts of other people's dotfiles,
including:

 * [Jack Franklin](https://github.com/jackfranklin/dotfiles)
 * [Mathias Bynens](https://github.com/mathiasbynens/dotfiles)
 * [Keith Smiley](https://github.com/keith/dotfiles)
