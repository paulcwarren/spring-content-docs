# Getting Started Spring Content with RBAC

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
`spring-content-gettingstarted/spring-content-with-rbac/complete`.

### Update dependencies

Add `org.springframework.boot:spring-boot-starter-security` dependencies.

`pom.xml`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/master/spring-content-with-rbac/complete/pom.xml 1-}
```
## Add Security Constraints

Enable web security.

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/master/spring-content-with-versions/complete/src/main/java/gettingstarted/SpringSecruityConfig.java 1-}
```

First, define two users and two roles.  Eric is a content `reader` and Paul is a content `reader` and `author`.

Second, secure the Spring Content endpoint `/files/**/content` that `GETs` and `SETs` content to the `reader` and `author` roles respectively.

### @PreAuthorize 

As an alternative secure removing content to the `author` role by using an alternative approach using the `@PreAuthorize` annotation on the FileContentStore's `unset` method.

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/master/spring-content-with-versions/complete/src/main/java/gettingstarted/FileContentStore.java 1-}
```

## Build an executable JAR

If you are using Maven, you can run the application using `mvn spring-boot:run`.
Or you can build the JAR file with `mvn clean package` and run the JAR
by typing:

`java -jar target/gettingstarted-spring-content-with-rbac-0.0.1.jar`

## Create an Entity and version it

Create an entity:

`curl -X POST -H 'Content-Type:application/hal+json' -d '{}' http://localhost:8080/files/`

Attempt to associate content as Eric:

`curl -u eric:wimp -X PUT -H 'Content-Type:text/plain' -d 'Hello Spring Content with RBAC World!' http://localhost:8080/files/1/content`

Associate content as Paul:

`curl -u paul:warren -X PUT -H 'Content-Type:text/plain' -d 'Hello Spring Content with RBAC World!' http://localhost:8080/files/1/content`

Fetch the content as Eric:

`curl -u eric:wimp -H 'Accept:text/plain' http://localhost:8080/files/1/content`
 
And as Paul:

`curl -u paul:warren -H 'Accept:text/plain' http://localhost:8080/files/1/content`

Attempt to delete content as Eric:

`curl -u eric:wimp -X DELETE http://localhost:8080/files/1/content`

Delete content as Paul:

`curl -u paul:warren -X DELETE http://localhost:8080/files/1/content`

## Summary

Congratulations!  You've written a simple application that uses Spring
Content secured with role-based access control.

Don't forget you can simply change the type of the spring-content bootstarter
project on the classpath to switch from file storage to a different
storage technology.  

Spring Content supports the following implementations:-

- Spring Content Filesystem; stores content as Files on the Filesystem
(as used in this tutorial)

- Spring Content S3; stores content as Objects in Amazon S3

- Spring Content JPA; stores content as BLOBs in the database

- Spring Content MongoDB; stores content as Resources in Mongo's GridFS
