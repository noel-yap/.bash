# aliases
alias baz=bazel
alias cd.='cd $(pwd)'
alias cdt='cd tasks'
alias md='mkdir -p'
alias rd='rm -rf'
alias shred='shred -n 255 -u -z'

# functions
. ~/.bash/def.shlib

function cbcopy-git-log() {
  git log -1 --pretty=%B | sed -ne '/^Summary:/,$ p' | sed -e '$d' | pbcopy
}

function cdr() {
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
export HISTFILESIZE=16384

export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

PATH="${HOME}/bin":/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

if [ -z "${DISPLAY}" ]
then
  sd
fi

. ~/.bash/uname/$(uname).sh
. ~/.bashrc.$(hostname) 2>/dev/null

# direnv
function direnv-reset-def() {
  eval "${DIRENV_RESET_DEF}"
}

function direnv-set-def() {
  eval "${DIRENV_SET_DEF}"
}

eval "$(direnv hook bash)"

. ~/.bash/prompt.shlib
