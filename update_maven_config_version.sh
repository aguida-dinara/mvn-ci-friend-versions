#!/bin/bash

# Assumption: We do not append a branch name to these stable branches
stable_branches='main master dev develop'

MAVEN_DOT_DIR=.mvn
MAVEN_CONFIG_FILENAME=maven.config
FILE=${MAVEN_DOT_DIR}/${MAVEN_CONFIG_FILENAME}
function verify_maven_config() {
    if ! [ -f "$FILE" ]; then
      echo "ERROR: ${FILE} does not exist."
    elif ! grep -q '\-Drevision=' $FILE ; then
      echo "ERROR: Revision value is missing from ${FILE}. Please include a value for -Drevision=<maven version>"
    fi
}

# Creates or replaces the -Dchangelist= argument in maven.config based on the current git branch
function create_changelist_arg(){
  if ! grep -q '\-Dchangelist=' $FILE ; then echo '-Dchangelist=' >> $FILE; fi
  # if on a stable branch, then don't set a branch name for the version
  if [[ " $stable_branches " =~ .*\ $current_branch\ .* ]]; then
    echo "On a stable branch, the branch name WILL NOT be added to maven.version config"
    sed -i "/-Dchangelist=/c\-Dchangelist=-SNAPSHOT" $FILE
  else
    echo "On a non-stable branch, the branch name WILL be added to maven.version config"
    sed -i "/-Dchangelist=/c\-Dchangelist=-${current_branch}-SNAPSHOT" $FILE
  fi
}

# SCRIPT START:
# sed regex replaces non-(alphanumeric, dot or dash) char sequences with a dash
current_branch=$(git rev-parse --abbrev-ref HEAD | sed -E -e 's@[^0-9A-Za-z.-]+@-@g')
echo "current branch is ${current_branch}"
verify_maven_config
create_changelist_arg