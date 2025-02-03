#!/bin/env bash

# Directory containing your repositories
REPO_DIR=~/Repositories

# Change to the directory containing your repositories
cd "$REPO_DIR" || exit

# Iterate through each directory in the REPO_DIR
for repo in */; do
  # Check if the directory is a Git repository
  if [ -d "$repo/.git" ]; then
    
    # Change to the repository directory
    cd "$repo" || continue
    
    # Check for uncommitted changes
    if [ -n "$(git status --porcelain)" ]; then
      echo "  Uncommitted changes found in $repo"
    fi
    
    # Change back to the parent directory
    cd ..
  else
    echo "$repo is not a Git repository"
  fi
done
