# Resolve conflicts in commit.sh and any other conflicted files manually
# Use 'git add' to mark each resolved file
git add commit.sh  # Replace commit.sh with your conflicted file names

# Commit the resolved changes
git commit -m "Resolved conflicts in commit.sh"

# Attempt to pull changes from the main branch of the remote repository again
git pull --rebase https://github.com/aflahmod123/Cinnamon-.git main

# If pull is successful, push the changes to the remote repository
git push https://github.com/aflahmod123/Cinnamon-.git main

sleep 50