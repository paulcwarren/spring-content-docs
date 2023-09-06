#### Content Services for Spring

Cloud-Native Content Management Extensions for Spring.

For creating cloud-native, horizontally scaling Content Management Services that manage your unstructured data and rich content such as documents, images and movies.  

## Features

- Standardized access to content no matter where it is stored  

- Associate content with Spring Data entities

- Reactive content access (S3)

- Full-text search (Solr and Elasticsearch)

- Content rendition and transformation

- Pessimistic versioning or auto-versioning

- REST or CMIS endpoints

## Videos

- [An Overview of Spring Content](https://www.youtube.com/watch?v=pbDaONWWT3s)

- [SpringOne 2016 - Persistence Arrives on Cloud Foundry](https://www.youtube.com/watch?v=VisP5ebZoWw)

- [SpringOne 2017 - A Guided Tour From Code Base To Platform 11:28 - 21:58](https://www.youtube.com/watch?v=YtNvHTwHhRY&t=0s&list=PLAdzTan_eSPQ2uPeB0bByiIUMLVAhrPHL&index=93)

- [SpringOne 2018 - From Content Management to Content Services with Spring Boot, Data and Content](https://www.youtube.com/watch?v=qyIMHWR40eA)

## Modules

- Commons - Core content management concepts underpinning every other module
- S3 - Store support for Amazon S3, and any other S3-compliant object storage.  Also supports reactive access.  
- Filesystem - Store support for the Filesystem storage
- Mongo - Store support for Mongo's GridFS storage
- JPA - Store support for JPA BLOB storage
- Renditions - Extensible rendition service for content transformations
- Solr - Content indexing and search with Apache Solr
- Elasticsearch  - Content indexing and search with Elasticsearch
- Versions Commons - Locking and versioning semantics for Entities and associated content
- Versions JPA - JPA-based implementation of locking and versioning
- REST - Exports Stores as hypermedia-driven RESTful resources
- CMIS - Exports Stores through the CMIS browser bindings

## Overview

<center>![spring-content-arch](spring-content-arch.jpg)</center>
<center>_Figure 1. understanding how Spring Content fits into the Spring eco-system_</center>

## Quick Start

```xml
<dependency>
    <groupId>com.github.paulcwarren</groupId>
    <artifactId>spring-content-fs-boot-starter</artifactId>
    <version>3.0.5</version>
</dependency>
```

For a quick taste, look at the following domain object:

```java
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-fs/complete/src/main/java/gettingstarted/File.java 17-33}
```

This defines a simple JPA entity with a few structured data fields; title, authors and keywords and two Spring Content-managed data fields; `@ContentId` and `@ContentLength`.

The structured data fields are managed in the usual way through a `CrudRepository<SopDocument,String>` interface.  

Content is handled separately with a ContentStore interface:-

```java
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-fs/complete/src/main/java/gettingstarted/FileContentStore.java 5-6}
```

This interface extends Spring Content’s `ContentStore` and is typed to the entity class File and the id class String.  Put this code inside a Spring Boot application with `spring-boot-starter-data-jpa` and `spring-content-fs-boot-starter` like this:

```java
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-fs/complete/src/main/java/gettingstarted/SpringContentApplication.java 6-12}
```

Launch your app and Spring Content (having been autoconfigured by Spring Boot) will automatically craft a concrete set of operations for handling the content associated with this Entity:

- `S setContent(S entity, InputStream content)`

- `InputStream getContent(S entity)`

- `S unsetContent(S entity)`

For more, check out our initial [Getting Started Guide](spring-content-fs-docs.md), or watch one of our SpringOne talks [2016](https://bit.ly/springone-vid), [2017 @11mins](https://www.youtube.com/watch?v=YtNvHTwHhRY) and [2018](https://www.youtube.com/watch?v=qyIMHWR40eA&t=52s).

## Reference Documentation

<table width=100% border=1px>
    <thead>
        <tr>
            <th></th>
            <th colspan=2 style="text-align:center">Boot 2.4.x+</th>
            <th colspan=2 style="text-align:center">Boot 3.0.x+</th>
        </tr>
        <tr>
            <th></th>
            <th>GA</th>
            <th>SNAPSHOT</th>
            <th>GA</th>
            <th>SNAPSHOT</th>
        </tr>
        <tr>
            <th colspan=9>Storage</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Spring Content S3</td>
            <td><a href="refs/release/2.9.0/s3-index.html">2.9.0</a></td>
            <td><a href="refs/snapshot/2.x.x/s3-index.html">2.10.0</a></td>
            <td><a href="refs/release/3.0.5/s3-index.html">3.0.5</a></td>
            <td><a href="refs/snapshot/main/s3-index.html">3.0.6</a></td>
        </tr>
        <tr>
            <td>Spring Content GCS</td>
            <td><a href="refs/release/2.9.0/gcs-index.html">2.9.0</a></td>
            <td><a href="refs/snapshot/2.x.x/gcs-index.html">2.10.0</a></td>
            <td><a href="refs/release/3.0.5/gcs-index.html">3.0.5</a></td>
            <td><a href="refs/snapshot/main/gcs-index.html">3.0.6</a></td>
        </tr>
        <tr>
            <td>Spring Content Azure Storage</td>
            <td><a href="refs/release/2.9.0/azure-index.html">2.9.0</a></td>
            <td><a href="refs/snapshot/2.x.x/azure-index.html">2.10.0</a></td>
            <td><a href="refs/release/3.0.5/azure-index.html">3.0.5</a></td>
            <td><a href="refs/snapshot/main/azure-index.html">3.0.6</a></td>
        </tr>
        <tr>
            <td>Spring Content Filesystem</td>
            <td><a href="refs/release/2.9.0/fs-index.html">2.9.0</a></td>
            <td><a href="refs/snapshot/2.x.x/fs-index.html">2.10.0</a></td>
            <td><a href="refs/release/3.0.5/fs-index.html">3.0.5</a></td>
            <td><a href="refs/snapshot/main/fs-index.html">3.0.6</a></td>
        </tr>
        <tr>
            <td>Spring Content Mongo (GridFS)</td>
            <td><a href="refs/release/2.9.0/mongo-index.html">2.9.0</a></td>
            <td><a href="refs/snapshot/2.x.x/mongo-index.html">2.10.0</a></td>
            <td><a href="refs/release/3.0.5/mongo-index.html">3.0.5</a></td>
            <td><a href="refs/snapshot/main/mongo-index.html">3.0.6</a></td>
        </tr>
        <tr>
            <td>Spring Content JPA</td>
            <td><a href="refs/release/2.9.0/jpa-index.html">2.9.0</a></td>
            <td><a href="refs/snapshot/2.x.x/jpa-index.html">2.10.0</a></td>
            <td><a href="refs/release/3.0.5/jpa-index.html">3.0.5</a></td>
            <td><a href="refs/snapshot/main/jpa-index.html">3.0.6</a></td>
        </tr>
        <tr>
            <th colspan=9>Renditions</th>
        </tr>
        <tr>
            <td>Spring Content Renditions</td>
            <td><a href="refs/release/2.9.0/renditions-index.html">2.9.0</a></td>
            <td><a href="refs/snapshot/2.x.x/renditions-index.html">2.10.0</a></td>
            <td><a href="refs/release/3.0.5/renditions-index.html">3.0.5</a></td>
            <td><a href="refs/snapshot/main/renditions-index.html">3.0.6</a></td>
        </tr>
        <tr>
            <th colspan=9>Versioning</th>
        </tr>
        <tr>
            <td>Spring Versions JPA</td>
            <td><a href="refs/release/2.9.0/jpaversions-index.html">2.9.0</a></td>
            <td><a href="refs/snapshot/2.x.x/jpaversions-index.html">2.10.0</a></td>
            <td><a href="refs/release/3.0.5/jpaversions-index.html">3.0.5</a></td>
            <td><a href="refs/snapshot/main/jpaversions-index.html">3.0.6</a></td>
        </tr>
        <tr>
            <th colspan=9>Fulltext Indexing</th>
        </tr>
        <tr>
            <td>Spring Content Solr</td>
            <td><a href="refs/release/2.9.0/solr-index.html">2.9.0</a></td>
            <td><a href="refs/snapshot/2.x.x/solr-index.html">2.10.0</a></td>
            <td><a href="refs/release/3.0.5/solr-index.html">3.0.5</a></td>
            <td><a href="refs/snapshot/main/solr-index.html">3.0.6</a></td>
        </tr>
        <tr>
            <td>Spring Content Elasticsearch</td>
            <td><a href="refs/release/2.9.0/elasticsearch-index.html">2.9.0</a></td>
            <td><a href="refs/snapshot/2.x.x/elasticsearch-index.html">2.10.0</a></td>
            <td><a href="refs/release/3.0.5/elasticsearch-index.html">3.0.5</a></td>
            <td><a href="refs/snapshot/main/elasticsearch-index.html">3.0.6</a></td>
        </tr>
        <tr>
            <th colspan=9>APIs</th>
        </tr>
        <tr>
            <td>Spring Content REST</td>
            <td><a href="refs/release/2.9.0/rest-index.html">2.9.0</a></td>
            <td><a href="refs/snapshot/2.x.x/rest-index.html">2.10.0</a></td>
            <td><a href="refs/release/3.0.5/rest-index.html">3.0.5</a></td>
            <td><a href="refs/snapshot/main/rest-index.html">3.0.6</a></td>
        </tr>
        <tr>
            <td>Spring Content CMIS</td>
            <td><a href="refs/release/2.9.0/cmis-index.html">2.9.0</a></td>
            <td><a href="refs/snapshot/2.x.x/cmis-index.html">2.10.0</a></td>
            <td><a href="refs/release/3.0.5/cmis-index.html">3.0.5</a></td>
            <td><a href="refs/snapshot/main/cmis-index.html">3.0.6</a></td>
        </tr>
    </tbody>
</table>
