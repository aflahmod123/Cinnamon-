#!/bin/bash

# directory
commit_dir="committed_files"

# Version control variant easier with timestamps
timestamp=$(date +"%H, %M, %S, %m/%d/%Y")
commit_folder="$commit_dir/$timestamp"


mkdir -p "$commit_folder"

shopt -s extglob
for dir in */; do
    if [[ $dir != "committed_files/" && $dir != "exclude_dir/" ]]; then
        cp -r "$dir" "$commit_folder"
    fi
done

cd "$commit_folder" || { echo "unable to change directory to $commit_folder"; exit 1; }

if git status --porcelain | grep .; then
    git add .

    # Comingt the changes at the gvie n timepsatm
    git commit -m " committed at $timestamp"

    git stash push -m "stashing the unstaged changes for auto commit"

    
    echo "pulling any changes from github"
    git pull --rebase https://github.com/aflahmod123/Cinnamon-.git main

    if [ $? -eq 0 ]; then
        # rebased so can continue
        git push https://github.com/aflahmod123/Cinnamon-.git main
        echo "files have been commited and pushed to the main folder"

        # Gotta remove the stuff because less anoy
        echo "cleaning up the local files"
        cd ../..
        rm -rf "$commit_folder"
        echo "the commited fiels have been removed from the drive"

        git stash pop
    else
        # Rebase failed so give error yes
        echo "failed to pus ht the changes fix it yourself"
        # Restore stashed changes to working directory
        git stash apply stash@{0}
    fi
else
    echo "no changes to commit"
    cd ../..
    rm -rf "$commit_folder"
    echo "removed the empty folder"
fi

# Pause for 50 seconds before script completes so can locate errors
sleep 50
