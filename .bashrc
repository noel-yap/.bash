. ~/.bash/uname/$(uname).sh

# aliases
alias cd.='cd $(pwd)'
alias md='mkdir -p'
alias rd='rm -rf'
alias shred='shred -n 255 -u -z'

# functions
function cdb() {
    pushd .

    OLDCDPATH=${CDPATH}

    while [ ! -f settings.gradle -a "${PWD}" != "/" ]
    do
        cd .. >/dev/null 2>&1
    done

    if [ -f settings.gradle ]
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

function cdg() {
    cd "$(git rev-parse --show-toplevel)"
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

function export-workspace() {
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
    then
        alias wp="$(git rev-parse --show-toplevel)/node_modules/.bin/webpack"
    fi

    export WORKSPACE="$(cdw >/dev/null; pwd)"

    export GOPATH="${WORKSPACE}/go"
    export HISTFILE="${WORKSPACE}/.bash_history"
    export GRADLE_USER_HOME="${WORKSPACE}/.gradle"
    export M2_REPO="${WORKSPACE}/.m2"
    export NEBULA_HOME="$(realpath $(\ls -U {.,$(git rev-parse --show-toplevel 2>/dev/null),${WORKSPACE}/nebula/wrapper}/gradlew 2>/dev/null | head -n 1 | xargs dirname 2>/dev/null | sed -e 's|/$||') 2>/dev/null)"

    if [ "$(history | tail -n 1 | awk '{ print $2 }')" = 'cd' ]
    then
        history -r ${HISTFILE}
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
    local rev_spec=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ "${rev_spec}" == 'HEAD' ]
    then
        rev_spec=$(git describe --tags 2>/dev/null)
    fi
    if [ "${rev_spec}" == 'HEAD' -o -z "${rev_spec}" ]
    then
        rev_spec=$(git rev-parse HEAD 2>/dev/null | sed -e 's|^\([0-9a-f]\{8\}\).*|\1|')
    fi

    if [ -z "${rev_spec}" ]
    then
        echo "\u:$(id -gn)@\h:\w"
    else
        echo "\u:$(id -gn)@\h:\w|${rev_spec}"
    fi
}

if [ "${TERM}" = 'screen' -o "${TERM:0:5}" = 'xterm' ]
then
    function prompt-command() {
        export-workspace
        export PS1="$(_ps1_root)> \[\e]0;$(_ps1_root)\a\]"
    }
else
    function prompt-command() {
        export-workspace
        export PS1="$(_ps1_root)> "
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

# homebrew
export HOMEBREW_PREFIX='/home/nyap/.linuxbrew'
export HOMEBREW_CELLAR='/home/nyap/.linuxbrew/Cellar'
export HOMEBREW_REPOSITORY='/home/nyap/.linuxbrew/Homebrew'
export MANPATH="${MANPATH}:/home/nyap/.linuxbrew/share/man"
export INFOPATH="${INFOPATH}:/home/nyap/.linuxbrew/share/info"

# protop
export PROTOP_HOME=${HOMEBREW_PREFIX}

export CDPATH=.:~:~/tasks

export EDITOR=vi

export HISTCONTROL=ignoredups
export HISTIGNORE="&"
export HISTSIZE=256
export HISTFILESIZE=65536

export PATH=~/bin:${PATH}
export PATH=${PATH}:${JAVA_HOME}/bin
export PATH=${PATH}:${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin

export PROMPT_COMMAND="prompt-command"
export PS2="  "

if [ -z "${DISPLAY}" ]
then
  sd
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
