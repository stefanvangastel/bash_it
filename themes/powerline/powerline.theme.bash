#!/usr/bin/env bash
#
#
#
# page with unicode symbols: http://unicode-table.com/en/sets/popular/
# note to self: insert unicode in vim: <C-u>v{4 digit code}
# see all colors and their codes: http://misc.flogisoft.com/bash/tip_colors_and_formatting

yellow_light=103
grey_dark=235
grey_light=7
black=232

#THEME_PROMPT_SEPARATOR=""
#THEME_PROMPT_SEPARATOR="♂"
#THEME_PROMPT_SEPARATOR="☠"
THEME_PROMPT_SEPARATOR="★"

SHELL_SSH_CHAR="✆"
SHELL_THEME_PROMPT_COLOR=32
SHELL_SSH_THEME_PROMPT_COLOR=235

VIRTUALENV_CHAR="ⓔ "
VIRTUALENV_THEME_PROMPT_COLOR=35

SCM_NONE_CHAR=""
SCM_GIT_CHAR="♻ "
SCM_GIT_BEHIND_CHAR="↓"
SCM_GIT_AHEAD_CHAR="↑"
SCM_THEME_PROMPT_CLEAN=""
SCM_THEME_PROMPT_DIRTY=""
SCM_THEME_PROMPT_COLOR=238
SCM_THEME_PROMPT_CLEAN_COLOR=29
SCM_THEME_FG_CLEAN_COLOR=7
#SCM_THEME_PROMPT_DIRTY_COLOR=196
SCM_THEME_PROMPT_DIRTY_COLOR=52
SCM_THEME_FG_DIRTY_COLOR=223

SCM_THEME_PROMPT_UNCOMMITTED_COLOR=22

SCM_THEME_PROMPT_STAGED_COLOR=220
SCM_THEME_PROMPT_UNTRACKED_COLOR=033

#CWD_THEME_PROMPT_COLOR=240
CWD_THEME_PROMPT_COLOR=143
CWD_THEME_FG_COLOR=235

LAST_STATUS_THEME_PROMPT_COLOR=52

function set_rgb_color {
    if [[ "${1}" != "-" ]]; then
        fg="38;5;${1}"
    fi
    if [[ "${2}" != "-" ]]; then
        bg="48;5;${2}"
        [[ -n "${fg}" ]] && bg=";${bg}"
    fi
    echo -e "\[\033[${fg}${bg}m\]"
}

# the first part of the prompt
function powerline_shell_prompt {
    if [[ -n "${SSH_CLIENT}" ]]; then
        SHELL_PROMPT="${bold_black}$(set_rgb_color - ${SHELL_SSH_THEME_PROMPT_COLOR}) ${SHELL_SSH_CHAR} \u@\h ${normal}"
        LAST_THEME_COLOR=${SHELL_SSH_THEME_PROMPT_COLOR}
    else
        SHELL_PROMPT="${bold_black}$(set_rgb_color - ${SHELL_SSH_THEME_PROMPT_COLOR}) \u@\h ${normal}"
        LAST_THEME_COLOR=${SHELL_THEME_PROMPT_COLOR}
    fi
}

function powerline_virtualenv_prompt {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        virtualenv=$(basename "$VIRTUAL_ENV")
        VIRTUALENV_PROMPT="$(set_rgb_color ${LAST_THEME_COLOR} ${VIRTUALENV_THEME_PROMPT_COLOR})${THEME_PROMPT_SEPARATOR}${normal}$(set_rgb_color - ${VIRTUALENV_THEME_PROMPT_COLOR}) ${VIRTUALENV_CHAR}$virtualenv ${normal}"
        LAST_THEME_COLOR=${VIRTUALENV_THEME_PROMPT_COLOR}
    else
        VIRTUALENV_PROMPT=""
    fi
}

