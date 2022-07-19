
if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Add bin to home dir
fish_add_path $HOME_DIR/.local/bin

# Repeat last command as sudo
function pls
	eval command sudo $history[1]
end

# Open fishrc
alias fishrc="nvim ~/.config/fish/config.fish"

