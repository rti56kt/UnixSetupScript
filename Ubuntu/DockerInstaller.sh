#!/usr/bin/bash

installDocker() {
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y apt-transport-https ca-certificates gnupg-agent software-properties-common
    wget -O- https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    return
}

uninstallDocker() {
    sudo apt -y --purge remove docker-ce docker-ce-cli containerd.io
    sudo rm -rf /var/lib/docker
    sudo add-apt-repository --remove "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-key del 0EBFCD88
    return
}

installerMenu() {
    echo -n "\
    +-----------------Ubuntu Docker Installer-----------------+
    | 1) Install Docker From Official                         |
    | 2) Uninstall Docker                                     |
    | Q) Exit                                                 |
    +---------------------------------------------------------+
    Please choose the option you want.
    > "

    read choice

    echo -e "Your Choice: $choice\n"
    case $choice in
        1)
            installDocker
        ;;
        2)
            uninstallDocker
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
}

while true; do
    installerMenu
done
