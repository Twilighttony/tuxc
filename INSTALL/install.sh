#!/bin/bash

# Colors
RED='\033[0;31m'
LRED="\033[1;31m"
BLUE="\033[0;34m"
LBLUE="\033[1;34m"
GREEN="\033[0;32m"
LGREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
LCYAN="\033[1;36m"
PURPLE="\033[0;35m"
LPURPLE="\033[1;35m"
BWHITE="\e[1m"
NC='\033[0m' # No Color

SOLUS="/usr/bin/eopkg"
DEBIAN_UBUNTU="/usr/bin/apt"
FEDORA="/usr/bin/dnf"
function checkRoot() {
  if [[ $EUID -ne 0 ]]; then
    printf "${LRED}This script must be run as root${NC}\n" 1>&2
     exit 1
  fi
}

function getDeps() {
  printf "${LGREEN}Installing required dependencies...${NC}\n"

  if [ -f "${SOLUS}" ];then
    eopkg it llvm-clang llvm-clang-devel linux-headers pkg-config make lua-devel glibc-devel
  
  elif [ -f "${DEBIAN_UBUNTU}" ];then
    apt-get update
    apt-get install -y clang make pkg-config lua5.3-dev

  elif [ -f "${FEDORA}" ];then
    dnf install clang make lua-devel pkg-config

  else
    printf "${LRED}System not supported${NC}"
  fi
}


function installTuxc() {
  if [ ! -f /usr/bin/tux ];then
      printf "${LGREEN}Building executable...${NC}\n"
      make -C ../ 
      printf "${LGREEN}Installing...${NC}\n"
      make install -C ../
    else
      printf "${LGREEN}Cleaning build environment...${NC}\n"
      make clean -C ../
      printf "${LGREEN}Building executable...${NC}\n"
      make -C ../
      printf "${LGREEN}Installing...${NC}\n"
      make install -C ../
  fi

}

checkRoot
getDeps
installTuxc
