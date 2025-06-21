#!/bin/bash
function g() {
  case $1 in
  help)
    echo available commands:
    # echo pl = command: git pull origin \[currentBranch]
    # echo ph = command: git push origin HEAD
    echo pl = command: git pull
    echo ph = command: git push
    echo s = command: git status
    echo - = command: git checkout -
    echo c = command: git checkout \$2
    echo nb = command: git checkout -b \$2
    echo b = command: git branch \-\-sort=-committerdate
    echo st = command: git stash list
    echo st_ = command: git stash pop stash@{\$2}
    echo st__ = command: git stash pop stash@{\0}
    echo . = command: git add .
    echo cm = command: git commit -m \$2
  ;;

  # pl)
  #   branch=$(git symbolic-ref --short HEAD)
  #   echo pulling branch: "$branch"
  #   git pull origin "$branch"
  # ;;

  # ph)
  #   branch=$(git symbolic-ref --short HEAD)
  #   echo pushing branch: "$branch"
  #   git push origin HEAD
  # ;;

  pl)
    branch=$(git symbolic-ref --short HEAD)
    echo Pulling branch: "$branch"
    git pull
  ;;

  ph)
    branch=$(git symbolic-ref --short HEAD)
    echo Pushing branch: "$branch"
    git push
  ;;

  s)
    git status
  ;;

  -)
    git checkout -
  ;;

  c)
    git checkout "$2"
  ;;

  b)
    git branch --sort=-committerdate
  ;;

  nb)
    git checkout -b "$2"
  ;;

  st)
    git stash list
  ;;

  st_)
    git stash pop stash@{"$2"}
  ;;

  st__)
    git stash pop stash@{0}
  ;;

  .)
    git add .
  ;;

  cm)
    message=$2
    git commit -m "$message"
  ;;

  *)
    echo  -- unknown command --
  ;;
  esac
}

function _c() {
  case $1 in
  help)
    echo available commands:
    echo res = restarts .custom_bash_commands.sh for terminal instance.
    echo po = generates PO to clipboard. Default length "10", accepts requested length.
    echo id = generates an id to clipboard. Default length "25", accepts requested length.
    echo pass = generates a password to clipboard. Default length "25", accepts requested length.
    echo pin = generates a pin to clipboard. Default length "4", accepts requested length.
    echo api_ = opens api in vscode
    echo ui_ = opens ui in vscode OLD - DOES NOT EXIST. Left as example.
    echo vsc = opens a given folder or file in vscode
    ;;

  res)
    echo ...restarting .custom_bash_commands.sh
    # shellcheck disable=SC1090
    source ~/.custom_bash_commands.sh
  ;;

  po)
    number=5
    if [ "$2" != "" ]
    then
      number=$(($2 / 2))
    fi
    idVariable=$(openssl rand -hex "$number" | tr "[:lower:]" "[:upper:]")
    echo "$idVariable" | pbcopy
    echo copied to clipboard: "$idVariable"
  ;;

  id)
    length=25
    if [ "$2" != "" ]
    then
      length="$2"
    fi
    value=$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c "$length" ; echo);
    echo "$value" | pbcopy
    echo copied to clipboard: "$value"
  ;;

  pass)
    length=25
    if [ "$2" != "" ]
    then
      length="$2"
    fi
    value=$(LC_ALL=C tr -dc 'A-Za-z0-9!#$%()£+,-./:;<=>?@[\]_{|}~' </dev/urandom | head -c "$length" ; echo);
    echo "$value" | pbcopy
    echo copied to clipboard: "$value"
  ;;

  pin)
    length=4
    if [ "$2" != "" ]
    then
      length="$2"
    fi
    value=$(LC_ALL=C tr -dc '0-9' </dev/urandom | head -c "$length" ; echo);
    echo "$value" | pbcopy
    echo copied to clipboard: "$value"
  ;;

  jq)
    # requires json wrapped with literals '{}'
    echo "$2" | jq
  ;;

  perc)
    if [ "$2" == help ]
    then
      echo available commands:
      echo wi = 'what is "$3"% of "$4"?'
      echo wp = '"$3" is what % of "$4"?'
      echo pw = '"$3" is "$4"% of what?'
    elif [ "$3" != "" ] && [ "$4" != "" ]
    then
      case $2 in
      wi)
        res=$(awk "BEGIN {x=$3/100; z=x*$4; print z}")
        echo "$3"% of "$4" = "$(printf %.0f "$res")"
      ;;

      wp)
        res=$(awk "BEGIN {x=$3/$4; z=x*100; print z}")
        echo "$3" is "$(printf %.0f "$res")"% of "$4"
        echo "result to 3 decimal places:" "$(printf %.3f "$res")"%
      ;;

      pw)
        res=$(awk "BEGIN {x=$4/100; z=$3/x; print z}")
        echo "$3" is "$4"% of "$(printf %.0f "$res")"
        echo "result to 3 decimal places:" "$(printf %.3f "$res")"
      ;;

      *)
        echo -- invalid perc command --
        echo _c perc help = more info
      ;;
      esac
    else
      echo expecting perc '[command]' followed by "2" conditions, eg _c perc wi "10" "50"
      echo _c perc help = more info
    fi
  ;;

  # Example of setting up cmd to open common project
  ui_)
    open -a "Visual Studio Code" ~/Documents/m/mezze-ui
  ;;

  vsc)
    open -a "Visual Studio Code" "$2"
  ;;

  *)
    echo  -- unknown command --
    echo _c help = more info
    ;;
  esac
}
