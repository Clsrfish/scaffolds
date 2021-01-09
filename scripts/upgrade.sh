#!/bin/bash
source $HOME/QuickLaunch/zsh_plugins/plugin_macos.zsh

sh $HOME/.oh-my-zsh/tools/upgrade.sh
cd $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git pull origin master
cd $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions && git pull origin master

brew update
brew upgrade
brew upgrade --cask
brew cleanup --prune=all && rm -rf $(brew --cache)

title="Upgrade successfully"
subtitle=""
content="Auto upgrade softwares completed..."
notify "${title}" "${subtitle}" "${content}"
