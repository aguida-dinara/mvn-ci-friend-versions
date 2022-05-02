# maven-ci-friendly project

## Goals:

- Provide an automated way to control maven artifact versions on separate branches with minimal intervention required by the developer. 

## Description:
* Leveraging the features described in [Maven CI Friendly Versions](https://maven.apache.org/maven-ci-friendly.html) appearing in Maven 3.5.0-beta-1, we can now use certain variables within a pom.xml's <version> tag
to better manage the project's version. 
* Using this newer model, a maven project's actual version is no longer supplied in the pom.xml of the project. Instead, it is now supplied in one of two ways:
    * Within ```.mvn/maven.config``` under parameter ```revision```
    * At the command line, via:
    ```
    mvn -Drevision=3.2.5 -Dchangelist=-branchname-SNAPSHOT clean install
    ``` 
    * To define a version suffix, an additional parameter  ```changelist``` can be used. Using the command-line example above, will product the following version:
  
    ```3.2.5-branchname-SNAPSHOT```

* The maven version is now specified in .mvn/maven.config along with any other value we wish to append to the project's maven version.
* A git "post-check" hook is added to the project which will automatically change the maven version's suffix on checkout. For example, we can:
  * Append a branch-name to the project's version.
  * Determine whether the version should be ```-SNAPSHOT``` based on the currency branch's name (or other characteristics). 
  * Additional any other additional logic can be defined based on the name of the branch 

These are just a few examples: This process is reasonably flexible and could be adapter to any number of possible git/maven workflows. 

## Prerequisites:
* Maven 3.5.0-beta-1 or later
* Git (not sure of the minimum version)

## Setup: 
* A single one-time configuration of the user's git configuration:
Run the following for hooks to work:
```$ git config --local include.path ../.gitconfig```

## Resources & Inspirations: 
- https://maven.apache.org/maven-ci-friendly.html
- https://www.mojohaus.org/flatten-maven-plugin/


## TODO: 
- Currently, only works in Windows and Linux. Need to find a workaround to poorly designed behavior in OSX versions of sed.  