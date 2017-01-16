# Spring Content

Extensions for Spring-Data that add primitives for handling BLOBs (unstructured data) in the same Developer-friendly way that you handle your structured data.

It makes it easy to create websites, content management systems and any other application that has to manage content such as images, documents and videos.

### Features

- Easily wrap content with metadata 
- Transform content into different forms with its extensible Rendtion mechanism 
- Fully integrated into Spring Data and Spring Data REST

### Modules

Spring Content provides modules for storing content in JPA, MongoDB, S3 and on the Filesystem.

## Quick Start

```
<dependency>
    <groupId>com.github.paulcwarren</groupId>
    <artifactId>spring-content-fs-boot-starter</artifactId>
    <version>0.0.3</version>
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
	private @ContentId String contentId

  	private SopDocument() {}
	public SopDocument(String title, String[] authors, String[] keywords) 	{
		this.title = title;
		this.authors = authors;
		this.keywords = keywords;
	}
}
```

This defines a simple JPA entity with a few structured data fields; title, authors and keywords and one Spring Content-managed; @ContentId.  

The structured data fields are handled in the usual way through a `CrudRepository<SopDocument,String>` interface.  

BLOB content is handled separately with a ContentRepository interface:-

```
public interface ContentRepository extends ContentStore<SopDocument, String> {
}
```

This interface extends Spring Content’s ContentRepository and defines the type (SopDocument) and the id type (String).  Put this code inside a Spring Boot application with spring-boot-starter-data-jpa and spring-content-fs-boot-starter like this:

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


