# Getting Started with Spring Content REST

## What you'll build

You'll remove redundant code from the document list web application that
we produced in our first [Getting Started Guide](spring-content-fs-docs.md).

## What you'll need

- About 30 minutes

- A favorite text editor or IDE

- JDK 1.8 or later

- Maven 3.0+

## How to complete this guide

Before we begin let's set up our development environment:

- Download and unzip the source repository for this guide, or clone it
using Git: `git clone https://github.com/paulcwarren/spring-content-gettingstarted.git`

- We are going to start form where we left of in the last Getting Started
Guide so `cd` into `spring-content-gettingstarted/spring-content-fs/complete`

- Move ahead to `Update dependencies`.

When you’re finished, you can check your results against the code in
`spring-content-gettingstarted/spring-content-rest/complete`.

### Update dependencies

Add the `com.emc.spring.content:spring-content-rest-boot-starter` dependency.

`pom.xml`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/master/spring-content-rest/complete/pom.xml 1-}
```

## Update File Entity

Add the `@MimeType` marker annotation to our Entity.

`src/main/java/gettingstarted/File.java`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/master/spring-content-rest/complete/src/main/java/gettingstarted/File.java 1-}
```

The `mimeType` attribute is updated with the Spring Content  `@MimeType`
annotation so that Spring Content REST will update its value on our behalf.

## Update FileContentStore

So that we can perform simple CRUD operations, over a hypermedia-based
API, update our `FileContentStore` by annotating it with the
`@StoreRestResource` Spring Content REST annotation.

`src/main/java/gettingstarted/FileContentStore.java`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/master/spring-content-rest/complete/src/main/java/gettingstarted/FileContentStore.java 1-}
```

## Remove FileContentController

Having made the above updates we can remove our `FileContentController`
as it is now surplus to requirements.   Spring Content REST will provide
these endpoints for us.

## Build an executable JAR

If you are using Maven, you can run the application using `mvn spring-boot:run`.
Or you can build the JAR file with `mvn clean package` and run the JAR
by typing:

`java -jar target/gettingstarted-spring-content-rest-0.0.1.jar`

And then point your browser at:-

`http://localhost:8080`

and you should see something like this:-

<center>![Spring Content Webapp](spring-content-fs-webapp.png)</center>

As you did in the previous tutorial, exercise the application by uploading
a range of new files and viewing them.  You should see viewed files open
as they did before.

## Summary

Congratulations!  You've written a simple application that uses Spring
Content and Spring Content REST to save objects with content to the
file-system and to fetch them again using a hypermedia-based REST API -
all without writing any implementation code to handle file access.

Don't forget you can simply change the type of the spring-content bootstarter
project on the classpath to switch from file storage to a different
storage medium.  Spring Content REST works seamlessly with all of the storage modules.

Spring Content supports the following implementations:-

- Spring Content Filesystem; stores content as Files on the Filesystem
(as used in this tutorial)

- Spring Content S3; stores content as Objects in Amazon S3

- Spring Content JPA; stores content as BLOBs in the database

- Spring Content MongoDB; stores content as Resources in Mongo's GridFS
