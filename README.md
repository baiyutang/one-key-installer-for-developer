# One key installer for developer

This is a shell script for new linux computer of developer,which can install all the basic software & packages & libs as you need.

## Features
- support OS: `Ubuntu`
- installing package: `curl` `zsh` `wget` `unzip` `git` `python3` `vim` `openssh-server` `gnome-tweaks` `apt-transport-https` `ca-certificates` `software-properties-common` `fonts-powerline`
- installing software: `Docker` `Oh My Zsh` `baidupinyin` `Jetbrain Toolbox` `Firefox` `VS Code`

## Usage


| Method    | Command                                                                                           |
|:----------|:--------------------------------------------------------------------------------------------------|
| **curl**  | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/baiyutang/one-key-installer-for-developer/main/install.sh)"` |
| **wget**  | `sh -c "$(wget -O- https://raw.githubusercontent.com/baiyutang/one-key-installer-for-developer/main/install.sh)"`   |
| **fetch** | `sh -c "$(fetch -o - https://raw.githubusercontent.com/baiyutang/one-key-installer-for-developer/main/install.sh)"` |
