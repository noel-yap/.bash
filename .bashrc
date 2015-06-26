shopt -s globstar

# aliases
alias ls='ls -AbF'
alias md='mkdir -p'
alias rd='rm -rf'

# functions
function cdg()
{
    cd "$(git rev-parse --show-toplevel)"
}

function cdw()
{
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
    fi

    popd

    cd $d

    CDPATH=${OLDCDPATH}
}

create-family-workspace() {
    if [[ "$1" == --type=* ]]
    then
        task="$2"
    else
        task="$1"
    fi

    ~/bin/create-family-workspace "$@" && cd "${task}/family"
}

create-workspace() {
    for v in "$@"
    do
        case ${v} in
            --repo=*)
                repo=${v/--repo=/}
                ;;
        esac
    done

    ~/bin/create-workspace "$@"
    cd "${!#}/${repo}"
}

e()
{
    emacs -g 120x50 "$@" &
}

function export-workspace() {
    export WORKSPACE="$(cdw >/dev/null; pwd)"
    export NEBULA_HOME="$(\ls {"$(git rev-parse --show-toplevel 2>/dev/null)",${WORKSPACE}/wrapper}/gradlew 2>/dev/null | head -n 1 | xargs dirname 2>/dev/null | sed -e 's|/$||')"
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

if [ "$TERM" = "screen" -o "$TERM" = "xterm" ]
then
    function prompt-command() {
        export-workspace
        local ps1_root="\u:$(id -gn)@\h:\w|$(git branch 2>/dev/null | grep "^\*" | cut -d " " -f 2)"
        export PS1="${ps1_root}> \[\e]0;${ps1_root}\a\]"
    }
else
    function prompt-command() {
        export-workspace
        export PS1="\u:$(id -gn)@\h:\w|$(git branch 2>/dev/null | grep "^\*" | cut -d " " -f 2)> "
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
umask 0022

export CDPATH=.:~:~/proj

export EDITOR=vi

export HISTCONTROL=ignoredups
export HISTIGNORE="&"

export JAVA_HOME=/opt/jdk1.7

export PATH=~/bin:/usr/local/git/bin:${PATH}
export PATH=${PATH}:${JAVA_HOME}/bin

export PROMPT_COMMAND="prompt-command"
export PS2="  "

if [ -z "${DISPLAY}" ]
then
  sd
fi
