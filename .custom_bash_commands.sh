#!/bin/bash
function g() {
  case $1 in
  help)
    echo available commands:
    echo pl = command: git pull origin \[currentBranch]
    echo ph = command: git push origin HEAD
    echo s = command: git status
    echo - = command: git checkout -
    echo c = command: git checkout \$2
    echo nb = command: git checkout -b \$2
  ;;

  pl)
    branch=$(git symbolic-ref --short HEAD)
    echo pulling branch: "$branch"
    git pull origin "$branch"
  ;;

  ph)
    branch=$(git symbolic-ref --short HEAD)
    echo pushing branch: "$branch"
    git push origin HEAD
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

  nb)
    git checkout -b "$2"
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
    # old working attempt
    # LC_CTYPE=C -> basically sets language type.
    # value=$(dd if=/dev/urandom count=1 2> /dev/null | uuencode -m - | sed -ne 2p | cut -c-"$length");
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

  *)
    echo  -- unknown command --
    echo _c help = more info
    ;;
  esac
}
