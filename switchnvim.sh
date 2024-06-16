#!/bin/zsh
WORKSPACE_DIR="${0:a:h}"

mode=$1

case "$mode" in
"lazyvim")
	mkdir -p ~/.config
	rm -f ~/.config/nvim
	ln -s "$WORKSPACE_DIR/settings/lazyvim" ~/.config/nvim
  echo "$mode is changed."
	;;
"zenvim")
	mkdir -p ~/.config
	rm -f ~/.config/nvim
	ln -s "$WORKSPACE_DIR/settings/zenvim" ~/.config/nvim
  echo "$mode is changed."
	;;
*)
	echo "$mode isn't supported."
	;;
esac
