#!/bin/sh
# Remove tags matching a given pattern,
# both locally and at origin

yes=0
pattern=$1

[ "$1" ] || {
  echo "Usage: remove-tags.sh [-y] pattern" && exit 1
}

if [ "$2" ]; then
  yes=1
  if [[ "$1" == "-y" ]]; then
    pattern=$2
  else
    [[ "$2" != "-y" ]] && {
      echo "Usage: remove-tags.sh [-y] pattern" && exit 1
    }
  fi
else
  [[ "$1" == "-y" ]] && {
    echo "Usage: remove-tags.sh [-y] pattern" && exit 1
  }
fi

from_dir () {
  for file in "$@"; do
    if [ -f "$file" ]; then
      if [[ "$file" == *$pattern* ]]; then
        if [ $yes -eq 1 ]; then
          remove "$file"
        else
          read -p "delete $file? [enter]" -n 1 -r
          if [[ $REPLY =~ ^$ ]]; then
            remove "$file"
          fi
        fi
      fi
    else
      from_dir $(echo "$file"/*)
    fi
  done
}

remove () {
  echo deleting $1...
  git push origin :${1#*/} # remove .git/
  # 4-20 -> 20 is quickfix to get everything after the third occurrence
  # remove .git/refs/tags/
  git tag -d $(cut -d/ -f 4-20 <<< "$1")
}

from_dir $(echo .git/refs/tags/*)
