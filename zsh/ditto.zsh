export LDFLAGS="-L${BREW_PREFIX}/opt/openssl/lib"
export CC_wasm32_unknown_unknown="/opt/homebrew/opt/llvm/bin/clang"

# >>> casper >>>  (managed by the Casper installer — safe to remove as a block)
[ -f "$HOME/.casper/env" ] && . "$HOME/.casper/env"
[ -f "$HOME/.casper/aliases.sh" ] && . "$HOME/.casper/aliases.sh"
casper-refresh() { bash "$HOME/.casper/refresh.sh" && . "$HOME/.casper/aliases.sh"; }
# <<< casper <<<
