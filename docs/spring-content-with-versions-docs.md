# Getting Started Spring Content with Versions

## What you'll build

We'll build on the previous guide [Getting Started with Spring Content REST API](spring-content-rest-docs.md).

## What you'll need

- About 30 minutes

- A favorite text editor or IDE

- JDK 1.8 or later

- Maven 3.0+

## How to complete this guide

Before we begin let's set up our development environment:

- Download and unzip the source repository for this guide, or clone it
using Git: `git clone https://github.com/paulcwarren/spring-content-gettingstarted.git`

- We are going to start where Getting Started with Spring Content REST API leaves off so
 `cd` into `spring-content-gettingstarted/spring-content-rest/complete`

When you’re finished, you can check your results against the code in
`spring-content-gettingstarted/spring-content-with-versions/complete`.

### Update dependencies

Add the `com.github.paulcwarren:spring-versions-boot-starter` and `org.springframework.boot:spring-boot-starter-security` dependencies.

`pom.xml`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/master/spring-content-with-versions/complete/pom.xml 1-}
```

## Update File Entity

Add the following annotations to our Entity.

`src/main/java/gettingstarted/File.java`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/master/spring-content-with-versions/complete/src/main/java/gettingstarted/File.java 1-}
```

`@LockOwner`; tracks the current lock owner.  Optional
`@AncestorId`; references the entity that came immediately before in the version series 
`@AncestorRootId`; references the entity that came first in the version series
`@SuccessorId`; references the entity that came after in the version series 
`@VersionNumber`; version designation 
`@VersionLabel`; description of the version 

Also note the copy constructor.  An Entity can be complex.  It is impossible for Spring Content to know exactly how to stamp out a new version when it needs to.  This is where the copy constructor comes in.  The copy constructor tells Spring Content how to create a new version.   There is no need to copy the version attributes as they will be managed as part of the version creation process.  Other than that, it is up to you.

## Update FileRepository

So that we can perform version operations on an Entity make your FileRepository extend `LockingAndVersioningRepository`.  

`src/main/java/gettingstarted/FileRepository.java`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/master/spring-content-with-versions/complete/src/main/java/gettingstarted/FileRepository.java 1-}
```

## Update Configuratoin

Add a Store configuration to tell Spring Data JPA to look in the package `org.springframework.versions` for the implementation of the `LockingAndVersioningRepository`.  Because of this you will also need to tell Spring Data to find `FileRepository` in the `gettingstarted` package. 

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/master/spring-content-with-versions/complete/src/main/java/gettingstarted/SpringContentApplication.java 29-32}
```

Enable web security and add an anonymous user principal.

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/master/spring-content-with-versions/complete/src/main/java/gettingstarted/SpringContentApplication.java 34-79}
```

## Build an executable JAR

If you are using Maven, you can run the application using `mvn spring-boot:run`.
Or you can build the JAR file with `mvn clean package` and run the JAR
by typing:

`java -jar target/gettingstarted-spring-content-with-versions-0.0.1.jar`

## Create an Entity and version it

Create an entity:

`curl -X POST -H 'Content-Type:application/hal+json' -d '{}' http://localhost:8080/files/`

Associate content:

`curl -X PUT -H 'Content-Type:text/plain' -d 'Hello Spring Content with Versions World!' http://localhost:8080/files/1`

Lock the Entity to prevent others from editing it:

`curl -X PUT -H 'Content-Type:application/hal+json' http://localhost:8080/files/1/lock` 

Create a new version of the entity:

`curl -X PUT -H 'Content-Type:application/hal+json' -d '{"number":"1.1","label":"some minor changes"}' http://localhost:8080/files/1/version`

Unlock the new version of the Entity: 

`curl -X DELETE -H 'Accept:application/hal+json' http://localhost:8080/files/2/lock`

Fetch the version series:

`curl -H 'Accept:application/hal+json' http://localhost:8080/files/`   
 
Verify you now see two entities that are in a version series with each other.

## Summary

Congratulations!  You've written a simple application that uses Spring
Content with Versions to create a version series of entities with associated content.

Don't forget you can simply change the type of the spring-content bootstarter
project on the classpath to switch from file storage to a different
storage technology.  The REST and Version Modules works seamlessly with all of the storage modules.

Spring Content supports the following implementations:-

- Spring Content Filesystem; stores content as Files on the Filesystem
(as used in this tutorial)

- Spring Content S3; stores content as Objects in Amazon S3

- Spring Content JPA; stores content as BLOBs in the database

- Spring Content MongoDB; stores content as Resources in Mongo's GridFS
