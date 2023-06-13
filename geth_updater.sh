#!/bin/bash
#Geth updater and Static nodes updater for BNB Chain
#Set Node location, must have geth ELF and config.toml
WORKDIR="/home/geth"

function main() {
        updateGeth
        updateStaticNodes
        systemctl restart geth
}

function updateGeth() {
        cd "$WORKDIR"
        wget $(curl -s https://api.github.com/repos/bnb-chain/bsc/releases/latest |grep browser_ |grep geth_linux |cut -d\" -f4)
        mv geth_linux geth
        chmod -v u+x geth
        cd -
}

function updateStaticNodes() {
        StaticNodes=$(curl https://api.binance.org/v1/discovery/peers | sed -r 's/^.{9}//' | sed -r 's/.{1}$//')
        sed -i "/StaticNodes = /c\StaticNodes = $StaticNodes" config.toml

}

main $@
