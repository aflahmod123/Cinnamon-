#!/bin/bash

# Define the directory to store the committed files
commit_dir="committed_files"

# Create the directory if it doesn't exist
mkdir -p "$commit_dir"

# Get the current date and time to create a unique folder name
timestamp=$(date +"%Y%m%d_%H%M%S")
commit_folder="$commit_dir/$timestamp"

echo "Creating commit folder: $commit_folder"

# Create a new folder for this commit
mkdir "$commit_folder"

# Create a .gitattributes file (optional: add attributes as needed)
touch "$commit_folder/.gitattributes"

# Move all files from the current directory to the commit folder
echo "Moving files to commit folder..."

# Loop through each item in the current directory
for item in *; do
    # Check if the item is a regular file (not a directory)
    if [ -f "$item" ]; then
        mv "$item" "$commit_folder/"
        echo "Moved $item to $commit_folder/"
    fi
done

# Always add the commit folder for commit
git add "$commit_folder"

# Commit the changes
git commit -m "Auto commit at $timestamp"

# Stash any unstaged changes before pulling and pushing
git stash push -m "Stashing unstaged changes for auto commit"

# Attempt to pull changes from the main branch of the remote repository
echo "Pulling changes from the main branch on GitHub..."
git pull --rebase https://github.com/aflahmod123/Cinnamon-.git main

if [ $? -eq 0 ]; then
    # Successfully rebased, now push to main branch
    git push https://github.com/aflahmod123/Cinnamon-.git main
    echo "Files committed and pushed to the main branch on GitHub"

    # Optionally, remove the committed files folder after successful push
    echo "Cleaning up..."
    rm -rf "$commit_folder"
    echo "Committed files removed from $commit_folder"

    # Apply stashed changes back to working directory
    git stash pop
else
    # Rebase failed due to conflicts, inform user
    echo "Failed to push changes due to conflicts. Resolve conflicts manually."
    # Restore stashed changes to working directory
    git stash apply stash@{0}
fi
sleep 5d