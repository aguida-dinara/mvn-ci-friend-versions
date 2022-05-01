#!/bin/bash

# Assumption: We do not append a branch name to these stable branches
stable_branches='main master dev develop'

MAVEN_DOT_DIR=.mvn
MAVEN_CONFIG_FILENAME=maven.config
FILE=${MAVEN_DOT_DIR}/${MAVEN_CONFIG_FILENAME}
# Creates the .mvn directory and maven.config file if they do not already exist.
function setup_maven_config() {
    if ! [ -d "$MAVEN_DOT_DIR" ]; then
      $(mkdir -p $MAVEN_DOT_DIR);
      echo "$MAVEN_DOT_DIR directory created"
    fi

    if ! [ -f "$MAVEN_CONFIG_FILENAME" ]; then
      $(touch $MAVEN_DOT_DIR/$MAVEN_CONFIG_FILENAME);
      echo "$MAVEN_CONFIG_FILENAME file created"
    fi
}

# Creates or replaces the -Dbranch= argument in maven.config based on the current git branch
function create_branch_arg(){
  if ! grep -q '\-Dbranch=' $FILE ; then echo '-Dbranch=' >> $FILE; fi
  # if on a stable branch, then don't set a branch name for the version
  if [[ " $stable_branches " =~ .*\ $current_branch\ .* ]]; then
    echo "On a stable branch, the branch name WILL NOT be added to maven.version config"
    sed -i "/-Dbranch=/c\-Dbranch=" .mvn/maven.config
  else
    echo "On a non-stable branch, the branch name WILL be added to maven.version config"
    sed -i "/-Dbranch=/c\-Dbranch=-${current_branch}" .mvn/maven.config
  fi
}

# Creates or replaces the -Dchangelist= argument in maven.config
function create_changelist_arg() {
  if ! grep -q '\-Dchangelist=' $FILE ; then echo '-Dchangelist=-SNAPSHOT' >> $FILE; fi
  if grep -q "\-Dchangelist=" .mvn/maven.config; then
     echo "Found -Dchangelist= entry. Not altering."
  else
      echo "Did not find entry for -Dchangelist=. Adding..."
      sed -i "$ a -Dchangelist=-SNAPSHOT" .mvn/maven.config
  fi
}

# SCRIPT START:
# sed regex replaces non-(alphanumeric, dot or dash) char sequences with a dash
current_branch=$(git rev-parse --abbrev-ref HEAD | sed -E -e 's@[^0-9A-Za-z.-]+@-@g')
echo "current branch is ${current_branch}"
setup_maven_config
create_branch_arg
create_changelist_arg