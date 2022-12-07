# Getting Started Spring Content with Encryption

## What you'll build

We'll build on the previous guide [Getting Started with Spring Content REST API](spring-content-rest-docs.md).

## What you'll need

- About 30 minutes

- A favorite text editor or IDE

- JDK 1.8 or later

- Maven 3.0+

- Docker Desktop (for the vault test container)

## How to complete this guide

Before we begin let's set up our development environment:

- Download and unzip the source repository for this guide, or clone it
using Git: `git clone https://github.com/paulcwarren/spring-content-gettingstarted.git`

- We are going to start where Getting Started with Spring Content REST API leaves off so
 `cd` into `spring-content-gettingstarted/spring-content-rest/complete`

When you’re finished, you can check your results against the code in
`spring-content-gettingstarted/spring-content-with-encryption/complete`.

## Update dependencies

Add the `com.github.paulcwarren:spring-content-encryption` dependency.  This provides us the implementation of a EncryptingContentStore.

Also add `org.testcontainers:vault:1.17.6`.  We are going to use vault to provide a keyring for encrypting the content encryption key which in turn is used to encrypt the content. 

`pom.xml`

```java
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-with-encryption/complete/pom.xml 1-60}
```

## Vault TestContainer

First we add a simple class that creates and starts a vault test container upon demand.  The vault is configured with a vault token `root-token` (referenced later) and enables the transit module that provides cryptographic functions to the encrypting content store. 

`src/main/java/gettingstarted/VaultContainerSupport.java`

{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-with-encryption/complete/src/main/java/gettingstarted/VaultContainerSupport.java 1-}


## Configuration

Next we need to introduce a small `Configuration` class to provide a vault endpoint to our application as well as configuring our encrypting content store.  We add the following `@Configuration` to our `SpringContentApplication`.

`src/main/java/gettingstarted/SpringContentApplication.java`

{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-with-encryption/complete/src/main/java/gettingstarted/SpringContentApplication.java 1-}

Points to note:
- the `clientAuthentication` references the `root-token`
- the `encrypter` bean creates an instance an `EnvelopeEncryptionService`.  This is used by the `EncyptingContentStore` to provide [envelope encryption](https://docs.aws.amazon.com/wellarchitected/latest/financial-services-industry-lens/use-envelope-encryption-with-customer-master-keys.html) on the content.
- the `config` bean configures the `EnryptingContentStore` specifying the vault keyring to use to encrypt the content encryption key and the content property attribute to use to store that encrypted key for later use when decrypting content.

## Update File

Update File to add the new content property attribute called `key` that will store the encrypted content encryption key.

`src/main/java/gettingstarted/File.java`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-with-encryption/complete/src/main/java/gettingstarted/File.java 1-33}
```

## Update FileContentStore

Decorate the `FileContentStore` as an `EncryptingContentStore` to enable encryption/decryption on the content.

`src/main/java/gettingstarted/FileContentStore.java`

```
{snippet: https://raw.githubusercontent.com/paulcwarren/spring-content-gettingstarted/main/spring-content-with-encryption/complete/src/main/java/gettingstarted/FileContentStore.java 1-}
```

## Build an executable JAR

If you are using Maven, you can run the application using `mvn spring-boot:run`.
Or you can build the JAR file with `mvn clean package` and run the JAR
by typing:

`java -jar target/gettingstarted-spring-content-with-encryption-0.0.1.jar`

As the application starts up look for the root of the filesystem storage.  We'll look in here shortly to check content is encrypted.  Look for the 
log entry that starts `Default filesystem storage to ...` and copy the file path. e.g. 

```
2022-12-06 21:45:14.180  INFO 89223 --- [           main] o.s.c.fs.io.FileSystemResourceLoader     : Defaulting filesystem root to /var/folders/65/d8zxcwh13sjfrkry92vgs5x80000gr/T/13946690314057106966
```

## Test Encryption

Create an entity:

`$ curl -X POST -H 'Content-Type:application/hal+json' -d '{}' http://localhost:8080/files/`

Associate content with that entity:

`$ curl -X PUT -H 'Content-Type:text/plain' -d 'Hello Spring Content World!' http://localhost:8080/files/1/content`

Get the content id:

```
$ curl -X GET -H 'Accept:application/hal+json' http://localhost:8080/files/1
{
  "name" : null,
  "created" : "2022-12-07T05:47:42.356+00:00",
  "summary" : null,
  "contentId" : "2d654dfc-57dc-44b7-aad9-f9ad0701c5d1",
  "contentLength" : 27,
  "contentMimeType" : "text/plain",
  "_links" : {
    "self" : {
      "href" : "http://localhost:8080/files/1"
    },
    "file" : {
      "href" : "http://localhost:8080/files/1"
    },
    "content" : {
      "href" : "http://localhost:8080/files/1/content"
    }
  }
}
```

Copy the `contentId`

Check the content is encrypted:

`$ cat /var/folders/65/d8zxcwh13sjfrkry92vgs5x80000gr/T/13946690314057106966/<contnetId>`

i.e.

```
$ cat /var/folders/65/d8zxcwh13sjfrkry92vgs5x80000gr/T/13946690314057106966/2d654dfc-57dc-44b7-aad9-f9ad0701c5d1
��H�}��l������إ�.��^
```

Fetch the content:

```
$ curl -H 'Accept:text/plain' http://localhost:8080/files/1/content
Hello Spring Content World!
```

## Summary

Congratulations!  You've just written a simple application that uses Spring Content and Spring Content Encryption to be store content encrypted.

Spring Content Encryption is also capable of serving bytes ranges.  The default implementation uses AES CTR encryption and when used with Spring Content S3 will decrypt and serve just the byte ranges.  With any other storage the content will be fully decrypted before serving the byte range.