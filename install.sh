#!/bin/bash
set -e

echo ""
echo "========================================"
echo "           Bootstrap Script             "
echo "========================================"
echo ""

#!/bin/bash
# Bootstrap a new machine:
# curl -fLo ~/install.sh https://raw.githubusercontent.com/msgitb/dotfiles/main/install.sh && chmod +x ~/install.sh && ./install.sh

# ── Variables ────────────────────────────────
GITHUB_USERNAME="msgitb"
DOTFILES_REPO="git@github.com:$GITHUB_USERNAME/dotfiles.git"
NVM_VERSION="v0.40.4"

# ── System packages ───────────────────────────
echo ">>> [1/12] Installing system packages..."
sudo apt update && sudo apt install -y \
    zsh \
    git \
    curl \
    wget \
    unzip \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libffi-dev \
    liblzma-dev \
    tk-dev \
    libbluetooth-dev \
    uuid-dev \
    ripgrep \
    fd-find \
    hstr \
    bat \
    gpg \
    gh \
    xclip

# ── eza ───────────────────────────────────────
echo ">>> [2/12] Installing eza..."
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | \
    sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | \
    sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update && sudo apt install -y eza

# ── Kitty ─────────────────────────────────────
echo ">>> [3/12] Installing Kitty..."
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
# Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
# Place the kitty.desktop file somewhere it can be found by the OS
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
# Update the paths to the kitty and its icon in the kitty desktop file(s)
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
# Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
echo 'kitty.desktop' > ~/.config/xdg-terminals.list

# ── Nerd Font ─────────────────────────────────
echo ">>> [4/12] Installing JetBrainsMono Nerd Font..."
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "JetBrainsMono.zip" \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -o JetBrainsMono.zip -d JetBrainsMono
rm JetBrainsMono.zip
fc-cache -fv
cd ~

# ── Zsh as default shell ──────────────────────
echo ">>> [5/12] Setting zsh as default shell..."
chsh -s $(which zsh)


# ── Zinit ─────────────────────────────────────
echo ">>> [6/12] Installing Zinit..."
bash -c "$(curl --fail --show-error --silent --location \
    https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# ── Starship ──────────────────────────────────
echo ">>> [7/12] Installing Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- --yes

# ── fzf ───────────────────────────────────────
echo ">>> [8/12] Installing fzf..."
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# ── nvm + Node ────────────────────────────────
echo ">>> [9/12] Installing nvm + Node..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default node
npm install -g yarn expo-cli

# ── pyenv + Python ────────────────────────────
echo ">>> [10/12] Installing pyenv + Python..."
sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev libffi-dev liblzma-dev \
    tk-dev libbluetooth-dev uuid-dev
curl https://pyenv.run | bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
eval "$(pyenv virtualenv-init -)"
pyenv install 3.12
pyenv global 3.12
pip install uv
pip install --upgrade pip

# ── VS Code ───────────────────────────────────
echo ">>> [11/12] Installing VS Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor > microsoft.gpg
sudo install -D -o root -g root -m 644 microsoft.gpg \
    /usr/share/keyrings/microsoft.gpg
rm -f microsoft.gpg
sudo apt install apt-transport-https -y

cat > /tmp/vscode.sources << EOF
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF
sudo mv /tmp/vscode.sources /etc/apt/sources.list.d/vscode.sources
sudo apt update && sudo apt install code -y

# ── VS Code extensions ────────────────────────
echo ">>> [12/12] Installing VS Code extensions..."
extensions=(
    # Core
    dbaeumer.vscode-eslint
    esbenp.prettier-vscode
    usernamehw.errorlens
    christian-kohler.path-intellisense
    streetsidesoftware.code-spell-checker
    PKief.material-icon-theme
    jdinhlife.gruvbox
    wayou.vscode-todo-highlight
    # React Native / TypeScript
    dsznajder.es7-react-js-snippets
    bradlc.vscode-tailwindcss
    ms-vscode.vscode-typescript-next
    styled-components.vscode-styled-components
    msjsdiag.vscode-react-native
    formulahendry.auto-rename-tag
    ecmel.vscode-html-css
    pranaygp.vscode-css-peek
    # Python
    ms-python.python
    ms-python.black-formatter
    ms-python.isort
    ms-pyright.pyright
    # Git
    eamodio.gitlens
    mhutchie.git-graph
    # Docker
    ms-azuretools.vscode-docker
    ms-vscode-remote.remote-containers
    # Database
    cweijan.vscode-database-client2
    # AI
    github.copilot
    github.copilot-chat
)
for ext in "${extensions[@]}"; do
    code --install-extension "$ext" --force
done

# ── SSH key ───────────────────────────────────
echo ">>> Setting up SSH key..."
echo "NOTE: Generating RSA 4096 key. Add the public key to GitHub after setup."
ssh-keygen -t rsa -b 4096 -C "omarcelito@gmail.com" -f ~/.ssh/id_rsa -N ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
echo ""
echo "Your public key (add this to GitHub -> Settings -> SSH keys):"
cat ~/.ssh/id_rsa.pub
echo ""
read -p "Press Enter after adding the key to GitHub..."
ssh -T git@github.com

# ── Dotfiles ──────────────────────────────────
echo ">>> Restoring dotfiles..."
git clone --bare $DOTFILES_REPO $HOME/.dotfiles
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
dotfiles config --local status.showUntrackedFiles no

# Back up any conflicting files before checkout
mkdir -p ~/.dotfiles-backup
dotfiles checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | \
    xargs -I{} sh -c 'mkdir -p ~/.dotfiles-backup/$(dirname {}) && mv ~/{} ~/.dotfiles-backup/{}'

dotfiles checkout

echo ""
echo "========================================"
echo "   All done!"
echo "   1. Log out and back in for zsh to take effect"
echo "   2. Open Kitty — font and theme should be applied"
echo "   3. Open VS Code and switch to your preferred profile"
echo "========================================"
