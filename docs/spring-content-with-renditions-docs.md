# Getting Started Spring Content with Fulltext

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
`spring-content-gettingstarted/spring-content-with-fulltext/complete`.

## Update dependencies

Add the `com.github.paulcwarren:spring-content-renditions-boot-starter` dependency.

`pom.xml`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-with-renditions/complete/pom.xml 1-}
```

## Update File

To be able to return renditions we need to know the mime-type of the existing
content.  Annotate the mimeType field with the `MimeType` annotation so that it
will be by Spring Content REST.

`src/main/java/gettingstarted/File.java`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-with-renditions/complete/src/main/java/gettingstarted/File.java 1-33}
```

## Update FileContentStore

So that we can fetch renditions make your FileContentStore extend `Renderable`.  

`src/main/java/gettingstarted/FileContentStore.java`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-with-renditions/complete/src/main/java/gettingstarted/FileContentStore.java 1-}
```

## Build an executable JAR

If you are using Maven, you can run the application using `mvn spring-boot:run`.
Or you can build the JAR file with `mvn clean package` and run the JAR
by typing:

`java -jar target/gettingstarted-spring-content-with-renditions-0.0.1.jar`

## Test renditions

Create an entity:

`curl -X POST -H 'Content-Type:application/hal+json' -d '{}' http://localhost:8080/files/`

Associate content with that entity:

`curl -X PUT -H 'Content-Type:text/plain' -d 'Hello Spring Content World!' http://localhost:8080/files/1/content`

Fetch the content:

`curl -H 'Accept:text/plain' http://localhost:8080/files/1/content`   

And you should see a response like this:

```
Hello Spring Content World!
```

Fetch the content again but this time specify that we want a jpeg rendition of the content by specify
the mime-type `image/jpeg` as the accept header.  Let's time the operation too.  We'll use this later.  As 
it is an image let's save it to a file:

`time curl -H 'Accept:image/jpeg' http://localhost:8080/files/1/content --output /tmp/file-1.jpg`   

Note the time the operation tookk and inspect the image `open /tmp/file-1.jpg` and you should see an image like this:

<center>![Spring Content Rendition](spring-content-with-renditions.png)</center>

## Stored Renditions

This is useful but rendering content on-demand everytime is unnecessary.  Let's store the rendition instead.

### Update File

Add a second content property to store the rendition.

`src/main/java/gettingstarted/File.java`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-with-renditions/complete/src/main/java/gettingstarted/File.java 1-}
```

### Add Event Handler

Next let's add an event handler that uses the rendition service to convert the `text/plain` content to `image/jpeg` and store
it in the second content property we just created.  Then remove it again when the content is also removed.

`src/main/java/gettingstarted/StoredRenditionsEventHandler.java`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-with-renditions/complete/src/main/java/gettingstarted/StoredRenditionsEventHandler.java 1-}
```

and register it.

`src/main/java/gettingstarted/SpringContentApplication.java`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-with-renditions/complete/src/main/java/gettingstarted/SpringContentApplication.java 1-}
```

## Test Store Renditions

Rebuild and restart your application and let's replay the operations we performed earlier.

Create an entity:

`curl -X POST -H 'Content-Type:application/hal+json' -d '{}' http://localhost:8080/files/`

Associate content with that entity:

`curl -X PUT -H 'Content-Type:text/plain' -d 'Hello Stored Renditions World!' http://localhost:8080/files/1/content`


Fetch the content again specifying that we want a jpeg rendition of the content by specifying
the mime-type `image/jpeg` as the accept header.  Note, we are still addressing the 'content' property.  Let's time the operation again.  We can compare this to our previous timing.  And for ease save it to a file:

`time curl -H 'Accept:image/jpeg' http://localhost:8080/files/1/content --output /tmp/file-1.jpg`   

Note the time completed quicker (roughly twice as fast) as it was returning the previous stored rendition rather than converting it on the fly.  Inspect the image by opening `/tmp/file-2.jpg` and you should see an image like this:

<center>![Spring Content Rendition](spring-content-with-stored-renditions.png)</center>

## Summary

Congratulations!  You've just written a simple application that uses Spring Content and Spring Content Renditions to be able to transform content from one format to another and to store that rendered content for quicker access later on.

This guide demonstrates the Spring Content Renditions Module.  This module supports several renderers out-of-the-box satisfying most use cases.  However, you may also add your own renderers using the RenditionProvider extension point.  For more details
see the Spring Content Renditions reference guide.  
