#!/usr/bin/env bash
set -euxo pipefail
# Remove all local files related to npm/node to avoid conflict
sudo rm -f "/usr/local/bin/node"
sudo rm -f "/usr/local/bin/npm"
sudo rm -f "/usr/local/bin/npx"
sudo rm -rf "/usr/local/include/node"
sudo rm -rf  "/usr/local/lib/dtrace/node.d"
sudo rm -rf "/usr/local/lib/node_modules/npm"
sudo rm -rf "/usr/local/share/doc/node"
sudo rm -rf "/usr/local/share/man/man1/node.1"
sudo rm -rf "/usr/local/share/systemtap/tapset/node.stp"
# INSTALL latest brew
echo "Installing brew in order to build MetaCall"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# uninstall npm/node/npm globally
brew uninstall npm || echo "npm not installed"
brew uninstall node || echo "node not installed"
brew uninstall npm -g || echo "npm globally not installed"
brew unlink node@16 || echo "brew node@16 probably not installed"
# Remove all files related to node
sudo rm -rf /usr/local/lib/node_modules
sudo rm -rf /usr/local/include/node
sudo rm -rf /usr/local/lib/node
sudo rm -rf /usr/local/bin/corepack
# Build metacall brew
brew install ./metacall.rb --build-from-source -dv
echo "Installing MetaCall with brew"
# Fixing linking brew step
# See: https://github.com/Homebrew/brew/issues/1742
brew install ./metacall.rb --build-from-source -v || brew link --overwrite ./metacall.rb
echo "Testing MetaCall"
./test.sh
