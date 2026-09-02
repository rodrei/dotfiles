# On macOS lazygit reads config from ~/Library/Application Support/lazygit
# unless XDG_CONFIG_HOME is set. Point it at the symlinked ~/.config copy
# instead so the dotfiles copy is the one in use.
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"
