#!/usr/bin/bash

RUNALL=false

getLatestApt() {
    sudo apt update && sudo apt upgrade -y
}

installLivepatch() {
    echo "Please provide your Ubuntu Livpatch Service Key or simply type a \"Q\" to go back to menu."
    echo "For more info about Ubuntu Livpatch Service, please visit: https://ubuntu.com/livepatch."
    echo -n "Your key: "

    read key

    case $key in
        [Qq])
            return
        ;;
        *)
            sudo snap install canonical-livepatch
            sudo canonical-livepatch enable $key
            return
        ;;
    esac
}

installAptPacks() {
    if $RUNALL; then
        choice_arr=("1")
    else
        echo -n "\
    +----------------------Apt  Packages----------------------+
    | 1) Install All                                          |
    | 2) Install nano                                         |
    | 3) Install zsh                                          |
    | 4) Install htop                                         |
    | 5) Install git                                          |
    | 6) Install curl & wget                                  |
    | 7) Install neofetch                                     |
    | Q) Back to Menu                                         |
    +---------------------------------------------------------+
    Please choose the package(s) you want. (Options are seperated by a whitespace.)
    > "

        read input

        OIFS="$IFS"
        IFS=" "
        read -a choice_arr <<< "${input}"
        IFS="$OIFS"
    fi

    packs2install=()

    for choice in "${choice_arr[@]}"; do
        case $choice in
            1)
                packs2install+=("nano")
                packs2install+=("zsh")
                packs2install+=("htop")
                packs2install+=("git")
                packs2install+=("curl")
                packs2install+=("wget")
                packs2install+=("neofetch")
            ;;
            2)
                packs2install+=("nano")
            ;;
            3)
                packs2install+=("zsh")
            ;;
            4)
                packs2install+=("htop")
            ;;
            5)
                packs2install+=("git")
            ;;
            6)
                packs2install+=("curl")
                packs2install+=("wget")
            ;;
            7)
                packs2install+=("neofetch")
            ;;
            [Qq])
                return
            ;;
            *)
                echo "Invalid Choice: $choice"
            ;;
        esac
    done
    packs2install=$(echo "${packs2install[*]}" | tr " " "\n" | sort -u | tr "\n" " ")
    echo -e "\nPackages you are going to install: $packs2install"
    sudo apt install -y $packs2install
    return
}

cleanup() {
    sudo apt autoremove --purge -y
    return
}

installDocker() {
    sudo apt install -y apt-transport-https ca-certificates gnupg-agent software-properties-common
    wget -O- https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    return
}

installOhMyZsh() {
    echo "Install oh-my-zsh:"
    echo '    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
    echo "Install zsh-autosuggestions:"
    echo '    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'
    echo "Download custom agnoster theme:"
    echo '    wget https://raw.githubusercontent.com/rti56kt/UnixSetupScript/master/UsefulFiles/zsh-custom-theme/agnoster.zsh-theme'
    echo ""
    echo "You might have to configure your .zshrc manually."
    echo "For zsh-autosuggestions: plugins=(other-plugin zsh-autosuggestions)"
    echo "For theme: ZSH_THEME=\"agnoster\""
    echo ""

    return
}

installMiniconda() {
    echo "Download Miniconda3 64-bit:"
    echo '    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh'
    echo ""

    return
}

showAdditionalSetup() {
    installOhMyZsh
    installMiniconda
    exit 0
}

runAll() {
    getLatestApt
    installLivepatch
    installAptPacks
    cleanup
    showAdditionalSetup
    return
}

setupScriptMenu() {
    echo -n "\
    +-------------------Ubuntu Setup Script-------------------+
    | 1) Run All                                              |
    | 2) Get Latest Apt                                       |
    | 3) Install Ubuntu Livepatch                             |
    | 4) Install Apt Packages                                 |
    | 5) Install Docker                                       |
    | 6) Clean Up                                             |
    | A) Additional Manual Setup Instruction                  |
    | Q) Exit                                                 |
    +---------------------------------------------------------+
    Please choose the option(s) you want. (Options are seperated by a whitespace.)
    > "

    read input

    OIFS="$IFS"
    IFS=" "
    read -a choice_arr <<< "${input}"
    IFS="$OIFS"

    for choice in "${choice_arr[@]}"; do
        echo -e "Your Choice: $choice\n"
        case $choice in
            1)
                RUNALL=true
                runAll
            ;;
            2)
                getLatestApt
            ;;
            3)
                installLivepatch
            ;;
            4)
                installAptPacks
            ;;
            5)
                installDocker
            ;;
            6)
                cleanup
            ;;
            [Aa])
                showAdditionalSetup
            ;;
            [Qq])
                echo "Bye!"
                exit 0
            ;;
            *)
                echo "Invalid Choice: $choice"
            ;;
        esac
        echo ""
    done
}

while true; do
    setupScriptMenu
done
