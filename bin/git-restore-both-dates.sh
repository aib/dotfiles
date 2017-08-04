#!/bin/bash

backup_file="$1"
shift

git filter-branch --env-filter "export GIT_COMMITTER_DATE=\$(grep -F -m 1 \"\$(git log -n 1 --format=\"%aI %s\" \$GIT_COMMIT)\" "$backup_file" | cut -d\" \" -f2); export GIT_AUTHOR_DATE=\$(grep -F -m 1 \"\$(git log -n 1 --format=\"%aI %s\" \$GIT_COMMIT)\" "$backup_file" | cut -d\" \" -f2)" "$@"
