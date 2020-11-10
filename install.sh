#!/usr/bin/env bash
#
# This is a shell script for new linux computer of developer,
# which can install all the basic software & packages & libs as you need.

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

color_text() {
  echo -e " \e[0;$2m$1\e[0m"
}

echo_success() {
  echo $(color_text "$1" "32")
}

echo_error() {
  echo $(color_text "$1" "31")
}

echo_warning() {
  echo $(color_text "$1" "33")
}

echo_notice() {
  echo $(color_text "$1" "34")
}

echo_text() {
  echo $1
}

get_dist_name() {
  if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release >/dev/null; then
    DISTRO='CentOS'
    PM='yum'
  elif grep -Eqi "Red Hat Enterprise Linux" /etc/issue || grep -Eq "Red Hat Enterprise Linux" /etc/*-release; then
    DISTRO='RHEL'
    PM='yum'
  elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
    DISTRO='Aliyun'
    PM='yum'
  elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
    DISTRO='Fedora'
    PM='yum'
  elif grep -Eqi "Amazon Linux" /etc/issue || grep -Eq "Amazon Linux" /etc/*-release; then
    DISTRO='Amazon'
    PM='yum'
  elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
    DISTRO='Debian'
    PM='apt'
  elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
    DISTRO='Ubuntu'
    PM='apt'
  elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
    DISTRO='Raspbian'
    PM='apt'
  elif grep -Eqi "Deepin" /etc/issue || grep -Eq "Deepin" /etc/*-release; then
    DISTRO='Deepin'
    PM='apt'
  elif grep -Eqi "Mint" /etc/issue || grep -Eq "Mint" /etc/*-release; then
    DISTRO='Mint'
    PM='apt'
  elif grep -Eqi "Kali" /etc/issue || grep -Eq "Kali" /etc/*-release; then
    DISTRO='Kali'
    PM='apt'
  else
    DISTRO='unknow'
  fi
}

is_64bit_os() {
  IS_64BIT='N'
  if [[ $(getconf WORD_BIT) == '32' && $(getconf LONG_BIT) == '64' ]]; then
    IS_64BIT='Y'
  fi
}

install_packages() {
  packages_name=""
  for i in $*; do
    dpkg -s ${i} &>/dev/null
    if [ $? -ne 0 ]; then
      packages_name="${packages_name} ${i}"
    else
      echo_notice "Already installed: ${i}"
    fi
  done
  if [[ ${packages_name} == "" ]]; then
    return
  fi
  sudo apt install -y ${packages_name}
}

install_one_package() {
  dpkg -s $1 &>/dev/null
  if [ $? -ne 0 ]; then
    echo_text "Installing: ${1}..."
    sudo apt install -y $1
  else
    echo_notice "Already installed: ${1}"
  fi
}

china_locale() {
  if [ $LANG = "zh_CN.UTF-8" ]; then
    CHINA_LOCALE="Y"
  else
    CHINA_LOCALE="N"
  fi
}

install_docker() {
  command_exists docker
  if [ $? -eq 0 ]; then
    docker -v
    echo_notice "Already installed: Docker"
    return
  fi

  sudo apt-get remove docker docker-engine docker.io

  china_locale
  if [ "${CHINA_LOCALE}" = "Y" ]; then
    curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
  else
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  fi

  install_packages docker-ce

  if [ $(getent group docker) ]; then
    echo_notice "docker group exists."
  else
    sudo groupadd docker
  fi

  sudo usermod -aG docker $USER
  sudo systemctl enable docker
  sudo systemctl start docker
  docker -v
  echo_success "Install successfully: Docker"
}

install_ohmyzsh() {
  echo_text "Installing zsh..."
  install_packages zsh
  sudo chsh -s $(which zsh)

  echo_text "Installing ohmyzsh..."
  if [[ -d $HOME/.oh-my-zsh ]]; then
    echo_notice "You already have Oh My Zsh installed."
    read -r -p "Do you want to reinstall? (y/n) : "
    if [[ "${REPLY}" == "y" || "${REPLY}" == "Y" ]]; then
      rm -rf $HOME/.oh-my-zsh
    else
      echo_warning 'you have canceled to reinstall!'
      return
    fi
  fi

  sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  plugins_dir=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
  if [[ ! -d ${plugins_dir}/zsh-syntax-highlighting ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${plugins_dir}/zsh-syntax-highlighting
  fi
  if [[ ! -d ${plugins_dir}/zsh-autosuggestions ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${plugins_dir}/zsh-autosuggestions
  fi

  echo_success "Install successfully: ohmyzsh"
}

install_terminator() {
  command_exists terminator
  if [ $? -eq 0 ]; then
    terminator -v
    echo_notice "Already installed: terminator"
    return
  fi

  echo_text "Installing Terminator..."
  install_packages terminator
  # set terminator as the default terminal of Ubuntu
  gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/terminator
  gsettings set org.gnome.desktop.default-applications.terminal exec-arg "-x"

  command_exists terminator
  if [ $? -eq 0 ]; then
    terminator -v
    echo_success "Install successfully: Terminator"
    return
  fi
  echo_error "Terminator install fail."
}

install_baidupinyin() {
  china_locale
  if [[ "${CHINA_LOCALE}" == "N" ]]; then
    echo_notice "baidupinyin just for China Locale"
    return
  fi

  echo_text "Installing baidupinyin..."
  wget https://imeres.baidu.com/imeres/ime-res/guanwang/img/Ubuntu_Deepin-fcitx-baidupinyin-64.zip -O /tmp/baidupinyin.zip
  unzip -o /tmp/baidupinyin.zip -d /tmp/baidupinyin
  echo "install the dependent packages..."
  sudo apt-get install -y aptitude >/dev/null
  sudo aptitude install -y fcitx-bin fcitx-table fcitx-config-gtk fcitx-config-gtk2 fcitx-frontend-all >/dev/null
  sudo aptitude install -y qt5-default qtcreator qml-module-qtquick-controls2 >/dev/null
  sudo dpkg -i /tmp/baidupinyin/fcitx-baidupinyin.deb
  echo_success "Install successfully: baidupinyin. It will work after you reboot your computer."
}

install_jetbrains_toolbox() {
  echo_text "Installing JetBrains Toolbox..."
  tar_file=$HOME/jetbrains-toolbox.tar.gz
  if [[ ! -f ${tar_file} ]]; then
    wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.18.7455.tar.gz -O ${tar_file}
  fi
  if [[ ! -f ${tar_file} ]]; then
    echo_error "jetbrains-toolbox.tar.gz download fail"
    return
  fi
  tar -xf ${tar_file} --directory=$HOME
  $HOME/jetbrains-toolbox-1.18.7455/jetbrains-toolbox >/dev/null 2>&1 &
  echo_success "Install successfully: JetBrains Toolbox"
}

install_firefox() {
  command_exists firefox
  if [ $? -eq 0 ]; then
    firefox -v
    echo_notice "Already installed: Firefox"
    return
  fi

  echo_text "Installing Firefox..."
  sudo add-apt-repository ppa:mozillateam/firefox-next -y
  sudo apt update
  install_packages firefox

  command_exists firefox
  if [ $? -eq 0 ]; then
    firefox -v
    echo_success "Install successfully: Firefox"
    return
  fi
  echo_error "Firefox install fail."
}

install_vscode() {
  command_exists code
  if [ $? -eq 0 ]; then
    code -v
    echo_notice "Already installed: VSCode"
    return
  fi

  echo "Installing VSCode..."
  sudo apt update
  wget -q https://packages.microsoft.com/keys/microsoft.asc -O- >packages.microsoft.gpg
  sudo apt-key add packages.microsoft.gpg
  rm packages.microsoft.gpg
  sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
  sudo apt install code

  # Setting VS Code as the default text editor
  xdg-mime default code.desktop text/plain
  sudo update-alternatives --set editor /usr/bin/code

  command_exists code
  if [ $? -eq 0 ]; then
    code -v
    echo_success "VSCode install succesully!"
    return
  fi
  echo_error "VSCode install fail."
}

main() {
  cat <<'EOF'
  +-----------------------------------------------------------------------+
  |                    One key installer for developer                    |
  +-----------------------------------------------------------------------+
  |      This is a shell script for new linux computer of developer,      |
  |      which can install all the basic software & packages & libs       |
  |      as you need.                                                     |
  +-----------------------------------------------------------------------+
EOF

  get_dist_name
  if [ "${DISTRO}" != "Ubuntu" ]; then
    echo_error "This tools just support Ubuntu now, more distribution will be supported soon"
    exit 1
  fi

  read -r -p "Please confirm you want to install these (y/n) : "
  if [[ "${REPLY}" != "y" && "${REPLY}" != "Y" ]]; then
    echo_warning 'you have canceled!'
    exit 1
  fi

  sudo apt update
  # libavcodec-extra #  see Firefox html5 video support (https://askubuntu.com/questions/475351/firefox-html5-video-support)
  install_packages curl zsh wget unzip git python3 vim openssh-server gnome-tweaks \
    apt-transport-https ca-certificates software-properties-common fonts-powerline

  install_docker
  install_ohmyzsh
  install_terminator
  install_baidupinyin
  install_jetbrains_toolbox
  install_firefox
  install_vscode

}

main "$@"
