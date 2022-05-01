# maven-ci-friendly project

## Goals:

- Demonstrate a methodology that will seamlessly provide branch-specific versions of maven artifacts with minimal manual intervention by the developer. 

## Setup: 
* Must run the following for hooks to work:
```$ git config --local include.path ../.gitconfig```

## Description of use:
instead of the project version supplied in multiple places within the pom.xml, it is now 
supplied within .mvn/maven.config under parameter ```revision``` 

Additionally, another variable is provided to append an additional version suffix named
```changelist```

These can be overridden programatically via the command line. For example:
```
mvn -Drevision=3.2.5 -Dchangelist=-branchname-SNAPSHOT clean install
```
Will produce a version of ```3.2.5-branchname-SNAPSHOT```

## Resources & Inspirations: 
- https://maven.apache.org/maven-ci-friendly.html
- https://www.mojohaus.org/flatten-maven-plugin/

## TODO:
1. 

2. Fix the following when switching branches - maven.config changed automatically requires a force checkout
this is not ideal
```
error: Your local changes to the following files would be overwritten by checkout:
	.mvn/maven.config
Please commit your changes or stash them before you switch branches.
Aborting

```