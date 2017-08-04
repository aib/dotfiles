#!/bin/bash

git log --format="%H %cI %aI %s" "$@"
