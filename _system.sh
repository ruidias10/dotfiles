#!/bin/bash

PURPLE="\033[0;35m"
IWHITE="\033[0;97m"
GREEN='\033[0;32m'
CYAN="\033[0;36m" 
RED='\033[0;31m'

BOLD='\033[1m'
NC='\033[0m' 



programname=$0
function usageTmux {
    echo ""
    echo "TMUX start workspace"
    echo ""
    echo "usage: $programname --workspace string --workdir string "
    echo ""
    echo "  --workspace string      name of the workspace"
    echo "                          (example: workspace; react-project; laravel-project)"
    echo "  --workdir string        work path"
    echo "                          (example: /home/$USER/workdir/)"
    echo ""
}


function die {
    printf "Script failed: %s\n\n" "$1"
    exit 1
}


### Run Tmux
#### ./_system.sh runtmux --workspace Laravel --workdir /home/ruidias/Workspace/lixo/laravel
runtmux() {
    echo "Run Tmux"

    while [ $# -gt 0 ]; do
        if [[ $1 == "--"* ]]; then
            v="${1/--/}"
            declare "$v"="$2"
            shift
        fi
        shift
    done

    if [[ -z $workspace ]]; then
        usageTmux
        die "Missing parameter --workspace"
    elif [[ -z $workdir ]]; then
        usageTmux
        die "Missing parameter --workdir"
    fi

    echo "Workspace: $workspace";
    echo "Workdir: $workdir";

    # Verifica se o diretório existe. Se não existir, cria.
    if [ ! -d "$workdir" ]; then
        echo "Diretório $workdir não existe. Criando..."
        mkdir -p "$workdir"
        if [ $? -ne 0 ]; then
            die "Falha ao criar o diretório $workdir"
        fi
        echo "Diretório $workdir criado com sucesso."

        # Inicializa um repositório Git no diretório criado
        echo "Inicializando repositório Git em $workdir..."
        git -C "$workdir" init
        if [ $? -ne 0 ]; then
            die "Falha ao inicializar o repositório Git em $workdir"
        fi
        echo "Repositório Git inicializado com sucesso."
    fi

    SESSION="$workspace"
    SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

    if [ "$SESSIONEXISTS" = "" ]
    then
        # Cria uma nova sessão Tmux com o nome do workspace e define o diretório de trabalho
        tmux new-session -s "$SESSION" -n "System  " -d -c "$workdir"
        
        # Cria uma nova janela para Docker
        tmux new-window -t "$SESSION:2" -n "Docker " -c "$workdir"
        tmux send-keys -t "$SESSION:2" 'lazydocker' C-m

        # Cria uma nova janela para Git
        tmux new-window -t "$SESSION:3" -n "Git " -c "$workdir"
        tmux send-keys -t "$SESSION:3" 'lazygit' C-m

        # Seleciona a primeira janela e anexa a sessão
        tmux select-window -t "$SESSION:1"
        tmux -2 attach-session -t "$SESSION"
    else
        # Se a sessão já existe, apenas anexa a ela
        tmux attach-session -t "$SESSION"
    fi    
}



### Install all system
install() {
    echo "Executando instalação..."

    sudo pacman -Syu
    sudo pacman -S --needed base-devel git

    # install yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si

    # pacman
    sudo pacman -S firefox 
    sudo pacman -S pacman-contrib
    sudo pacman -S kitty 
    sudo pacman -S wofi 
    sudo pacman -S waybar
    sudo pacman -S yazi 
    sudo pacman -S ffmpeg 
    sudo pacman -S p7zip 
    sudo pacman -S jq 
    sudo pacman -S poppler 
    sudo pacman -S fd 
    sudo pacman -S ripgrep 
    sudo pacman -S fzf 
    sudo pacman -S zoxide 
    sudo pacman -S imagemagick
    sudo pacman -S git curl wget nvim neovim
    sudo pacman -S ttf-jetbrains-mono-nerd 
    sudo pacman -S ttf-font-awesome
    sudo pacman -S zsh-syntax-highlighting 
    sudo pacman -S zsh-autosuggestions
    sudo pacman -S fzf 
    sudo pacman -S zoxide 
    sudo pacman -S ripgrep 
    sudo pacman -S fd 
    sudo pacman -S bat 
    sudo pacman -S poppler
    sudo pacman -S bashtop 
    sudo pacman -S lazygit 
    sudo pacman -S neofetch 
    sudo pacman -S gnome-tweaks
    sudo pacman -S lsd
    sudo pacman -S bleachbit
    sudo pacman -S tree
    sudo pacman -S less
    sudo pacman -S zip
    sudo pacman -S rsync
    sudo pacman -S httpie #https://httpie.io/cli
    sudo pacman -S mariadb-clients 
    sudo pacman -S fuse-exfat
    sudo pacman -S exfat-utils

    # yay
    yay -S ttf-cascadia-code-nerd
    yay -S tmux 
    yay -S tmuxinator 
    yay -S lazydocker 
    yay -S shopt 
    yay -S starship 
    yay -S hyprpaper
    yay -S stow 
    yay -S hypridle 
    yay -S hyprlock 
    yay -S swaync 
    yay -S zen-browser-bin 
    yay -S hyprshot nvitop
    yay -S usql
    yay -S google-chrome
    yay -S visual-studio-code-bin

    # tmux
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    # zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting    

    # git
    # git config --global -e
    git config --global user.name "Rui Dias"
    git config --global user.email "rui.dias10@gmail.com"
    git config --global core.editor nvim
    git config --global init.defaultBranch master
    git config --list

    # docker
    sudo pacman -S docker docker-compose
    sudo systemctl enable --now docker.service
    sudo systemctl is-active docker.service
    sudo docker info
    sudo ls -lha /var/lib/docker
    sudo usermod -aG docker ${USER}
    newgrp docker

    # stow
    cd ~/dotfiles 
    stow hyprpaper
    stow backgrounds
    stow kitty
    stow starship
    stow wofi
    stow hyprlock
    stow hyprmocha
    stow tmux
    stow yazi
    stow bashtop 
    stow lazygit
    stow bat
    stow hyprland
    stow git
    stow vscode
    stow lsd
    stow nvim

    # Confif bat
    bat cache --build
    bat --config-file

    # Install nvm node
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    nvm install --lts

    # Install Rust
    curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

    # Instal PHP
    sudo pacman -S php composer
    sudo pacman -S php-mysql php-openssl php-curl php-mbstring php-xml

    # SSH Key
    ssh-keygen -t ed25519 -C "rui.dias10@gmail.com"
}


### Install all vscode extension
setupvscode() {
    code --install-extension 1yib.rust-bundle
    code --install-extension alefragnani.bookmarks
    code --install-extension alefragnani.project-manager
    code --install-extension alexcvzz.vscode-sqlite
    code --install-extension aravindkumar.gherkin-indent
    code --install-extension bierner.github-markdown-preview
    code --install-extension bierner.markdown-checkbox
    code --install-extension bierner.markdown-emoji
    code --install-extension bierner.markdown-footnotes
    code --install-extension bierner.markdown-mermaid
    code --install-extension bierner.markdown-preview-github-styles
    code --install-extension bierner.markdown-yaml-preamble
    code --install-extension bmewburn.vscode-intelephense-client
    code --install-extension catppuccin.catppuccin-vsc
    code --install-extension christian-kohler.npm-intellisense
    code --install-extension christian-kohler.path-intellisense
    code --install-extension codezombiech.gitignore
    code --install-extension codingyu.laravel-goto-view
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension dcortes92.freemarker
    code --install-extension donjayamanne.githistory
    code --install-extension drcika.apc-extension
    code --install-extension dsznajder.es7-react-js-snippets
    code --install-extension dustypomerleau.rust-syntax
    code --install-extension eamodio.gitlens
    code --install-extension editorconfig.editorconfig
    code --install-extension emmanuelbeziat.vscode-great-icons
    code --install-extension eriklynd.json-tools
    code --install-extension esbenp.prettier-vscode
    code --install-extension felixfbecker.php-intellisense
    code --install-extension fill-labs.dependi
    code --install-extension formulahendry.code-runner
    code --install-extension github.copilot
    code --install-extension github.copilot-chat
    code --install-extension golang.go
    code --install-extension haringsrob.behatcomplete
    code --install-extension jasonnutter.search-node-modules
    code --install-extension joelday.docthis
    code --install-extension jpoissonnier.vscode-styled-components
    code --install-extension liximomo.remotefs
    code --install-extension marcostazi.vs-code-vagrantfile
    code --install-extension mdickin.markdown-shortcuts
    code --install-extension mechatroner.rainbow-csv
    code --install-extension mehedidracula.php-namespace-resolver
    code --install-extension mhutchie.git-graph
    code --install-extension miguelsolorio.min-theme
    code --install-extension miguelsolorio.symbols
    code --install-extension mikestead.dotenv
    code --install-extension mkloubert.vscode-remote-workspace
    code --install-extension mrmlnc.vscode-apache
    code --install-extension ms-azuretools.vscode-docker
    code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
    code --install-extension ms-python.debugpy
    code --install-extension ms-python.isort
    code --install-extension ms-python.python
    code --install-extension ms-python.vscode-pylance
    code --install-extension ms-vscode-remote.remote-containers
    code --install-extension ms-vscode-remote.remote-ssh
    code --install-extension ms-vscode-remote.remote-ssh-edit
    code --install-extension ms-vscode-remote.vscode-remote-extensionpack
    code --install-extension ms-vscode.cpptools
    code --install-extension ms-vscode.cpptools-extension-pack
    code --install-extension ms-vscode.cpptools-themes
    code --install-extension ms-vscode.remote-explorer
    code --install-extension ms-vscode.remote-server
    code --install-extension naumovs.color-highlight
    code --install-extension neilbrayfield.php-docblocker
    code --install-extension onecentlin.laravel-blade
    code --install-extension onecentlin.laravel5-snippets
    code --install-extension pkief.material-icon-theme
    code --install-extension rafa-acioly.laravel-helpers
    code --install-extension redhat.vscode-xml
    code --install-extension redhat.vscode-yaml
    code --install-extension rust-lang.rust-analyzer
    code --install-extension stef-k.laravel-goto-controller
    code --install-extension stevejpurves.cucumber
    code --install-extension tamasfe.even-better-toml
    code --install-extension vscode-icons-team.vscode-icons
    code --install-extension wayou.vscode-todo-highlight
    code --install-extension wix.vscode-import-cost
    code --install-extension xabikos.javascriptsnippets
    code --install-extension xdebug.php-debug
    code --install-extension xdebug.php-pack
    code --install-extension yinfei.luahelper
    code --install-extension zignd.html-css-class-completion
    code --install-extension zobo.php-intellisense
}


### Update system
update() {
    echo "Execute update..."

    # Atualiza pacotes pacman
    sudo pacman -Syyu --noconfirm
    sudo pacman -Syu --noconfirm

    # Atualiza pacotes yay
    yay -Scc --noconfirm
    yay -Sc --aur --noconfirm
    yay -Yc --noconfirm
    yay -Sua --noconfirm
    yay -Syy --noconfirm
    yay -Syu --noconfirm
    yay -Yc --cleanafter --noconfirm

    # Atualiza pacotes flatpack
    sudo flatpak repair
    sudo flatpak update
    sudo flatpak remove --unused --delete-data -y
    sudo flatpak remove --unused -y
    sudo flatpak uninstall --unused -y    
}


### Clean system
clean() {
    echo "Execute cleanup..."

    # PASTAS PARA APAGAR
    rm -rf /home/ruidias/intelephense

    sudo pacman -Sc
    sudo paccache -rk 1 --noconfirm
    sudo pacman -Sc --noconfirm
    sudo pacman -Scc --noconfirm

    # Remove pacotes perdidos
    sudo pacman -Rns $(pacman -Qtdq)
    sudo pacman -Sc --noconfirm
    sudo pacman -Scc --noconfirm

    # Bleachbit
    bleachbit --clean system.tmp 
    bleachbit --clean system.cache 
    bleachbit --clean system.trash 
    bleachbit --clean evolution.cache

    # Remove logs com mais de 2 semanas
    sudo journalctl --vacuum-time 2weeks

    # Apaga lixo
    sudo rm -rf ~/.local/share/Trash/files/
}




### Função help
help() {

    # Cleaning the package cache
    # du -sh /var/cache/pacman/pkg/

    # SYETEM DEBUG: SYSTEMD-BOOT
    # sudo bootctl
    # sudo bootctl list
    # sudo bootctl set-timeout 0

    # VER ESPACO OCUPADO
    # sudo du -hs /var/cache/* /var/lib/*
    # sudo du -hsx /var/lib/*
    # sudo df -h




    echo ""
    echo -e "${IWHITE}${BOLD}󰅬 Packages ${NC}"
    echo -e "${CYAN}${CYAN}  pacman ${NC}           ${BOLD}Package management with pacman ${NC}"
    echo -e "                      ${PURPLE}usage: ${NC}sudo pacman -S helix${IWHITE}  Install package ${NC}"
    echo -e "                      ${PURPLE}usage: ${NC}sudo pacman -Rcns helix${IWHITE}  Remove package ${NC}"
    echo -e "                      ${PURPLE}usage: ${NC}sudo pacman -Qe${IWHITE}  List all installed packages ${NC}"

    echo ""
    echo -e "${IWHITE}${BOLD}󰅬 Disks ${NC}"
    echo -e "${CYAN}${CYAN}  lsblk ${NC}             ${PURPLE}usage: ${NC}sudo lsblk -f${IWHITE}  List all disks in system ${NC}"
    echo ""
    echo -e "${IWHITE}${CYAN}${CYAN}  mount ${NC}            ${BOLD}Mount and umount disk${NC}"
    echo -e "                      ${PURPLE}usage: ${NC}sudo mount /dev/sda1 /mnt/${IWHITE}  Mount disk sda1 on /mnt path ${NC}"
    echo -e "                      ${PURPLE}usage: ${NC}sudo umount /mnt${IWHITE}  Umount disk /mnt ${NC}"
    
    echo ""
    echo -e "${IWHITE}${CYAN}${CYAN}  du ${NC}            ${BOLD}Mount and umount disk${NC}"
    echo -e "                      ${PURPLE}usage: ${NC}sudo du -hs /var/cache/* /var/lib/*${IWHITE}  Mount disk sda1 on /mnt path ${NC}"
    echo -e "                      ${PURPLE}usage: ${NC}sudo du -hsx /var/lib/*${IWHITE}  Umount disk /mnt ${NC}"
    echo ""
    echo -e "${IWHITE}${CYAN}${CYAN}  df ${NC}            ${BOLD}Mount and umount disk${NC}"
    echo -e "                      ${PURPLE}usage: ${NC}sudo df -h${IWHITE}  Mount disk sda1 on /mnt path ${NC}"



    echo ""
    echo -e "${IWHITE}${BOLD}󰅬 System ${NC}"
    echo -e "${CYAN}${CYAN}  journalctl ${NC}        ${BOLD}Remove package with pacman ttf-jetbrains-mono-nerd ${NC}"
    echo -e "                      ${PURPLE}usage: ${IWHITE}sudo journalctl -b 1 ${NC}"
    echo ""
    echo -e "                      Remove package with pacman ttf-jetbrains-mono-nerd"
    echo -e "                      ${PURPLE}usage: ${IWHITE}sudo journalctl -u gdm.service -b${NC}"    





    echo ""
    echo -e "${IWHITE}${BOLD}󰅬 PHP ${NC}"
    echo -e "${CYAN}${CYAN}  laravel ${NC}           ${PURPLE}usage: ${NC}composer create-project laravel/laravel app${IWHITE}  New project ${NC}"


    echo ""
    echo -e "${IWHITE}${BOLD}󰅬 Cli apps ${NC}"
    echo -e "${CYAN}${CYAN}  httpie ${NC}            ${CYAN}https://httpie.io/cli${NC}"
    echo -e "                      ${PURPLE}usage: ${NC}https httpie.io/hello"
    echo -e "                      ${PURPLE}usage: ${NC}http -v pie.dev/get"
    echo -e "${CYAN}${CYAN}  jq ${NC}                ${CYAN}https://jqlang.github.io/jq/${NC}"
    echo -e "                      ${PURPLE}usage: ${NC}curl 'https://api.github.com/repos/jqlang/jq/commits?per_page=5' | jq '.'"
    





    echo ""
    echo -e "${IWHITE}${BOLD}󰅬 MySQL clients ${NC}"
    echo -e "${CYAN}${CYAN}  mysql ${NC}             ${PURPLE}usage: ${NC}mysql -h hostname -u username -p"
    echo -e "                      ${PURPLE}usage: ${NC}mysql -h 127.0.0.1 -u laravel -p"    
    echo ""
    echo -e "${CYAN}${CYAN}  mariadb ${NC}           ${PURPLE}usage: ${NC}mariadb -h 127.0.0.1 -u laravel -p"    
    echo ""
    echo -e "${CYAN}${CYAN}  usql ${NC}              ${PURPLE}usage: ${NC}usql my://user:pass@host/dbname"     
    echo -e "                      ${PURPLE}usage: ${NC}usql my://laravel:password@127.0.0.1/laravel"        



}


### Função para backup
backup() {
    echo "Execute backup..."

    GREEN='\033[0;32m'
    RED='\033[0;31m'

    BOLD='\033[1m'
    NC='\033[0m' 

    TODAY_DATE=$(date +%Y-%m-%d)

    USER_PATH="/home/${USER}"
    BACKUP_PATH="/home/${USER}/Workspace/Backups"
    
    INPUT_ZIP_PATH="/home/${USER}/Workspace/Backups/dotfiles"
    OUTPUT_ZIP_FILE="/home/${USER}/Workspace/Backups/dotfiles-$TODAY_DATE.zip"

    FILES=(
        "${USER_PATH}/dotfiles ${BACKUP_PATH}"
    )

    if [[ ! -e $BACKUP_PATH ]]; then
        mkdir $BACKUP_PATH
    fi    
    
    for file in "${FILES[@]}"; do
        source_file="${file%% *}"
        dest_file="${file#* }"

        cp -r $source_file $dest_file

        if [ ! $? -eq 0 ]; then
            echo -e "${RED} - ${NC}cp -r $source_file $dest_file"
        else
            echo -e "${GREEN} + ${NC}${BOLD}$source_file${NC}"
        fi
    done

    zip -rq $OUTPUT_ZIP_FILE $INPUT_ZIP_PATH
    rm -rf $INPUT_ZIP_PATH
}


### Git setup
setupgit() {
    echo "Execute git setup..."
    GREEN='\033[0;32m'
    RED='\033[0;31m'

    BOLD='\033[1m'
    NC='\033[0m' 

    git config --global user.name "Rui Dias"
    git config --global user.email "rui.dias10@gmail.com"
    git config --global core.editor nvim
    git config --global init.defaultbranch main
    git config --global core.pager cat

    echo -e "${GREEN} + ${NC}${BOLD}"Git setup complete"${NC}"

    while IFS= read -r line; do
        echo -e "${GREEN}  - ${NC}${BOLD}$line${NC}"
    done <<< $(git config --list)
}

hypr() {
    sudo pacman -Syu pacman-contrib
    sudo pacman -Syu hyprland
    sudo pacman -Syu hyprpaper
    sudo pacman -Syu hyprpicker
    sudo pacman -Syu hyprlock
    sudo pacman -Syu waybar
    sudo pacman -Syu swaync
    sudo pacman -Syu kitty
    sudo pacman -Syu wofi
    sudo pacman -Syu lsd 
    sudo pacman -Syu yazi
    
    hyprctl dispatch exit
}


# Verificar o parâmetro usando case
case $1 in
    help)
        help
        ;;
    update)
        update
        ;;
    install)
        install
        ;;
    hypr)
        hypr
        ;;
    clean)
        clean
        ;;
    backup)
        backup
        ;;
    setupvscode)
        setupvscode
        ;;
    setupgit)
        setupgit
        ;;
    runtmux)
        runtmux "$@"
        ;;        
    *)
        echo "Uso: ./update.sh [help|update|install|clean|backup|setupvscode|setupgit|runtmux|hypr]"
        exit 1
        ;;
esac



#clear 

#neofetch

# Rede wi-fi
# sudo systemctl start iwd
# iwctl
# device list
# station wlan0 get-networks
# station wlan0 connect NETWORK_NAME

# Ativar bluetooth permanentemente:
# systemctl enable bluetooth

# Install Microcode
# sudo pacman -S amd-ucode


# monitor
# hyprctl monitors

# sudo pacman -U *.pkg.tar.zst
# sudo pacman -Qs networkmanager

# killall waybar
