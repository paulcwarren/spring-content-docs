# Getting Started with Spring Content

## What you'll build

You'll build an application that uses Spring Content to build a simple web-based document list.

## What you'll need

- About 30 minutes

- A favorite text editor or IDE

- JDK 1.8 or later

- Maven 3.0+

You can also import the code from this guide as well as view the web page directly into Spring Tool Suite (STS) and work your way through it from there.

## How to complete this guide

Like most Spring Getting Started guides, you can start form scratch and complete each step, or you can bypass basic setup steps that are already familiar to you.  Either way, you end up with working code.

To start from scratch, move on to Build with Maven.

To skip the basics, do the following:

- Download and unzip the source repository for this guide, or clone it using Git: `git clone https://github.com/paulcwarren/spring-content-gettingstarted.git`

- `cd` into `spring-content-gettingstarted/spring-content-fs/initial`

- Jump ahead to `Define a simple entity`.
When you’re finished, you can check your results against the code in `spring-content-gettingstarted/spring-content-fs/complete`.

## Build with Maven

First you set up a basic build script. You can use any build system you like when building apps with Spring, but the code you need to work with [Maven](https://maven.apache.org/) is included here.  If you’re not familiar with Maven, refer to [Building Java Projects with Maven](http://spring.io/guides/gs/maven).

### Create a directory structure

In a project directory of your choosing, create the following subdirectory structure; for example, with `mkdir -p src/main/java/gettingstarted` on *nix systems:

```
∟ src
   ∟ main
       ∟ java
           ∟ gettingstarted
       ∟ resources
           ∟ static
```

`pom.xml`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-fs/complete/pom.xml 1-}
```

We add several dependencies:-

- Spring Boot Starter Web provides the web server framework

- Spring Boot Starter Data JPA will provide a relational database to
store the metadata of our files.  In this case we are using the H2
in-memory database

- Spring Boot Starter Data REST will provide REST endpoints for our File
metadata

- Spring Boot Starter Content FS will provide a Filesystem-based
store for the content of each file and manage the
association with an Entity

## Define a simple Entity

Let's define a simple Entity to represent a File.

`src/main/java/gettingstarted/File.java`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-fs/complete/src/main/java/gettingstarted/File.java 1-}
```

As you would expect we created a standard JPA Entity to capture some metadata about our file; `name` and `summary`.  In addition, because we will be serving these files over the web, we also record `mimeType` so that we can instruct the browser correctly.

We then add two annotated Spring Content fields; `@ContentId` and `@ContentLength`.  `@ContentId` allows us to associate a stream of binary data with an Entity and `@ContentLength` records the length of that stream.  These will be automatically managed by Spring Content.

## Create a File Repository

Next, as you would also expect, we create a `CrudRepository` for handling File entities and we export it as a `@RepositoryRestResource` so, for the cost of writing just one interface and annotating it, we get the ability to create, read, update and delete File entities using REST endpoints.

> NB. For more information on Spring Data JPA and Spring Data REST see their respective spring.io getting started guides.

`src/main/java/gettingstated/FileRepository.java`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-fs/complete/src/main/java/gettingstarted/FileRepository.java 1-}
```  

## Create a File Content Store

Similarly, we then create a `ContentStore` for handling content associated with the File entity.

`src/main/java/gettngstarted/FileContentStore.java`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-fs/complete/src/main/java/gettingstarted/FileContentStore.java 1-}
```

Let's investigate this interface:-

- `ContentStore` provides several methods for handling content; setContent,
getContent and unsetContent

- The dependency `com.github.paulcwarren:spring-content-fs-boot-starter`
provides a Filesystem-based implementation of this interface and Spring
Content auto-configuration ensures that this implementation will be used
wherever the `FileContentRepository` is `@Autowired`.

However, unlike our `FileRepository` we haven't annotated this as a
`StoreRestResource` and therefore we don't automatically get REST
endpoints for handling content.  This annotation does exist (and is the
topic of our [next tutorial]((spring-content-rest-docs.md))) but, for now,
we have to roll our own REST endpoints.

