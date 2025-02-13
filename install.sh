#!/bin/sh

echo "" > $HOME/logs.txt

install() {
	for p in "$@"; do
		nix profile install nixpkgs\#"$p"
	done
}

{

install stow wezterm zsh starship tmux polybar lsd rufi

nix profile install --impure --expr 'with (builtins.getFlake "nixpkgs").legacyPackages.${builtins.currentSystem};
    nerdfonts.override {
      fonts = [
        "Mononoki"
    ];
  }'

rm -rf "$HOME/.tmux" "$HOME/.tmux.conf" "$HOME/.zsh" "$HOME/.zshrc"

stow wezterm zsh tmux polybar picom lsd rufi i3 neovim

git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME"/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME"/.zsh/syntax-highlighting 

} >> "$HOME/logs.txt" 2>&1


