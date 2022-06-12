#!/bin/bash
set -e

# Kitty Config
mkdir -p ~/.config/kitty
ln -sf "$(pwd)/configs/kitty.conf" ~/.config/kitty/kitty.conf
./print.sh "Kitty config installed!"

# Zsh Configs
ln -sf "$(pwd)/configs/.zshrc" ~/.zshrc
ln -sf "$(pwd)/configs/.p10k.zsh" ~/.p10k.zsh
./print.sh "ZSH configs installed!"

# Todo Config
mkdir -p ~/.todo/
ln -sf "$(pwd)/configs/todo.conf" ~/.todo/config
./print.sh "Todo.sh config installed!"

# Sublime Base Folder
if [[ $OSTYPE == 'darwin'* ]]; then
    sublimeBaseFolder="$HOME/Library/Application Support"
    sublimeTextFolder="$sublimeBaseFolder/Sublime Text"
else
    sublimeBaseFolder="$HOME/.config"
    sublimeTextFolder="$sublimeBaseFolder/sublime-text-3"
fi 

mkdir -p "$sublimeBaseFolder/sublime-text-3/Packages/User"
mkdir -p "$sublimeBaseFolder/sublime-merge/Packages/User"

# Sublime Configs
mkdir -p ~/.config/sublime-text-3/Packages/User
# shellcheck disable=SC2016
find "$(pwd)/configs/sublime" -maxdepth 1 -mindepth 1 -print0 | xargs -0 -I {} bash -c "ln -sf \"{}\" \"$sublimeTextFolder/Packages/User/\$(basename \"{}\")\""
./print.sh "Sublime configs installed!"

# Sublime Merge Configs
mkdir -p ~/.config/sublime-merge/Packages/User
# shellcheck disable=SC2016
find "$(pwd)/configs/sublime-merge" -maxdepth 1 -mindepth 1 -print0 | xargs -0 -I {} bash -c "ln -sf \"{}\" \"$sublimeBaseFolder/sublime-merge/Packages/User/\$(basename \"{}\")\""
./print.sh "Sublime merge configs installed!"

# Lazygit Configs
mkdir -p ~/.config/jesseduffield/lazygit
ln -sf "$(pwd)/configs/lazygit.config.yml" ~/.config/jesseduffield/lazygit/config.yml

# tldr config
ln -sf "$(pwd)/configs/.tldrrc" ~/.tldrrc
./print.sh "tldr config installed!"

if [[ $OSTYPE == 'darwin'* ]]; then
    ##### MacOS Specific Configs
    ./print.sh "Installing MacOS Specific Configs"
else 
    ##### ChromeOS Specific Configs
    ./print.sh "Installing ChromeOS Specific Configs"
    
    # gtkrc-2.0 config
    ln -sf "$(pwd)/configs/.gtkrc-2.0" ~/.gtkrc-2.0
    ./print.sh "GTK config installed!"

    # Systemd Local Units & Overrides
    rm -rf ~/.config/systemd
    ln -sf "$(pwd)/configs/systemd" ~/.config/systemd
    ./print.sh "systemd local units & overrides installed!"

    # System-wide systemd Config
    sudo rm -f /etc/systemd/journald.conf 
    sudo ln -sf "$(pwd)/configs/etc/systemd/journald.conf" /etc/systemd/journald.conf 
    sudo systemctl restart systemd-journald
    ./print.sh "system-wide systemd configs installed!"

    # dnsmasq.d
    sudo rm -rf /etc/dnsmasq.d
    sudo ln -sf "$(pwd)/configs/dnsmasq.d" /etc/dnsmasq.d
    sudo systemctl restart dnsmasq
    ./print.sh "dnsmasq.d configs installed!"


    INSTALL_ENCRYPTED=$(jq -r '.installThingsWithEncryptedDeps' config.json)

    if [[ $INSTALL_ENCRYPTED = 'true' ]]; then
        ./print.sh "Installing configs relying on encrypted files..."
        
        # Deluge Configs
        mkdir -p ~/.config/deluge
        ln -sf "$(pwd)/configs/deluge/gtk3ui.conf" ~/.config/deluge/gtk3ui.conf
        ln -sf "$(pwd)/configs/deluge/hostlist.conf" ~/.config/deluge/hostlist.conf
        ./print.sh "Deluge configs installed!"

    else
        ./print.sh "Skipping installing configs relying on encrypted files..."
    fi
fi


./print.sh "All configs installed!"