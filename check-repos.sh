#!/bin/bash

REPO_DIR="$1"

if [ -z "$REPO_DIR" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

if [ ! -d "$REPO_DIR" ]; then
    echo "Error: Directory '$REPO_DIR' does not exist."
    exit 1
fi

repos_with_changes=()

# Iterate through all subdirectories
for dir in "$REPO_DIR"/*; do
    # Check if it's a directory
    if [ -d "$dir" ]; then
        # Check if it's a Git repository
        if [ -d "$dir/.git" ]; then
            cd "$dir" || continue
            # Check for uncommitted changes
            if [ -n "$(git status --porcelain)" ]; then
                repos_with_changes+=("$(basename "$dir")")
                changes=$(git -c color.ui=always status --short)
                repos_with_changes+=("$changes")
            fi
            # Go back to the original directory
            cd - > /dev/null
        else
            echo "Skipping non-Git directory: $(basename "$dir")"
        fi
    fi
done

if [ ${#repos_with_changes[@]} -gt 0 ]; then
    echo -e "\nRepositories with uncommitted changes:"
    for ((i = 0; i < ${#repos_with_changes[@]}; i += 2)); do
        repo_name="${repos_with_changes[$i]}"
        repo_changes="${repos_with_changes[$i + 1]}"
        echo -e "\nRepository: $repo_name"
        echo "Changes:"
        echo -e "$repo_changes"
    done
else
    echo -e "\nNo repositories with uncommitted changes found."
fi
