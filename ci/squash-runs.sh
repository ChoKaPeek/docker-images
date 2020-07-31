#!/bin/bash
# By ChoKaPeek <amael.tardif@epita.fr>
# The objective here is to squash docker images. Merging commands saves space.
# No magic here, this script only merges adjacent RUN commands.

[ "$1" ] || {
  echo "Usage: ./squash-runs.sh PATH_TO_DOCKERFILE" && exit 1
}
[ -d "$1" ] || {
  echo "Error: A directory is expected"
  echo "Usage: ./squash-runs.sh PATH_TO_DOCKERFILE" && exit 1
}

path=$1/Dockerfile
out=$1/Dockerfile_squash
keywords="COPY|ARG|FROM|ENV|WORKDIR|ENTRYPOINT|CMD"
in_run=0

write() {
  echo "$1 \\" >> $out
}

rm -f $out

while IFS=$'\n' read line; do
  trimmed=$(echo "$line" | awk '{$1=$1};1')
  if [[ "${trimmed%% *}" =~ ^RUN$ ]]; then
    if [ $in_run -eq 1 ]; then
      write " && ${trimmed#* }"
    else
      write "$trimmed"
      in_run=1
    fi
  else
    if [ $in_run -eq 1 ]; then
      if [[ "${trimmed%% *}" =~ ^($keywords)$ ]]; then
        echo "" >> $out
        echo "" >> $out
        echo "$trimmed" >> $out
        in_run=0
      else
        ! [[ "$trimmed" =~ ^#.*$ ]] && write "$trimmed"
      fi
    else
      echo "$trimmed" >> $out
    fi
  fi
done < $path
echo "" >> $out
