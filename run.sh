#!/bin/bash

# Install node.js
install_node() {
    curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh
    sudo bash nodesource_setup.sh
    sudo apt install nodejs -y
}


# Check if node.js is installed
if ! command -v node &> /dev/null
then
    install_node

else
    # Get installed node.js version
    installed_version=$(npm list node --depth=0 | grep node | awk '{print $NF}')
    # Get latest node.js version
    latest_version=$(npm show node version)
    # Compare versions
    if [ "$installed_version" != "$latest_version" ]
    then
        # Upgrade node.js
        apt update node -y
    else
        echo "node.js is already up-to-date"
    fi
fi

# installing & initializing the git
install_git() {
    sudo apt install git -y
    git init
}

#initialize the git

# Check if git is installed from funttion
if ! command -v git &> /dev/null
then
    install_git

else
    apt update git -y
    echo "Git is already up-to-date"
fi

#pull the source code from github
git_pull() {
    git pull https://github.com/padhiarigithub/testapi.git
}

#pull the source code from github from funtion
git_pull


#npm ininitialization
npm_start(){
    npm init 
    npm install --save express mysql body-parser
}

#npm ininitialization from function
npm_start

#run the node
node index.js
