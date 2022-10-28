alias cbcopy='xclip -selection clipboard'
alias ls='ls -AbF --color --time-style="+%Y-%m-%dT%H:%M:%S"'

export JAVA_HOME=/usr/lib/jvm/java-14-openjdk-amd64

export HOMEBREW_PREFIX="${HOME}/.linuxbrew";
export HOMEBREW_CELLAR="${HOME}/.linuxbrew/Cellar";
export HOMEBREW_REPOSITORY="${HOME}/.linuxbrew/Homebrew";
export PATH="${HOME}/.linuxbrew/bin:${HOME}/.linuxbrew/sbin${PATH+:$PATH}";
export MANPATH="${HOME}/.linuxbrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="${HOME}/.linuxbrew/share/info:${INFOPATH:-}";
