alias ls='ls --color --time-style='+%Y-%m-%dT%H:%M:%S' -AbF'

# homebrew
export HOMEBREW_PREFIX='/home/nyap/.linuxbrew'
export HOMEBREW_CELLAR='/home/nyap/.linuxbrew/Cellar'
export HOMEBREW_REPOSITORY='/home/nyap/.linuxbrew/Homebrew'
export MANPATH="${MANPATH}:/home/nyap/.linuxbrew/share/man"
export INFOPATH="${INFOPATH}:/home/nyap/.linuxbrew/share/info"

export JAVA_HOME=/usr/lib/jvm/jdk-14

export PATH=${PATH}:${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin

