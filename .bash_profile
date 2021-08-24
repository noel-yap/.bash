function trigger-on-screen-lock-state-change() {
  nohup gdbus monitor -y -d org.freedesktop.login1 |
     grep --line-buffered "org\.freedesktop\.DBus\.Properties\.PropertiesChanged.*'org\.freedesktop\.login1\.Session'.*'LockedHint'" |
     tee /dev/tty |
     sed -E "s/^.*\{'LockedHint': <(true|false)>\}.*$/\1/" |
     while read state
     do
       case "${state}" in
         true)
           on-screen-lock
           ;;
         false)
           if xrandr --listactivemonitors | grep -E '^ *[0-9]+' | cut -d ' ' -f 6 | grep -q HDMI-1
           then
             ~/.screenlayout/home.sh # generated with arandr
           fi
           ;;
       esac
     done 2>&1 | tee ~/tmp/trigger-on-screen-lock-state-change.out &
}

function on-screen-lock() {
  true
}

function on-screen-unlock() {
  set-resolution
}

function set-resolution() {
  if xrandr --listactivemonitors | grep -E '^ *[0-9]+' | cut -d ' ' -f 6 | grep -q HDMI-1
  then
    ~/.screenlayout/home.sh # generated with arandr
  fi
}

trigger-on-screen-lock-state-change

gnome-terminal -- "${HOME}/bin/ovpn"

. ~/.bashrc
