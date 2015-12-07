# A shell script which when run updates git
# Usage: gitUpdate

#!/bin/bash
git pull
git add -A
read -p "Please enter the commit message: " commit_message 
echo "Commit message is - `$commit_message`."
git commit -m $commit_message
git push -u origin master
