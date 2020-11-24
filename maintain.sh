#!/bin/bash
# set -x

bytesToHuman() {
    b=${1:-0}
    d=''
    s=0
    S=(Bytes {K,M,G,T,E,P,Y,Z}iB)
    while ((b > 1024)); do
        d="$(printf ".%02d" $((b % 1024 * 100 / 1024)))"
        b=$((b / 1024))
        ((s++))
    done
    echo "$b$d ${S[$s]} of space was cleaned up"
}

# Ask for the administrator password upfront
sudo -v

# Keep-alive sudo until `maintain.sh` has finished
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

oldAvailable=$(df / | tail -1 | awk '{print $4}')

# Homebrew
echo 'Update Homebrew Recipes...'
brew update
echo 'Upgrade and remove outdated formulae'
brew upgrade
echo 'Cleanup Homebrew Cache...'
brew cleanup -s &>/dev/null
rm -rfv "$(brew --cache)" &>/dev/null
brew tap --repair &>/dev/null
echo 'Brew Doctor'
brew doctor &>/dev/null

# Getting Go Env Vars setup
# shellcheck disable=SC1091
# source /Users/bagursreenivasamurth/.bash_profile

echo 'Updating Go Tools'
go get -u github.com/mdempsky/gocode
go get -u github.com/uudashr/gopkgs/cmd/gopkgs
go get -u github.com/ramya-rao-a/go-outline
go get -u github.com/acroca/go-symbols
go get -u golang.org/x/tools/cmd/guru
go get -u golang.org/x/tools/cmd/gorename
go get -u github.com/go-delve/delve/cmd/dlv
go get -u github.com/stamblerre/gocode
go get -u github.com/rogpeppe/godef
go get -u github.com/sqs/goreturns
go get -u github.com/golangci/golangci-lint/cmd/golangci-lint
go get -u github.com/cweill/gotests/...
go get -u github.com/fatih/gomodifytags
go get -u github.com/josharian/impl
go get -u github.com/davidrjenni/reftools/cmd/fillstruct
go get -u github.com/haya14busa/goplay/cmd/goplay
go get -u github.com/godoctor/godoctor

echo 'Empty the Trash on all mounted volumes and the main HDD...'
sudo rm -rfv /Volumes/*/.Trashes/* &>/dev/null
sudo rm -rfv ~/.Trash/* &>/dev/null

echo 'Clear System Log Files...'
sudo rm -rfv /private/var/log/asl/*.asl &>/dev/null
sudo rm -rfv /Library/Logs/DiagnosticReports/* &>/dev/null
sudo rm -rfv /Library/Logs/Adobe/* &>/dev/null
rm -rfv ~/Library/Containers/com.apple.mail/Data/Library/Logs/Mail/* &>/dev/null
rm -rfv ~/Library/Logs/CoreSimulator/* &>/dev/null

echo 'Clear Adobe Cache Files...'
sudo rm -rfv ~/Library/Application\ Support/Adobe/Common/Media\ Cache\ Files/* &>/dev/null

echo 'Cleanup iOS Applications...'
rm -rfv ~/Music/iTunes/iTunes\ Media/Mobile\ Applications/* &>/dev/null

echo 'Remove iOS Device Backups...'
rm -rfv ~/Library/Application\ Support/MobileSync/Backup/* &>/dev/null

echo 'Cleanup XCode Derived Data and Archives...'
rm -rfv ~/Library/Developer/Xcode/DerivedData/* &>/dev/null
rm -rfv ~/Library/Developer/Xcode/Archives/* &>/dev/null

echo 'Cleanup pip cache...'
rm -rfv ~/Library/Caches/pip

# echo 'Cleanup Docker'
# docker system prune -af

echo 'Purge inactive memory...'
sudo purge

newAvailable=$(df / | tail -1 | awk '{print $4}')
count=$((newAvailable - oldAvailable))
count=$(($count * 512))
bytesToHuman $count