## Create a File Controller

Let's create these endpoints with a simple Controller class.

`src/main/java/gettingstarted/FileContentController.java`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-fs/complete/src/main/java/gettingstarted/FileContentController.java 1-}
```

Let's explain this class.  

- It's a standard Spring Controller with two request mapped methods, one for setting content and the other for getting content.

- Both `setContent` and `getContent` methods inject themselves into the URI space of the `FileRepository`, namely `/files/{fileId}`, but handle all GETs and PUTs that are aplication/hal+json based; i.e. content.

- We inject our `FileRepository` and our `FileContentStore`.  Respectively, Spring Boot will ensure real implementations are injected (based on what Spring Data and Spring Content modules are found on the class path).

- `setContent` uses the `FileRepository` to fetch the File entity  using the given `fileId` and then uses the `FileContentStore` to save the given file input stream.  

- Similarly, `getContent` uses the `FileRepository` to fetch the File entity using the given `fileId` and again use the `FileContentStore` to fetch the associated content and stream it back to the client as the response.  We also use previosuly saved metdata `contentLength` and `mimeType` to set http headers appropriately.  This will mean that browsers can handle the content correctly by launching the relevant desktop application.

## Create Web Client

Now let's create a really simple angular web front-end for our document list.  

`src/main/resources/static/index.html`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-fs/complete/src/main/resources/static/index.html 1-}
```

This HTML presents a simple list of files using an `ng-repeat` directive and contains a simple form allowing new files to be uploaded.

All the interesting code is in the code-behind file so add the following code behind to `src/main/resources/static/files.js`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-fs/complete/src/main/resources/static/files.js 1-}
```

This angular controller has the following functions:-

- `getFilesList` queries our `FileRepository` via its REST endpoint `files/`
and populates `filesList.files` (presented by the `ng-repeat` directive
in the HTML)

- `getHref` returns a `file`'s content hyperlink `files/{fileId}` (that
ultimately calls `FileContentController.getContent`)

- `upload` uploads a new File by first `POST`ing to the `FileRepository`
REST endpoints `/files` and once created  `PUT`ing the actual content to
the Files content REST endpoint `files/{fileId}` (that ultimately calls
`FileContentController.setContent`)

## Create an Application class

Our simple document list app is now complete.  All that remains is to add the usual Spring Boot Application class.

`src/main/java/gettingstarted/SpringContentApplication.java`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-fs/complete/src/main/java/gettingstarted/SpringContentApplication.java 1-}
```

## Build an executable JAR

If you are using Maven, you can run the application using
`mvn spring-boot:run`.  Or you can build the JAR file with
`mvn clean package` and run the JAR by typing:

`java -jar target/gettingstarted-spring-content-fs-0.0.1.jar`

And then point your browser at:-

`http://localhost:8080`

and you should see something like this:-

<center>![Spring Content Webapp](spring-content-fs-webapp.png)</center>

Exercise the application by uploading a range of new files and viewing
them.  Viewed files will be downloaded and open in the appropriate editor.

## Summary

Congratulations! You’ve written a simple application that uses Spring
Content to manage streams of binary data - without writing any specific
file access code.  What's more by just changing the type of the
spring-content boot-starter project on the classpath you can switch from
a file-based implementation to a different implementation altogether.

Spring Content supports the following implementations:-

- Spring Content Filesystem; stores content as Files on the Filesystem
(as used in this tutorial)

- Spring Content S3; stores content as Objects in Amazon S3

- Spring Content JPA; stores content as BLOBs in the database

- Spring Content MongoDB; stores content as Resources in Mongo's GridFS

## Look Forward

In this tutorial we built a simple document list web application using
Spring Content.

The majority of the work on the server-side was writing the Spring
controller for handling the Content.  Check out our next
[getting started guide](spring-content-rest-docs.md) where we'll use the
companion library Spring Content REST to automatically export these REST
endpoints for our `FileContentStore` saving ourselves even more work.
