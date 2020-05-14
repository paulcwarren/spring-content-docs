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

### Update dependencies

Add the `com.github.paulcwarren:spring-content-elasticsearch-boot-starter` and `org.elasticsearch.client:elasticsearch-rest-high-level-client` dependencies.

`pom.xml`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/master/spring-content-with-fulltext/complete/pom.xml 1-}
```

## Update FileContentStore

So that we can perform full-text searches make your FileContentStore extend `Searchable`.  

`src/main/java/gettingstarted/FileContentStore.java`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/master/spring-content-with-fulltext/complete/src/main/java/gettingstarted/FileContentStore.java 1-}
```

## Build an executable JAR

If you are using Maven, you can run the application using `mvn spring-boot:run`.
Or you can build the JAR file with `mvn clean package` and run the JAR
by typing:

`java -jar target/gettingstarted-spring-content-with-versions-0.0.1.jar`

## Start an Elasticsearch Server

Using docker, start an elasticsearch server:

`docker run -d -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" paulcwarren/elasticsearch:latest`

## Create an Entity

Create an entity:

`curl -X POST -H 'Content-Type:application/hal+json' -d '{}' http://localhost:8080/files/`

Associate content with that entity:

`curl -X PUT -H 'Content-Type:text/plain' -d 'Hello Spring World!' http://localhost:8080/files/1`

Create a second entity:

`curl -X POST -H 'Content-Type:application/hal+json' -d '{}' http://localhost:8080/files/`

Associate content with the second entity:

`curl -X PUT -H 'Content-Type:text/plain' -d 'Hello Spring Content World!' http://localhost:8080/files/2`

Perform a fulltext search using the /searchContent endpoint:

`curl -H 'Accept:application/hal+json' http://localhost:8080/files/searchContent?queryString=Content`   

And you should see a response like this:

```
{
  "_embedded" : {
    "files" : [ {
      "name" : null,
      "created" : "2020-05-14T06:05:07.633+0000",
      "summary" : null,
      "contentId" : "527638d0-4f08-469d-a7d7-b271316af3da",
      "contentLength" : 27,
      "mimeType" : "text/plain",
      "_links" : {
        "self" : {
          "href" : "http://localhost:8080/files/2"
        },
        "file" : {
          "href" : "http://localhost:8080/files/2"
        },
        "files" : {
          "href" : "http://localhost:8080/files/2"
        }
      }
    } ]
  },
  "_links" : {
    "self" : {
      "href" : "http://localhost:8080/files/searchContent?queryString=Content"
    }
  }
}
```

Spring Content found the second document that we added because its content
included the keyword "Content" that we searched for.  

## Summary

Congratulations!  You've just written a simple application that uses Spring
Content with Elasticsearch to index content so that searches can be performed
against that content.

This guide demonstrates the Spring Content Elasticsearch Module.  Spring Content
also supports Solr with the Spring Content Solr Module.  To use Solr, simply
update the `spring-content-elasticsearch-boot-starter` dependency for
`spring-content-solr-boot-starter`.
