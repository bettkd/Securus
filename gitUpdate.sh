# A shell script which when run updates git
# Usage: gitUpdate

#!/bin/bash
git pull
git add -A
printf "Please enter the commit message:\n "
read -r commit_message 
printf $commit_message
git commit -m $commit_message
git push -u origin master
