#### Spring Content

Cloud-Native Headless Content Services for Spring.

For creating services that manage content such as documents, images and digital assets such as video.  

Build your own cloud-native, scale-out headless content services using the exact same components as the Enterprise Content Management (ECM) vendors such as Documentum and OpenText, without the hassle.   


## Features

- Standardized content access no matter where it is stored  

- Content/metadata association   

- Content Search

- Content Transformation


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

- Spring Versions Commons - Locking and versioning semantics for Entities and associated content

- Spring Versions JPA - JPA-based implementation of locking and versioning

- Spring Data REST - Exports Spring Content stores as hypermedia-driven RESTful resources

### Coming Soon

- Spring Content ElasticSearch - Content indexing and search with Amazon Elastic Search

- Spring Content CMIS - CMIS-compliant entity model and REST API

## Overview

<center>![spring-content-arch](spring-content-arch.jpg)</center>
<center>_Figure 1. understanding how Spring Content fits into the Spring eco-system_</center>

## Quick Start

```
<dependency>
    <groupId>com.github.paulcwarren</groupId>
    <artifactId>spring-content-fs-boot-starter</artifactId>
    <version>0.6.0</version>
</dependency>
```

For a quick taste, look at the following domain object:

```
@Entity
public class SopDocument {

	private @Id @GeneratedValue Long id;
	private String title;
	private String[] authors, keywords;

	// Spring Content managed attribute
	private @ContentId String contentId;

  	private SopDocument() {}
	public SopDocument(String title, String[] authors, String[] keywords) 	{
		this.title = title;
		this.authors = authors;
		this.keywords = keywords;
	}
}
```

This defines a simple JPA entity with a few structured data fields; title, authors and keywords and one Spring Content-managed data field; `@ContentId`.  

The structured data fields are handled in the usual way through a `CrudRepository<SopDocument,String>` interface.  

Content is handled separately with a ContentStore interface:-

```
public interface SopDocumentContent extends ContentStore<SopDocument, String> {
}
```

This interface extends Spring Content’s `ContentStore`, defines the type (SopDocument) and the id type (String).  Put this code inside a Spring Boot application with `spring-boot-starter-data-jpa` and `spring-content-fs-boot-starter` like this:

```
@SpringBootApplication
public class MyApp {

    public static void main(String[] args) {
        SpringApplication.run(MyApp.class, args);
    }
}
```

Launch your app and Spring Content (having been autoconfigured by Boot) will automatically craft a concrete set of operations for handling content associated with this Entity:

- `setContent(S property, InputStream content)`

- `InputStream getContent(S property)`

- `unsetContent(S property)`

To see more following out first [Getting Started Guide](spring-content-fs-docs.md), or watch our [SpringOne 2016 talk](https://bit.ly/springone-vid).

## Reference Documentation

| Module  |   |   |
|---|---|---|
| Spring Content S3 | [Current](refs/snapshot/s3-index.html)  | [Lastest Release](refs/release/s3-index.html)  |
| Spring Content Filesystem | [Current](refs/snapshot/fs-index.html)  |  [Lastest Release](refs/release/fs-index.html) |
| Spring Content Mongo  | [Current](refs/snapshot/mongo-index.html)  | [Lastest Release](refs/release/mongo-index.html)  |  
| Spring  REST  | [Current](refs/snapshot/rest-index.html)  | [Lastest Release](refs/release/rest-index.html) |  
| Spring Content JPA  | [Current](refs/snapshot/jpa-index.html)  | [Lastest Release](refs/release/jpa-index.html)  |  
| Spring Versions JPA  | [Current](refs/snapshot/jpaversions-index.html)  | [Lastest Release](refs/release/jpaversions-index.html)  |  
| Spring Content REST  | [Current](refs/snapshot/rest-index.html)  | [Lastest Release](refs/release/rest-index.html) |  
