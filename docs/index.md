# Spring-Content

Extensions for Spring-Data that add primitives for handling BLOBs (unstructured data) in the same Developer-friendly way that you handle your structured data.

Spring Content provides modules for JPA, MongoDB, S3 and the Filesystem.

## Quick Start

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

This defines a simple JPA entity with a few structured data fields; title, authors and keywords and one Spring Content-managed; @ContentId.  The structured data fields are handled in the usual way through a `CrudRepository<SopDocument,String>` interface.  BLOB Content is handled separately with a ContentRepository interface:-

```
public interface ContentRepository extends ContentRepository<SopDocument, String> {
}
```

This interface extends Spring Content’s ContentRepository and defines the type (SopDocument) and the id type (String).  Put this code inside a Spring Boot application with spring-boot-starter-data-jpa and spring-content-jpa-boot-starter like this:

```
@SpringBootApplication
public class MyApp {

    public static void main(String[] args) {
        SpringApplication.run(MyApp.class, args);
    }
}
```

Launch your app and Spring Content (having been autoconfigured by Boot) will automatically craft a concrete set of operations for handling content for this Entity:

- `setContent(S property, InputStream content)`
- `unsetContent(S property)`
- `InputStream getContent(S property)`


