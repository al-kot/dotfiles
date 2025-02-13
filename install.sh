#!/bin/sh

echo "" > $HOME/logs.txt

install() {
	for p in "$@"; do
		echo "installing $p" >> $HOME/logs.txt
		# nix profile install nixpkgs#$p
	done
}



{

dot_list="gitconfig gitignore jnewsrc mozilla msmtprc muttrc signature slrnrc ssh Xdefaults"

for f in "$dot_list"; do
	rm -rf "$HOME/.$f"
	ln -s "$AFS_DIR/.confs/$f" "$HOME/.$f"
done

install stow wezterm zsh nerd-fonts.mononoki starship tmux polybar lsd rufi

rm -rf "$HOME/.tmux" "$HOME/.tmux.conf" "$HOME/.zsh" "$HOME/.zshrc"

stow wezterm zsh tmux polybar picom lsd rufi i3 neovim

git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME"/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME"/.zsh/syntax-highlighting 

} >> "$HOME/logs.txt" 2>&1


