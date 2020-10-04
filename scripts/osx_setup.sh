#!/bin/bash
if [[ `uname` != Darwin ]]
then 
    echo "only macOS supported"
    exit 1
fi

xcode-select --install
read -s -n1 -p "完成XCode配置后按任意键继续... "

# install zsh
install_zsh(){

  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  zsh_plugins=(https://github.com/zsh-users/zsh-autosuggestions.git https://github.com/zsh-users/zsh-syntax-highlighting.git)

  cd ~/.oh-my-zsh/custom/plugins
  for plugin in ${zsh_plugins[@]}; do
    git clone --depth=1 ${plugin} &
  done
}
install_zsh &

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/cask
brew tap homebrew/cask-versions
brew install brew-cask-completion

brew cask install shadowsocksx-ng
open -a ShadowsocksX-NG
echo "正在启动酸酸乳..."
read -s -n1 -p "请完成酸酸乳配置, 按任意键继续... "
export http_proxy=http://127.0.0.1:1087;export https_proxy=http://127.0.0.1:1087;

# install apps
formulas=( \
    cmake \
    node \
    go \
    p7zip \
    unrar \
    python \
    pipenv \
)
brew install ${formulas[@]}
casks=( \
    google-chrome \
    java \
    android-studio-preview \
    intellij-idea-ce \
    visual-studio-code \
    appcleaner \
    docker \
    qq \
    wechat \
    qqlive \
    qqmusic \
    typora \
    postman \
    charles \
)
brew cask install ${casks[@]}


# install set env
echo 'export HOMEBREW_NO_AUTO_UPDATE=true' >> ~/.zshrc
echo 'export ANDROID_HOME=$HOME/Library/Android/sdk' >> ~/.zshrc
echo 'export GOPATH=$HOME/go' >> ~/.zshrc
echo 'export GO111MODULE=auto' >> ~/.zshrc
echo 'export GOPROXY=https://goproxy.io' >> ~/.zshrc
echo 'export FLUTTER_ROOT=$HOME/flutter' >> ~/.zshrc
echo 'export PUB_HOSTED_URL=https://pub.flutter-io.cn' >> ~/.zshrc
echo 'export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn' >> ~/.zshrc
echo 'export PATH=$ANDROID_HOME/platform-tools:$GOPATH/bin:$FLUTTER_ROOT/bin:$PATH' >> ~/.zshrc
# others
echo "截图快捷键 桌面missioncontrol 应用快捷键 QQ 微信快捷键 Docker镜像源"
echo "Omnigraffle Charles MindNode PD"
