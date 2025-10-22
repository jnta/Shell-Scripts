#!/bin/bash

# --- 1. Install Zsh and Git ---
echo "--- 1. Installing Zsh and Git ---"
sudo apt update
sudo apt install -y zsh git

# --- 2. Install Oh My Zsh (OMZ) ---
echo "--- 2. Installing Oh My Zsh (OMZ) ---"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    # Use the official install script for OMZ
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed. Skipping installation."
fi

# --- 3. Install Powerlevel10k (Theme) ---
echo "--- 3. Installing Powerlevel10k theme ---"
P10K_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
if [ ! -d "$P10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo "Powerlevel10k is already cloned. Skipping clone."
fi

# --- 4. Install Plugins (Autosuggestions and Syntax Highlighting) ---
echo "--- 4. Installing Autosuggestions and Syntax Highlighting plugins ---"

# Zsh Autosuggestions
ZSH_AUTOSUGGESTIONS_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
if [ ! -d "$ZSH_AUTOSUGGESTIONS_DIR" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGESTIONS_DIR"
else
    echo "Autosuggestions plugin is already cloned. Skipping clone."
fi

# Zsh Syntax Highlighting
ZSH_SYNTAX_HIGHLIGHTING_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
if [ ! -d "$ZSH_SYNTAX_HIGHLIGHTING_DIR" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_HIGHLIGHTING_DIR"
else
    echo "Syntax Highlighting plugin is already cloned. Skipping clone."
fi

# --- 5. Configure .zshrc ---
echo "--- 5. Configuring .zshrc for Theme and Plugins ---"

# Back up the original .zshrc
cp ~/.zshrc ~/.zshrc.bak

# Set the Theme to Powerlevel10k
sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Add/Update the Plugins line for zsh-autosuggestions and zsh-syntax-highlighting
# Note: The 'git' plugin is included by default by OMZ
PLUGINS_LINE='plugins=(git zsh-autosuggestions zsh-syntax-highlighting)'
if grep -q "plugins=(" ~/.zshrc; then
    sed -i "s/^plugins=(.*)/$PLUGINS_LINE/" ~/.zshrc
else
    # If the line doesn't exist (unlikely with OMZ), append it
    echo "$PLUGINS_LINE" >> ~/.zshrc
fi

# --- 6. Set Zsh as Default Shell and Final Steps ---
echo "--- 6. Setting Zsh as the default shell (requires password) ---"
chsh -s $(which zsh)

echo " "
echo "✅ Setup Complete!"
echo "Please **log out and log back in** to start using Zsh."
echo "The first time you run Zsh, the Powerlevel10k configuration wizard will start."
echo "Run: zsh"