# One key installer for developer

This is a shell script for new linux computer of developer,which can install all the basic software & packages & libs as you need.

## Features
- Support OS: `Ubuntu`
- Installing package: `curl` `zsh` `Oh My Zsh` `wget` `unzip` `git` `python3` `vim` `openssh-server` `apt-transport-https` `ca-certificates` `software-properties-common` `fonts-powerline`
- Installing software: `Gnome-tweaks` `Docker` `baidupinyin` `Jetbrain Toolbox` `Firefox` `VS Code`
- Idempotent: Retry as you want. It will skip packages installed.
- Need More? Leave a [Issue](https://github.com/baiyutang/one-key-installer-for-developer/issues/new)
## Usage

| Method    | Command                                                                                           |
|:----------|:--------------------------------------------------------------------------------------------------|
| **curl**  | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/baiyutang/one-key-installer-for-developer/main/install.sh)"` |
| **wget**  | `sh -c "$(wget -O- https://raw.githubusercontent.com/baiyutang/one-key-installer-for-developer/main/install.sh)"`   |
| **fetch** | `sh -c "$(fetch -o - https://raw.githubusercontent.com/baiyutang/one-key-installer-for-developer/main/install.sh)"` |
