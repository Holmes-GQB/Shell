#!/bin/bash

##### ForeColor #####
front_black() {
    echo -e "\033[30;1m${1}\033[0m"
}
front_red() {
    echo -e "\033[31;1m${1}\033[0m"
}
front_green() {
    echo -e "\033[32;1m${1}\033[0m"
}
front_brown() {
    echo -e "\033[33;1m${1}\033[0m"
}
front_blue() {
    echo -e "\033[34;1m${1}\033[0m"
}
front_purple() {
    echo -e "\033[35;1m${1}\033[0m"
}
front_cyan() {
    echo -e "\033[36;1m${1}\033[0m"
}
front_white() {
    echo -e "\033[37;1m${1}\033[0m"
}

##### BackColor #####
back_black() {
    echo -e "\033[40;1m${1}\033[0m"
}
back_red() {
    echo -e "\033[41;1m${1}\033[0m"
}
back_green() {
    echo -e "\033[42;1m${1}\033[0m"
}
back_brown() {
    echo -e "\033[43;1m${1}\033[0m"
}
back_blue() {
    echo -e "\033[44;1m${1}\033[0m"
}
back_purple() {
    echo -e "\033[45;1m${1}\033[0m"
}
back_cyan() {
    echo -e "\033[46;1m${1}\033[0m"
}
back_white() {
    echo -e "\033[47;1m${1}\033[0m"
}
