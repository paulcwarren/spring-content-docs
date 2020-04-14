#### Spring Content

Cloud-Native Content Services for Spring.

For creating services that manage content such as documents, images and movies.  

Build your own cloud-native, scale-out headless content services using the exact same components as the Enterprise Content Management (ECM) vendors such as Documentum and OpenText, without the hassle.   

## Features

- Standardized content access no matter where it is stored  

- Content/metadata association   

- Content search

- Content transformation

- REST or CMIS endpoints

## Videos

- [An Overview of Spring Content](https://www.youtube.com/watch?v=pbDaONWWT3s)

- [SpringOne 2016 - Persistence Arrives on Cloud Foundry](https://www.youtube.com/watch?v=VisP5ebZoWw)

- [SpringOne 2017 - A Guided Tour From Code Base To Platform 11:28 - 21:58](https://www.youtube.com/watch?v=YtNvHTwHhRY&t=0s&list=PLAdzTan_eSPQ2uPeB0bByiIUMLVAhrPHL&index=93)

- [SpringOne 2018 - From Content Management to Content Services with Spring Boot, Data and Content](https://www.youtube.com/watch?v=qyIMHWR40eA)

## Modules

- Spring Content Commons - Core Spring concepts underpinning every Spring Content project.

- Spring Content S3 - Store support for Amazon S3 objects.  Also supports DellEMC ECS

- Spring Content Filesystem - Store support for the Filesystem files

- Spring Content Mongo - Store support for Mongo's GridFS

- Spring Content JPA - Store support for JPA BLOBs

- Spring Content Renditions - Extensible rendition service for content transformations

- Spring Content Solr - Content indexing and search with Apache Solr

- Spring Content Elasticsearch  - Content indexing and search with Elasticsearch

- Spring Versions Commons - Locking and versioning semantics for Entities and associated content

- Spring Versions JPA - JPA-based implementation of locking and versioning

- Spring Data REST - Exports Spring Content stores as hypermedia-driven RESTful resources

- Spring Content CMIS - Exports Spring Content stores through the CMIS browser bindings

## Overview

<center>![spring-content-arch](spring-content-arch.jpg)</center>
<center>_Figure 1. understanding how Spring Content fits into the Spring eco-system_</center>

## Quick Start

```xml
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/master/spring-content-fs/complete/pom.xml 38-42}
```

For a quick taste, look at the following domain object:

```java
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/master/spring-content-fs/complete/src/main/java/gettingstarted/File.java 17-33}
```

This defines a simple JPA entity with a few structured data fields; title, authors and keywords and two Spring Content-managed data fields; `@ContentId` and `@ContentLength`.

The structured data fields are managed in the usual way through a `CrudRepository<SopDocument,String>` interface.  

Content is handled separately with a ContentStore interface:-

```java
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/master/spring-content-fs/complete/src/main/java/gettingstarted/FileContentStore.java 5-6}
```

This interface extends Spring Content’s `ContentStore` and is typed to the entity class File and the id class String.  Put this code inside a Spring Boot application with `spring-boot-starter-data-jpa` and `spring-content-fs-boot-starter` like this:

```java
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/master/spring-content-fs/complete/src/main/java/gettingstarted/SpringContentApplication.java 6-12}
```

Launch your app and Spring Content (having been autoconfigured by Spring Boot) will automatically craft a concrete set of operations for handling the content associated with this Entity:

- `setContent(S property, InputStream content)`

- `InputStream getContent(S property)`

- `unsetContent(S property)`

For more, check out our initial [Getting Started Guide](spring-content-fs-docs.md), or watch one of our SpringOne talks [2016](https://bit.ly/springone-vid), [2017 @11mins](https://www.youtube.com/watch?v=YtNvHTwHhRY) and [2018](https://www.youtube.com/watch?v=qyIMHWR40eA&t=52s).

## Reference Documentation

<table width=100%>
    <thead>
        <tr>
            <th></th>
            <th colspan=2 style="text-align:center">Spring Boot 2.1.x</th>
            <th colspan=2 style="text-align:center">Spring Boot 2.2.x</th>
            <th colspan=2 style="text-align:center">Spring Boot 2.3.x</th>
        </tr>
        <tr>
            <th>
            <th>SNAPSHOT</th>
            <th>GA</th>
            <th>SNAPSHOT</th>
            <th>GA</th>
            <th>SNAPSHOT
            <th>GA</th>
        </tr>
        <tr>
            <th colspan=6>Storage</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Spring Content S3</td>
            <td><a href="refs/snapshot/master/s3-index.html">0.13.0</a></td>
            <td><a href="refs/release/0.12.0/s3-index.html">0.12.0</a></td>
            <td><a href="refs/snapshot/1.0.x/s3-index.html">1.0.0.M10</a></td>
            <td><a href="refs/release/1.0.0.M9/s3-index.html">1.0.0.M9</a></td>
            <td><a href="refs/snapshot/1.1.x/s3-index.html">1.1.0.M1</a></td>
            <td><a href="refs/release/1.1.0.M1/s3-index.html">1.0.0.M1</a></td>
        </tr>
        <tr>
            <td>Spring Content Filesystem</td>
            <td><a href="refs/snapshot/master/fs-index.html">0.13.0</a></td>
            <td><a href="refs/release/0.12.0/fs-index.html">0.12.0</a></td>
            <td><a href="refs/snapshot/1.0.x/fs-index.html">1.0.0.M10</a></td>
            <td><a href="refs/release/1.0.0.M9/fs-index.html">1.0.0.M9</a></td>
            <td><a href="refs/snapshot/1.1.x/fs-index.html">1.1.0.M1</a></td>
            <td><a href="refs/release/1.1.0.M1/fs-index.html">1.0.0.M1</a></td>
        </tr>
        <tr>
            <td>Spring Content Mongo</td>
            <td><a href="refs/snapshot/master/mongo-index.html">0.13.0</a></td>
            <td><a href="refs/release/0.12.0/mongo-index.html">0.12.0</a></td>
            <td><a href="refs/snapshot/1.0.x/mongo-index.html">1.0.0.M10</a></td>
            <td><a href="refs/release/1.0.0.M9/mongo-index.html">1.0.0.M9</a></td>
            <td><a href="refs/snapshot/1.1.x/mongo-index.html">1.1.0.M1</a></td>
            <td><a href="refs/release/1.1.0.M1/mongo-index.html">1.0.0.M1</a></td>
        </tr>
        <tr>
            <td>Spring Content JPA</td>
            <td><a href="refs/snapshot/master/jpa-index.html">0.13.0</a></td>
            <td><a href="refs/release/0.12.0/jpa-index.html">0.12.0</a></td>
            <td><a href="refs/snapshot/1.0.x/jpa-index.html">1.0.0.M10</a></td>
            <td><a href="refs/release/1.0.0.M9/jpa-index.html">1.0.0.M9</a></td>
            <td><a href="refs/snapshot/1.1.x/jpa-index.html">1.1.0.M1</a></td>
            <td><a href="refs/release/1.1.0.M1/jpa-index.html">1.0.0.M1</a></td>
        </tr>
        <tr>
            <th colspan=7>Versioning</th>
        </tr>
        <tr>
            <td>Spring Versions JPA</td>
            <td><a href="refs/snapshot/master/jpaversions-index.html">0.13.0</a></td>
            <td><a href="refs/release/0.12.0/jpaversion-index.html">0.12.0</a></td>
            <td><a href="refs/snapshot/1.0.x/jpaversions-index.html">1.0.0.M10</a></td>
            <td><a href="refs/release/1.0.0.M9/jpaversions-index.html">1.0.0.M9</a></td>
            <td><a href="refs/snapshot/1.1.x/jpaversions-index.html">1.1.0.M1</a></td>
            <td><a href="refs/release/1.1.0.M1/jpaversions-index.html">1.0.0.M1</a></td>
        </tr>
        <tr>
            <th colspan=7>Fulltext Indexing</th>
        </tr>
        <tr>
            <td>Spring Content Solr</td>
            <td><a href="refs/snapshot/master/solr-index.html">0.13.0</a></td>
            <td><a href="refs/release/0.12.0/solr-index.html">0.12.0</a></td>
            <td><a href="refs/snapshot/1.0.x/solr-index.html">1.0.0.M10</a></td>
            <td><a href="refs/release/1.0.0.M9/solr-index.html">1.0.0.M9</a></td>
            <td><a href="refs/snapshot/1.1.x/solr-index.html">1.1.0.M1</a></td>
            <td><a href="refs/release/1.1.0.M1/solr-index.html">1.0.0.M1</a></td>
        </tr>
        <tr>
            <td>Spring Content Elasticsearch</td>
            <td><a href="refs/snapshot/master/elasticsearch-index.html">0.13.0</a></td>
            <td><a href="refs/release/0.12.0/elasticsearch-index.html">0.12.0</a></td>
            <td><a href="refs/snapshot/1.0.x/elasticsearch-index.html">1.0.0.M10</a></td>
            <td><a href="refs/release/1.0.0.M9/elasticsearch-index.html">1.0.0.M9</a></td>
            <td><a href="refs/snapshot/1.1.x/elasticsearch-index.html">1.1.0.M1</a></td>
            <td><a href="refs/release/1.1.0.M1/elasticsearch-index.html">1.0.0.M1</a></td>
        </tr>
        <tr>
            <th colspan=7>APIs</th>
        </tr>
        <tr>
            <td>Spring Content REST</td>
            <td><a href="refs/snapshot/master/rest-index.html">0.13.0</a></td>
            <td><a href="refs/release/0.12.0/rest-index.html">0.12.0</a></td>
            <td><a href="refs/snapshot/1.0.x/rest-index.html">1.0.0.M10</a></td>
            <td><a href="refs/release/1.0.0.M9/rest-index.html">1.0.0.M9</a></td>
            <td><a href="refs/snapshot/1.1.x/rest-index.html">1.1.0.M1</a></td>
            <td><a href="refs/release/1.1.0.M1/rest-index.html">1.0.0.M1</a></td>
        </tr>
        <tr>
            <td>Spring Content CMIS</td>
            <td><a href="refs/snapshot/master/cmis-index.html">0.13.0</a></td>
            <td><a href="refs/release/0.12.0/cmis-index.html">0.12.0</a></td>
            <td><a href="refs/snapshot/1.0.x/cmis-index.html">1.0.0.M10</a></td>
            <td><a href="refs/release/1.0.0.M9/cmis-index.html">1.0.0.M9</a></td>
            <td><a href="refs/snapshot/1.1.x/cmis-index.html">1.1.0.M1</a></td>
            <td><a href="refs/release/1.1.0.M1/cmis-index.html">1.0.0.M1</a></td>
        </tr>
    </tbody>
</table>
