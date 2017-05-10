#!/bin/bash

git log --all --format="%H %cI %aI %s" "${1:-HEAD}"
