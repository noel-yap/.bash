alias cbcopy=pbcopy
alias ktl=kubectl
alias ls='ls -AbF --color -D "%Y-%m-%dT%H:%M:%S"'

idea() {
  open -na '/Applications/IntelliJ IDEA.app' --args "$@"
}
export -f idea

export ANDROID_HOME="${HOME}/Library/Android/sdk"

export BASH_SILENCE_DEPRECATION_WARNING=1

export CPPFLAGS="-I/opt/homebrew/opt/openjdk@21/include"

export JAVA_HOME="${HOME}/lib/jdk-24.0.2.jdk/Contents/Home"

export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:/opt/homebrew/opt/openjdk@21/bin:"${PATH}"
