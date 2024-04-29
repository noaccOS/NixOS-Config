#!/bin/sh

YEAR=$(date +%Y)

find_parent_branch () {
  git show-branch -a \
    | rg '\*' \
    | rg -v $(git rev-parse --abbrev-ref HEAD) \
    | head -n1 \
    | sd '.*\[(.*)\].*' '$1' \
    | sd '[\^~].*' ''
}

commit_list () {
  local parent="$1"

  git log --oneline "$parent".. | cut -d' ' -f1 | tac
}

fix_copyright () {
  local commit="$1"
  local holder="$2"

  files=()
  for git_file in $(git -C "$base_dir" diff-tree --no-commit-id --name-only -r "$commit"); do
    files+=("$base_dir/$git_file")
  done

  # Copyright notation
  sd '^(\S*\s*Copyright\s+\d+).*$' "\$1-$YEAR $holder" $files
  sd "^(\S*\s*Copyright\s+)$YEAR-($YEAR $holder)\$" '$1$2' $files

  # SPDX notation
  sd '(SPDX-FileCopyrightText:\s*\d+).*' "\$1-$YEAR $holder" $files
  sd "(SPDX-FileCopyrightText:\s*)$YEAR-($YEAR $holder)" '$1$2' $files
}

run () {
  local base_ref="$1"
  local base_dir="$2"
  local holder="$3"
  
  git stash --all

  for commit in $(commit_list "$base_ref"); do
    fix_copyright "$commit" "$holder"
    git diff --exit-code || git commit -a --fixup "$commit"
  done

  git stash pop
}

while [ $# -gt 0 ]; do
  case $1 in
    -b|--base)
      BASE="$2"
      shift
      shift
      ;;
    -d|--dir)
      DIR="$2"
      shift
      shift
      ;;
    -H|--holder)
      HOLDER="$2"
      shift
      shift
      ;;
    -h|--help)
      echo "Usage: $0 [options]"
      echo "  -b  --base    Base reference (default: parent branch)"
      echo "  -d  --dir     Directory of the git repository (default: .)"
      echo "  -H  --holder  Copyright holder (default: 'SECO Mind Srl')"
      echo "  -h  --help    Print this text and exit"
      exit 0
      ;;
    *)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

test -z $BASE && BASE=$(find_parent_branch)
test -z $HOLDER && HOLDER="SECO Mind Srl"
test -z $DIR && DIR=.

run "$BASE" "$DIR" "$HOLDER"
