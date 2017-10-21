DIR="${HOME}/.dotfiles"

all:
	@echo "Run things individually!"

symlinks:
	@ln -sf $(DIR)/zsh/zshrc ~/.zshrc
	@ln -sf $(DIR)/git/gitconfig ~/.gitconfig
	@ln -sf $(DIR)/git/gitignore_global ~/.gitignore_global
	touch ~/dotfiles/zsh/secret

install_brews:
	brew tap Homebrew/bundle
	brew tap caskroom/versions
	brew bundle
