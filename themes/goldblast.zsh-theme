#----
# Goldblast zsh theme by Stephen Tramer (sptramer@gmail.com)
# Looks best with Solarized (http://ethanschoonover.com/solarized)
# and requires that your terminal is UTF-8 capable.
#
# Hat tip to Steve Losh's excellent zsh blog post for some info
# (http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/)
#
#----

# Get the status of the working tree (copied from sunrise theme)

svc_prompt_status() {
    if [[ GB_GIT_ENABLED ]]; then
        git branch > /dev/null 2>/dev/null && custom_git_prompt_status && return
    fi
    if [[ GB_HG_ENABLED ]]; then
        hg root > /dev/null 2>/dev/null && custom_hg_prompt_status && return
    fi

    echo "" && return
}

custom_hg_prompt_status() {
    INDEX=$(hg status)
    STATUS=""

    if $(echo "$INDEX" | grep '^A' &>/dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_ADDED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^M' &>/dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_MODIFIED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^R' &>/dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_DELETED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^!' &>/dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^?' &>/dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
    fi

    echo $STATUS
}

# copied from sunrise theme
gbl_git_prompt_status() {
    INDEX=$(command git status --porcelain 2> /dev/null)
    STATUS=""
    # Non-staged
    if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^.M ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    fi
    # Staged
    if $(echo "$INDEX" | grep '^D  ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_DELETED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^R' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_RENAMED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^M' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_MODIFIED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^A' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_STAGED_ADDED$STATUS"
    fi
    if $(echo -n "$STATUS" | grep '.*' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_STATUS_PREFIX$STATUS"
    fi

    echo $STATUS
}

parse_hg_dirty() {
    if [[ -n $(hg status 2>/dev/null) ]] ; then
        echo $ZSH_THEME_GIT_PRIMPT_DIRTY
    else
        echo $ZSH_THEME_GIT_PROMPT_CLEAN
    fi
}

parse_svc_dirty() {
    git branch >/dev/null 2>/dev/null && parse_git_dirty && return
    hg root >/dev/null 2>/dev/null && parse_hg_dirty && return

    echo ''
}

repo_symbol() {
    if [[ -n $(command git status 2>/dev/null >/dev/null) ]]; then
        echo %{$reset_color%}%{$fg[red]%}git%{$reset_color%}@%{$fg[cyan]%}\[`git rev-parse --abbrev-ref HEAD`:`git rev-parse --short HEAD`\]%{$reset_color%}
    elif [[ -n $(command hg status 2>/dev/null >/dev/null) ]]; then
        echo %{$reset_color%}%{$fg[red]%}hg%{$reset_color%}@%{$fg[cyan]%}\[`hg branch`:`hg identify --num`\]%{$reset_color%}
    fi
}

gbl_git_prompt_info() {
    ref=$(command git rev-parse --short HEAD 2> /dev/null) && \
        ref="$(command git symbolic-ref HEAD 2> /dev/null):$ref" || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Prefix/suffix
ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[red]%}git%{$reset_color%}@[%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"

# Generic svc prompt, set to _GIT_ vars for parse_git_dirty
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}∅"
ZSH_THEME_GIT_PROMPT_DIRTY=""

# Staged
ZSH_THEME_GIT_PROMPT_STAGED_ADDED="%{$fg[green]%}✓"
ZSH_THEME_GIT_PROMPT_STAGED_MODIFIED="%{$fg[green]%}∃"
ZSH_THEME_GIT_PROMPT_STAGED_RENAMED="%{$fg[green]%}➛"
ZSH_THEME_GIT_PROMPT_STAGED_DELETED="%{$fg[red]%}✗"

# Not-staged
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%}?"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[green]%}∃"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}✗"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}⟘"

# Remote
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="${fg[red]%}⇓"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="${fg[green]%}⇑"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="${fg_bold[red]%}≠"

PROMPT='%{$fg_bold[cyan]%}%n@%m %{$fg_bold[magenta]%}%D{[%I:%M]} %{$reset_color%}in %{$fg_bold[white]%}[%~]
%{$fg[green]%}$(gbl_git_prompt_info) $(git_remote_status)$(parse_git_dirty)%{$reset_color%}%{$fg[yellow]%} ⤅ %{$reset_color%}$(gbl_git_prompt_status) %{$fg[blue]%}%#%{$reset_color%} '
RPROMPT=''
