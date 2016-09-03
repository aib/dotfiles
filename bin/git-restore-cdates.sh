#!/bin/bash

git filter-branch --env-filter "export GIT_COMMITTER_DATE=\$(grep -F -m 1 \"\$(git log -n 1 --format=\"%aI %s\" \$GIT_COMMIT)\" $1 | cut -d\" \" -f2)"