# the sourcecode part
function powerline_scm_prompt {
    scm_prompt_vars
    local git_status_output
    git_status_output=$(git status 2> /dev/null )

    if [[ "${SCM_NONE_CHAR}" != "${SCM_CHAR}" ]]; then
        if [[ "${SCM_DIRTY}" -eq 1 ]]; then
            # unstaged changes
            if [ -n "$(echo $git_status_output | grep 'Changes not staged')" ]; then
                #SCM_PROMPT="$(set_rgb_color ${SCM_THEME_PROMPT_DIRTY_COLOR} ${SCM_THEME_PROMPT_COLOR})"
                SCM_PROMPT="$(set_rgb_color ${SCM_THEME_FG_DIRTY_COLOR} ${SCM_THEME_PROMPT_DIRTY_COLOR} )"
            
            # uncommitted changes
            elif [ -n "$(echo $git_status_output | grep 'Changes to be committed')" ]; then
                #SCM_PROMPT="$(set_rgb_color ${SCM_THEME_PROMPT_STAGED_COLOR} ${SCM_THEME_PROMPT_COLOR})"
                SCM_PROMPT="$(set_rgb_color ${SCM_THEME_FG_DIRTY_COLOR} ${SCM_THEME_PROMPT_UNCOMMITTED_COLOR})"
            
            # untracked files
            elif [ -n "$(echo $git_status_output | grep 'Untracked files')" ]; then
                #SCM_PROMPT="$(set_rgb_color ${SCM_THEME_PROMPT_UNTRACKED_COLOR} ${SCM_THEME_PROMPT_COLOR})"
                SCM_PROMPT="$(set_rgb_color ${SCM_THEME_FG_DIRTY_COLOR} ${SCM_THEME_PROMPT_UNTRACKED_COLOR})"
            
            # not clean
            else
                #SCM_PROMPT="$(set_rgb_color ${SCM_THEME_PROMPT_DIRTY_COLOR} ${SCM_THEME_PROMPT_COLOR})"
                SCM_PROMPT="$(set_rgb_color ${SCM_THEME_FG_DIRTY_COLOR} ${SCM_THEME_PROMPT_DIRTY_COLOR})"
            fi

        # git's clean
        else
            #SCM_PROMPT="$(set_rgb_color ${SCM_THEME_PROMPT_CLEAN_COLOR} ${SCM_THEME_PROMPT_COLOR})"
            SCM_PROMPT="$(set_rgb_color ${SCM_THEME_FG_CLEAN_COLOR} ${SCM_THEME_PROMPT_CLEAN_COLOR})"
        fi
        [[ "${SCM_GIT_CHAR}" == "${SCM_CHAR}" ]] && SCM_PROMPT+=" ${SCM_CHAR}${SCM_BRANCH}${SCM_STATE}${SCM_GIT_BEHIND}${SCM_GIT_AHEAD}${SCM_GIT_STASH}"
        #SCM_PROMPT="$(set_rgb_color ${LAST_THEME_COLOR} ${SCM_THEME_PROMPT_COLOR})${THEME_PROMPT_SEPARATOR}${normal}${SCM_PROMPT} ${normal}"
        SCM_PROMPT="$(set_rgb_color ${LAST_THEME_COLOR} ${SCM_THEME_PROMPT_COLOR})${normal}${SCM_PROMPT} ${normal}"
        LAST_THEME_COLOR=${SCM_THEME_PROMPT_COLOR}
    else
        SCM_PROMPT=""
    fi
}

# the part that shows the working directory
function powerline_cwd_prompt {
    #CWD_PROMPT="$(set_rgb_color ${LAST_THEME_COLOR} ${CWD_THEME_PROMPT_COLOR})${THEME_PROMPT_SEPARATOR}${normal}$(set_rgb_color - ${CWD_THEME_PROMPT_COLOR}) \w ${normal}$(set_rgb_color ${CWD_THEME_PROMPT_COLOR} -)${normal}"
    CWD_PROMPT="$(set_rgb_color ${LAST_THEME_COLOR} ${CWD_THEME_PROMPT_COLOR})${normal}$(set_rgb_color ${CWD_THEME_FG_COLOR} ${CWD_THEME_PROMPT_COLOR}) \w ${normal}$(set_rgb_color ${CWD_THEME_PROMPT_COLOR} -)${normal}"
    LAST_THEME_COLOR=${CWD_THEME_PROMPT_COLOR}
}

# the part before the prompt
function powerline_last_status_prompt {
    if [[ "$1" -eq 0 ]]; then
        LAST_STATUS_PROMPT="$(set_rgb_color ${LAST_THEME_COLOR} -)${THEME_PROMPT_SEPARATOR}${normal}"
    else
        LAST_STATUS_PROMPT="$(set_rgb_color ${LAST_THEME_COLOR} ${LAST_STATUS_THEME_PROMPT_COLOR})${THEME_PROMPT_SEPARATOR}${normal}$(set_rgb_color - ${LAST_STATUS_THEME_PROMPT_COLOR}) ${LAST_STATUS} ${normal}$(set_rgb_color ${LAST_STATUS_THEME_PROMPT_COLOR} -)${THEME_PROMPT_SEPARATOR}${normal}"
    fi
}

function powerline_prompt_command() {
    local LAST_STATUS="$?"

    powerline_shell_prompt
    powerline_virtualenv_prompt
    powerline_scm_prompt
    powerline_cwd_prompt
    powerline_last_status_prompt LAST_STATUS

    PS1="\n${SHELL_PROMPT}${VIRTUALENV_PROMPT}${SCM_PROMPT}${CWD_PROMPT}\n${LAST_STATUS_PROMPT} "

}

PROMPT_COMMAND=powerline_prompt_command
