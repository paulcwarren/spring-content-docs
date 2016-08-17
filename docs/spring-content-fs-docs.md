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

- Download and unzip the source repository for this guide, or clone it using Git: `git clone https://github.com/EMC-Dojo/spring-content-gettingstarted.git`
- `cd` into `spring-content-gettingstarted/spring-content-fs/initial`
- Jump ahead to `Define a simple entity`.
When you’re finished, you can check your results against the code in `spring-content-gettingstarted/spring-content-fs/complete`.

## Build with Maven

First you set up a basic build script. You can use any build system you like when building apps with Spring, but the code you need to work with [Maven](https://maven.apache.org/) is included here.  If you’re not familiar with Maven, refer to [Building Java Projects with Maven](http://spring.io/guides/gs/maven). 
 
### Create a directory structure

In a project directory of your choosing, create the following subdirectory structure; for example, with `mkdir -p src/main/java/gettingstarted/springcontentfs` on *nix systems:

```
∟ src
   ∟ main
       ∟ java
           ∟ gettingstarted
               ∟ springcontentfs
       ∟ resources
           ∟ static
```

`pom.xml`

```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>

	<groupId>com.emc.spring.content</groupId>
	<artifactId>gettingstarted-spring-content-fs</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<packaging>jar</packaging>

	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>1.4.0.RELEASE</version>
	</parent>

	<properties>
		<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
		<java.version>1.8</java.version>
	</properties>

	<dependencies>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-data-jpa</artifactId>
			<scope>test</scope>
		</dependency>
		<dependency>
			<groupId>com.h2database</groupId>
			<artifactId>h2</artifactId>
			<scope>test</scope>
		</dependency>
		<dependency>
			<groupId>com.emc.spring.content</groupId>
			<artifactId>spring-content-fs-boot-starter</artifactId>
			<version>0.0.1-SNAPSHOT</version>
		</dependency>
	</dependencies>

	<build>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
			</plugin>
		</plugins>
	</build>
</project>
```

We add several dependencies:-
 
- Spring Boot Starter Web provides the web server framework
- Spring Boot Starter Data JPA will provide a relational database to store metadata of our files.  In this case we are using the H2 in-memory database.
- Spring Boot Starter Data REST will provide REST endpoints for our File metadata
- Spring Boot Starter Content FS will provide a Filesystem-backed content repository for the content of each file.  Content will be automatically associated this with it's owning Entity by Spring Content.

## Define a simple Entity

Let's define a simple Entity to represent a File.

`src/main/java/gettingstarted/springcontentfs/File.java`

```
package gettingstarted.springcontentfs;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import com.emc.spring.content.commons.annotations.ContentId;
import com.emc.spring.content.commons.annotations.ContentLength;

@Entity
public class File {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long id;
	private String name;
	private Date created = new Date();
	private String summary;

	@ContentId private String contentId;
	@ContentLength private long contentLength;
	private String mimeType = "text/plain";

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public Date getCreated() {
		return created;
	}
	
	public void setCreated(Date created) {
		this.created = created;
	}

	public String getSummary() {
		return summary;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}

	public String getContentId() {
		return contentId;
	}

	public void setContentId(String contentId) {
		this.contentId = contentId;
	}

	public long getContentLength() {
		return contentLength;
	}

	public void setContentLength(long contentLength) {
		this.contentLength = contentLength;
	}

	public String getMimeType() {
		return mimeType;
	}

	public void setMimeType(String mimeType) {
		this.mimeType = mimeType;
	}
}
```

As you would expect we created a standard JPA Entity to capture some metadata about our file; `name` and `summary`.  In addition, because we will be serving these files over the web, we also record `mimeType` so that we can instruct the browser correctly.

We then add two annotated Spring Content fields; `@ContentId` and `@ContentLength`.  `@ContentId` allows us to associate a stream of binary data with an Entity and `@ContentLength` records the length of that stream.  These will be automatically managed by Spring Content.

## Create a File Repository

Next, as you would also expect, we create a `CrudRepository` for handling File entities and we export it as a `@RepositoryRestResource` so, for the cost of writing just one interface (and annotating it), we get the ability to create, read, update and delete File entities using REST endpoints.

> NB. For more information on Spring Data JPA and Spring Data REST see their respective spring.io Getting Started guides.

`src/main/java/gettingstated/springcontentfs/FileRepoistory.java`

```
package gettingstarted.springcontentfs;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(path="files", collectionResourceRel="files")
public interface FileRepository extends JpaRepository<File, Long> {

}
```  

## Create a File ContentRepository

Similarly, we then create a `ContentRepository` for handling content associated with the File entity.

`src/main/java/gettngstarted/springcontentfs/FileContentRepository.java`

```
package gettingstarted.springcontentfs;

import com.emc.spring.content.commons.repository.ContentStore;

public interface FileContentRepository extends ContentStore<File, String> {
}
```

Let's investigate this interface:-

- `ContentStore` provides several methods for handling content; setContent, getContent and unsetContent
- The dependency `com.emc.spring.content:spring-content-fs-boot-starter` provides a Filesystem-backed implementation of this interface and Spring Boot with Spring Content together ensure that this implementation will be used wherever the `FileContentRepository` is `@Autowired`.

## Create a File Controller

So now we have a way to create, read, update and delete File entities from our web UI using the `FileRepository` REST endpoints.  

We also have a way to handle content but we unlike Spring Data we don't automtically get REST endpoints for managing this content so we need to create these endpoints, using the  `FileContentRepository` to help us.

`src/main/java/gettingstarted/springcontentfs/FileContentController.java`

```
package gettingstarted.springcontentfs;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class FileContentController {

	@Autowired private FileRepository filesRepo;
	@Autowired private FileContentRepository contentsRepo;
	
	@RequestMapping(value="/files/{fileId}/content", method = RequestMethod.PUT)
	public ResponseEntity<?> setContent(@PathVariable("fileId") Long id, @RequestParam("file") MultipartFile file) 
			throws IOException {

		File f = filesRepo.findOne(id);
		f.setMimeType(file.getContentType());
		
		// save updated content-related info
		contentsRepo.setContent(f, file.getInputStream());
		filesRepo.save(f);
			
		return new ResponseEntity<Object>(HttpStatus.OK);
	}

	@RequestMapping(value="/files/{fileId}/content", method = RequestMethod.GET)
	public ResponseEntity<?> getContent(@PathVariable("fileId") Long id) {

		File f = filesRepo.findOne(id);
		InputStreamResource inputStreamResource = new InputStreamResource(contentsRepo.getContent(f));
		HttpHeaders headers = new HttpHeaders();
		headers.setContentLength(f.getContentLength());
		headers.set("Content-Type", 	f.getMimeType());
		return new ResponseEntity<Object>(inputStreamResource, headers, HttpStatus.OK);
	}
}
```
Let's explain this class.  

- It's a standard Spring Controller with two request mapped methods, one for setting content and the other for getting content. 
- Both `setContent` and `getContent` methods inject themselves into the URI space of the `FileRepository`, namely `/files/{fileId}`, exporting an additional `/content` endpoint.
- We inject our `FileRepository` and our `FileContentRepository`.  Respectively, Spring Boot will ensure real implementations are injected (based on what Spring Data and Spring Content modules are found on the class path). 
- `setContent` uses the `FileRepository` to fetch the File entity  using the given `fileId` and then uses the `FileContentRepository` to save the given file input stream.  
- Similarly, `getContent` uses the `FileRepository` to fetch the File entity using the given `fileId` and again use the `FileContentRepository` to fetch the associated content and stream it back to the client as the response.  We also use previosuly saved metdata `contentLength` and `mimeType` to set http headers appropriately.  This will mean that browsers can handle the content correctly by launching the relevant desktop application.

## Create Web Client

Now let's create a really simple angular web front-end for our document list.  

`src/main/resources/static/index.html`

```
<!doctype html>
<html ng-app="filesApp">
  <head>
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.5.8/angular.min.js"></script>
    <script src="files.js"></script>
  </head>
  <body>
    <div ng-controller="FilesListController as filesList">
	    <h1>Files</h1>
	    
	    <section style="display: table; width: 80%">
		  <header style="display: table-row;">
		    <div style="display: table-cell;">Name</div>
		    <div style="display: table-cell;">Length</div>
		    <div style="display: table-cell;">Created</div>
		    <div style="display: table-cell;">Summary</div>
		  </header>
		  <div style="display: table-row;" ng-repeat="file in filesList.files">
		    <div style="display: table-cell;"><a href="{{filesList.getHref(file)}}" target="_new">{{file.name}}</a></div>
		    <div style="display: table-cell;"><label>{{file.contentLength}}</label></div>
		    <div style="display: table-cell;"><label>{{file.created}}</label></div>
		    <div style="display: table-cell;"><label>{{file.summary}}</label></div>
		  </div>
		</section>
	    
	    <h2>New File</h2>
	    <input type="file" id="file" name="file"/>
	    <input type="summary" id="summary" name="summary" ng-model="filesList.summary" placeholder="Summary"/>
		<button ng-click="filesList.upload()">Upload</button>
    </div>
  </body>
</html>
```

This HTML presents a simple list of files using an `ng-repeat` directive and contains a simple form allowing new files to be uploaded. 

All the interesting code is in the code-behind file so add the following code behind to `src/main/resources/static/files.js`

```
angular.module('filesApp', [])
  .controller('FilesListController', function($http) {
    var filesList = this;
    filesList.files = []; 
    
    filesList.getFilesList = function() {
        $http.get('/files/').
            success(function(data, status, headers, config) {
                if (data._embedded != undefined) {
        			filesList.files = [];
                    angular.forEach(data._embedded.files, function(file) {
                        filesList.files.push(file);
	                });
	            }
	        });
	    };
    filesList.getFilesList(); 
    
    filesList.getHref = function(file) {
    	return file._links["self"].href + "/content/"
    };

    filesList.upload = function() {
    	var f = document.getElementById('file').files[0];
    	var file = {name: f.name, summary: filesList.summary};
    	
    	$http.post('/files/', file).
    		then(function(response) {
	    		var fd = new FormData();
	            fd.append('file', f);
	            return $http.put(response.headers("Location") + "/content", fd, {
	                transformRequest: angular.identity,
	                headers: {'Content-Type': undefined}
	            });
	        })
	        .then(function(response) {
    			filesList.title = "";
    			filesList.keywords = "";
    			filesList.getFilesList();
    			document.getElementById('file').files[0] = undefined;
	        });
    }
    
  });
```

This angular controller has the following functions:-

- `getFilesList` queries our `FileRepository` via its REST endpoint `files/` and adds the list of files that are returned to `filesList.files` (presented by the `ng-repeat` directive in the HTML)
- `getHref` returns a `file`'s content hyperlink `files/{fileId}/content/` (that ultimately calls `FileContentController.getContent`) 
- `upload` uploads a new File by first `POST`ing to the `FileRepository` REST endpoints `/files` and once created  `PUT`ing the actual content to the Files content REST endpoint `files/{fileId}/content/` (that ultimately calls `FileContentController.setContent`)   

## Create an Application class

Our simple document list app is now complete.  All that remains is to add the usual Spring Boot Application class.

`src/main/java/gettingstarted/springcontentfs/SpringContentFsApplication.java`

```
package gettingstarted.springcontentfs;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class SpringContentFsApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringContentFsApplication.class, args);
	}
}
```

## Build an executable JAR

If you are using Maven, you can run the application using `mvn spring-boot:run`.  Or you can build the JAR file with `mvn clean package` and run the JAR by typing:

`java -jar target/gs-accessing-data-jpa-0.1.0.jar`

And then point your browser at:-

`http://localhost:8080` 

and you should see something like this:-

![Spring Content Webapp](spring-content-fs-webapp.png)

Exercise the application by uploading a range of new files and viewing them.  You should see viewed files open in a new tab in their associated editor.

## Summary

Congratulations! You’ve written a simple application that uses Spring Content to manage streams of binary data - all without writing a concrete implementation.
    
Spring Content supports the following implementation modules:-

- Spring Content Filesystem; stores content on the Filesystem (as used in this tutorial)
- Spring Content S3; stores content in Amazon S3
- Spring Content JPA; stores content as BLOBs in the database
- Spring Content MongoDB; stores content in Mongo's GridFs

## Look Forward

In this tutorial we built a simple document list web application using Spring Content.  

The majority of the work on the server-side was writing the Spring controller for handling the Content.  Check out our next [getting started guide](spring-content-rest-docs.md) where we'll use the companion library Spring Content REST to automatically export these REST endpoints for our `FileContentRepository` saving ourselves even more work.
