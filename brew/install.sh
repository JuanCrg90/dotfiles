#!/user/bin/sh

RED='\033[0;31m'
NC='\033[0m' # No Color]]'

echo "[*] Installing Homebrew"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "[*] Installing Cask"
brew tap caskroom/cask

echo "[*] Download ack"
brew install the_silver_searcher
