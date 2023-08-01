#!/usr/bin/env bash

# MKPS1
# (Mike Kasberg PS1)
# (Or, Make PS1)

# Different functions generate different parts (segments) of the PS1 prompt.
# Each function should leave the colors in a clean state (e.g. call reset if they changed any colors).

# content is edited from https://www.mikekasberg.com/blog/2021/06/28/my-new-bash-prompt.html
# https://github.com/mkasberg/dotfiles/blob/99c51be200ad7b81a7a5c26ccf947259ad8a29d8/executable_dot_mkps1.sh#L3-L8

# For Git PS1
source /usr/lib/git-core/git-sh-prompt;
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=auto
export GIT_PS1_SHOWCONFLICTSTATE=conflict

# For python virtual env
# disable venv default prompt since we customise it
export VIRTUAL_ENV_DISABLE_PROMPT=1

__mkps1_debian_chroot() {
    # This string is intentionally single-quoted:
    # It will be evaluated when $PS1 is evaluated to generate the prompt each time.
    echo '${debian_chroot:+($debian_chroot)}';
}

__mkps1_inject_exitcode() {
    local code=$1

    if [ "$code" -ne "0" ]; then
        echo " $code "
    fi
}

__mkps1_exitcode() {
    local bg_red=`tput setab 1`;
    local white=`tput setaf 15`;
    local reset=`tput sgr0`;

    # We need to run a function at runtime to evaluate the exitcode.
    echo "\[${bg_red}${white}\]\$(__mkps1_inject_exitcode \$?)\[${reset}\]"
}

__mkps1_time() {
    local BG_GRAY=`tput setab 240`;
    local white=`tput setaf 7`;
    local reset=`tput sgr0`;

    echo "\[${BG_GRAY}${white}\] \t \[${reset}\]"
}

__mkps1_username() {
    local cyan=`tput setaf 64`;
    local reset=`tput sgr0`;

    echo "\[${cyan}\] \u \[${reset}\]";
}

__mkps1_arrows() {
    local bold=`tput bold`;
    local blue=`tput setaf 250`;
    local reset=`tput sgr0`;

    echo "\[${bold}${blue}\]→\[${reset}\]";
}

__mkps1_workdir() {
    local bold=`tput bold`;
    local blue=`tput setaf 42`;
    local reset=`tput sgr0`;

    echo "\[${bold}${blue}\]\w\[${reset}\]";
}

__mkps1_git() {
    local pink=`tput setaf 206`;
    local reset=`tput sgr0`;

    # Escaping the $ is intentional:
    # This is evaluated when the prompt is generated.
    echo "\$(__git_ps1 ' (\[${pink}\]%s\[${reset}\])')"
}

__venv_ps1() {
    local purple=`tput setaf 98`;
    local reset=`tput sgr0`;

    # only add env information if a virtualenv is activated
    if ! test -z "$VIRTUAL_ENV" ; then
        echo " (${purple}$(basename "${VIRTUAL_ENV}")${reset})"
    fi
}

__mkps1_python_venv() {
    echo "\$(__venv_ps1)"
}

__mkps1_box_top() {
    local cyan=`tput setaf 45`;
    local reset=`tput sgr0`;
    echo "\[${cyan}\]╭\[${reset}\]"
}

__mkps1_box_bottom() {
    local cyan=`tput setaf 45`;
    local reset=`tput sgr0`;
    echo "\[${cyan}\]╰\[${reset}\]"
}

__mkps1_user_prompt() {
    local bold=`tput bold`;
    local reset=`tput sgr0`;
    
    echo "\[${bold}\]\$\[${reset}\] ";
}

__mkps1() {
    local ps1="\n$(__mkps1_box_top)$(__mkps1_debian_chroot)$(__mkps1_exitcode)$(__mkps1_time)$(__mkps1_username)$(__mkps1_arrows) $(__mkps1_workdir)$(__mkps1_git)$(__mkps1_python_venv)\n$(__mkps1_box_bottom)$(__mkps1_user_prompt)";

    echo "$ps1";
}

# To test, for example, print output before changes and after changes
# and see if the diff is correct.
# Uncomment for testing:
#__mkps1;
