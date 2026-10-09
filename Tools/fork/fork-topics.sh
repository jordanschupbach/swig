#!/bin/sh
# List, inspect and export the change topics of this SWIG fork.
#
# A topic is the set of non merge commits in $FORK_BASE..HEAD (default upstream/master..HEAD)
# whose message carries a "Fork-Topic: <slug>" trailer. See FORK.md and .agents/skills/swig-fork/SKILL.md.

set -e

base=${FORK_BASE:-upstream/master}

usage() {
  cat <<EOF
Usage: $0 <command> [args]

  list                   topics with commit counts
  log <topic>            commits in a topic, oldest first
  show <topic>           full patches of a topic, oldest first
  export <topic> [dir]   write a git format-patch series (default: .git/fork-patches/<topic>)
  check                  list commits missing a Fork-Topic: trailer, exit 1 if any

Commits are taken from \$FORK_BASE..HEAD, currently $base..HEAD.
EOF
  exit 2
}

# Print "<hash> <topic>" for every non merge commit since the base, oldest first. Topic is empty if missing.
commits() {
  git log --no-merges --reverse --format='%H %(trailers:key=Fork-Topic,valueonly,separator=%x2C)' "$base..HEAD"
}

topic_commits() {
  commits | awk -v t="$1" '$2 == t { print $1 }'
}

need_topic() {
  [ -n "$1" ] || usage
  hashes=$(topic_commits "$1")
  if [ -z "$hashes" ]; then
    echo "No commits found for topic '$1' in $base..HEAD" >&2
    exit 1
  fi
}

git rev-parse --verify --quiet "$base" >/dev/null || { echo "Base '$base' not found; run 'git fetch upstream' or set FORK_BASE" >&2; exit 1; }

case "$1" in
  list)
    commits | awk '{ t = ($2 == "") ? "(none)" : $2; n[t]++ } END { for (t in n) printf "%5d  %s\n", n[t], t }' | sort -k2
    ;;
  log)
    need_topic "$2"
    for h in $hashes; do git log -1 --format='%h %ad %s' --date=short "$h"; done
    ;;
  show)
    need_topic "$2"
    for h in $hashes; do git show --stat --patch "$h"; done
    ;;
  export)
    need_topic "$2"
    dir=${3:-$(git rev-parse --git-dir)/fork-patches/$2}
    mkdir -p "$dir"
    rm -f "$dir"/*.patch
    total=$(echo "$hashes" | wc -l | tr -d ' ')
    n=1
    for h in $hashes; do
      if [ "$total" -gt 1 ]; then
        git format-patch --quiet -o "$dir" --start-number "$n" --subject-prefix="PATCH $n/$total" -1 "$h"
      else
        git format-patch --quiet -o "$dir" -1 "$h"
      fi
      n=$((n + 1))
    done
    echo "Wrote $total patch(es) to $dir"
    ;;
  check)
    missing=$(commits | awk '$2 == "" { print $1 }')
    if [ -n "$missing" ]; then
      echo "Commits missing a Fork-Topic: trailer:" >&2
      for h in $missing; do git log -1 --format='  %h %s' "$h" >&2; done
      exit 1
    fi
    echo "All commits in $base..HEAD carry a Fork-Topic: trailer"
    ;;
  *)
    usage
    ;;
esac
