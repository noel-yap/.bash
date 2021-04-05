. ~/.bash/uname/$(uname).sh
. ~/.bashrc.$(hostname)

# aliases
alias baz=bazel
alias cd.='cd $(pwd)'
alias md='mkdir -p'
alias rd='rm -rf'
alias shred='shred -n 255 -u -z'

# functions
. ~/.bash/def.shlib

function cdg() {
    cd "$(git rev-parse --show-toplevel)"/"$1"
}

function cdw() {
    pushd .

    OLDCDPATH=${CDPATH}

    while [ ! -f .workspace -a "${PWD}" != "/" ]
    do
        cd .. >/dev/null 2>&1
    done

    if [ -f .workspace ]
    then
        CDPATH=${PWD}:${CDPATH}

        if [ -n "$1" ]
        then
            d=$1
        else
            d=-
        fi
    else
    	  d=~
    fi

    popd

    cd $d

    CDPATH=${OLDCDPATH}
}

function create-workspace() {
    for v in "$@"
    do
        case ${v} in
            --pr=*)
                pr=${v/--pr=/}
                ;;
            --repo=*)
                repo=${v/--repo=/}
                ;;
        esac
    done

    ~/bin/create-workspace "$@"

    case "${!#}" in
        --*=*)
            wd="${repo}.pr-${pr}"
            ;;
        *)
            wd="${!#}"
            ;;
    esac

    cd "${wd}/${repo}"
}

function manage-history() {
    if [ "$(history | tail -n 1 | awk '{ print $2 }')" = 'cd' ]
    then
        history -r "${HISTFILE}"
    else
        history -a
    fi
}

function mcd() {
    md "$@" && cd "$@"
}

function rmcd() {
    rd "$@" && mcd "$@"
}

function rmcd.() {
    local cwd=$(basename $(pwd))

    cd .. && rmcd "${cwd}"
}

function pd()
{
    if [ $# -eq 1 ]
    then
        pushd $*
    else
        popd
    fi
}

function pp()
{
    for file in $*
    do
        \mp -landscape -onesided -subject "${file}" <${file} | \mpage -1 -o -t
    done
}

function _ps1_root() {
    local ps1_root="\u:$(id -gn)@\h:\w"

    local rev_spec=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ "${rev_spec}" == 'HEAD' ]
    then
        rev_spec=$(git describe --tags 2>/dev/null)
    fi
    if [ "${rev_spec}" == 'HEAD' -o -z "${rev_spec}" ]
    then
        rev_spec=$(git rev-parse HEAD 2>/dev/null | sed -e 's|^\([0-9a-f]\{8\}\).*|\1|')
    fi

    if [ -n "${rev_spec}" ]
    then
        ps1_root="${ps1_root}ᚴ${rev_spec}"
    fi

    if [ -n "${CLUSTER}" ]
    then
        ps1_root="${ps1_root}ᛝ${CLUSTER}"
    fi

    echo "${ps1_root}"
}

if [ "${TERM}" = 'screen' -o "${TERM:0:5}" = 'xterm' ]
then
    function prompt-command() {
        manage-history

        local ps1_root="$(_ps1_root)"
        export PS1="${ps1_root}> \[\e]0;${ps1_root}\a\]"
    }
else
    function prompt-command() {
        manage-history

        local ps1_root="$(_ps1_root)"
        export PS1="${ps1_root}> "
    }
fi

function sd()
{
    export DISPLAY=`who -m | sed -e 's|.*(||' -e 's|).*||'`:0.0
}

tbunzip()
{
    bunzip2 --stdout "$@" | tar xfpv -
}

tbzip()
{
    file=$1
    shift

    tar cfpv - "$@" | bzip2 > $file
}

tgunzip()
{
    gzip -cdq "$@" | tar xfpv -
}

tgzip()
{
    file=$1
    shift

    tar cfpv - "$@" | gzip -f - > $file
}

# ulimit
ulimit -c unlimited

# umask
umask 0027

export CDPATH=.:~:~/tasks

export EDITOR=vi

export HISTCONTROL=ignoredups
export HISTIGNORE="&"
export HISTSIZE=256
export HISTFILESIZE=65536

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=~/bin:${PATH}

export PROMPT_COMMAND="prompt-command"
export PS2="  "

if [ -z "${DISPLAY}" ]
then
  sd
fi

# direnv
function direnv-reset-def() {
  eval "${DIRENV_RESET_DEF}"
}

function direnv-set-def() {
  eval "${DIRENV_SET_DEF}"
}

eval "$(direnv hook bash)"
