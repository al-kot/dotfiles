#!/bin/sh
sleep 5
echo "" > $HOME/logs.txt
install() {
	for p in "$@"; do
		echo "installing $p" >> $HOME/logs.txt
		# nix profile install nixpkgs#$p
	done
}


install stow wezterm zsh nerd-fonts.mononoki starship oh-my-zsh
