# Complete Spring Boot CRUD API Guide - From Scratch to Production

## 📚 Table of Contents
1. [Introduction](#introduction)
2. [What is Spring Boot?](#what-is-spring-boot)
3. [Architecture & Layers](#architecture--layers)
4. [Step 1: Create Project from Spring Initializer](#step-1-create-project-from-spring-initializer)
5. [Step 2: Project Structure Overview](#step-2-project-structure-overview)
6. [Step 3: Database Configuration](#step-3-database-configuration)
7. [Step 4: Create Entity Layer](#step-4-create-entity-layer)
8. [Step 5: Create Repository Layer](#step-5-create-repository-layer)
9. [Step 6: Create DAO Layer](#step-6-create-dao-layer)
10. [Step 7: Create Service Layer](#step-7-create-service-layer)
11. [Step 8: Create Controller Layer](#step-8-create-controller-layer)
12. [Step 9: Run the Application](#step-9-run-the-application)
13. [API Endpoints Overview](#api-endpoints-overview)
14. [Complete Request/Response Examples](#complete-requestresponse-examples)
15. [Common Concepts Explained](#common-concepts-explained)

---

## Introduction

This guide will teach you how to build a REST API using Spring Boot from complete scratch. We'll build a **User Management CRUD API** that allows:
- **C**reate - Add new users
- **R**ead - Get user information
- **U**pdate - Modify user details
- **D**elete - Remove users

### Prerequisites
- Java 17+ installed
- Maven installed
- MySQL Server running
- VS Code or IntelliJ IDEA
- Postman (for testing APIs)

---

## What is Spring Boot?

**Spring Boot** is a framework that makes it easy to create stand-alone, production-grade Spring-based Applications. It simplifies the setup and development process by:

- Auto-configuring Spring applications
- Providing embedded servers (Tomcat)
- Reducing boilerplate code
- Easy dependency management

### Key Benefits:
✅ Convention over configuration  
✅ Embedded web server  
✅ Built-in dependency injection  
✅ Easy to test  
✅ Production-ready out of the box  

---

## Architecture & Layers

Our application follows a **Layered Architecture** pattern:

```
┌─────────────────────────────────────────┐
│         REST CLIENT (Postman)           │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│    CONTROLLER LAYER (@RestController)   │
│  - Handles HTTP requests/responses      │
│  - Routes requests to services          │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│     SERVICE LAYER (@Service)            │
│  - Business logic                       │
│  - Data validation                      │
│  - Exception handling                   │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│       DAO LAYER (@Component)            │
│  - Data access object                   │
│  - Acts as bridge between service       │
│    and repository                       │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│   REPOSITORY LAYER (@Repository)        │
│  - JPA interface                        │
│  - Database operations                  │
│  - CRUD methods                         │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│    ENTITY LAYER (@Entity)               │
│  - Database table mapping               │
│  - Java objects representing tables     │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│      DATABASE (MySQL)                   │
│  - Stores actual data                   │
└─────────────────────────────────────────┘
```

### Why This Layering?
- **Separation of Concerns** - Each layer has a specific responsibility
- **Reusability** - Logic can be used by multiple controllers
- **Testability** - Easy to write unit tests for each layer
- **Maintainability** - Changes in one layer don't affect others
- **Scalability** - Easy to add new features

---

## Step 1: Create Project from Spring Initializer

### Method 1: Using Spring Initializer Website

1. Visit **[start.spring.io](https://start.spring.io)**

2. **Fill in the form:**
   - **Project**: Maven Project
   - **Language**: Java
   - **Spring Boot**: 3.2.1 (or latest stable)
   - **Project Metadata:**
     - Group: `com.codetikki`
     - Artifact: `crud`
     - Name: `crud`
     - Description: `crud operation with rest api`
     - Package name: `com.codetikki.crud`
     - Packaging: Jar
     - Java: 17 (or your installed version)

3. **Add Dependencies** (Click "ADD DEPENDENCIES"):
   - Spring Web (REST APIs)
   - Spring Data JPA (Database operations)
   - MySQL Driver (Database connection)
   - Lombok (Reduce boilerplate)

4. Click **"GENERATE"** - This downloads a ZIP file

5. Extract the ZIP file to your desired location

6. Open in VS Code or IntelliJ IDEA

### Method 2: Using VS Code Extension

1. Install "Spring Boot Extension Pack" in VS Code
2. Use the command palette (Ctrl+Shift+P)
3. Search for "Spring Initializr"
4. Follow the guided setup

---

## Step 2: Project Structure Overview

After creation, your project will have this structure:

```
crud/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── codetikki/
│   │   │           └── crud/
│   │   │               ├── CrudApplication.java       (Main class)
│   │   │               ├── controller/
│   │   │               │   └── UserController.java    (API endpoints)
│   │   │               ├── service/
│   │   │               │   └── UserService.java       (Business logic)
│   │   │               ├── dao/
│   │   │               │   └── UserDao.java           (Data access)
│   │   │               ├── repository/
│   │   │               │   └── UserRepository.java    (JPA interface)
│   │   │               └── entity/
│   │   │                   └── User.java              (Database model)
│   │   └── resources/
│   │       └── application.properties       (Configuration)
│   └── test/
│       └── java/
│           └── CrudApplicationTests.java    (Unit tests)
├── pom.xml                                   (Maven dependencies)
├── mvnw & mvnw.cmd                          (Maven wrapper)
└── README.md
```

### What is Each File?

| File | Purpose |
|------|---------|
| `CrudApplication.java` | Entry point - runs the Spring Boot application |
| `application.properties` | Configuration file for database & server settings |
| `pom.xml` | Defines all project dependencies |
| `entity/User.java` | Java class that represents the database table |
| `repository/UserRepository.java` | Interface for database operations |
| `dao/UserDao.java` | Data access object for business operations |
| `service/UserService.java` | Contains business logic & validation |
| `controller/UserController.java` | Handles HTTP requests & responses |

---

## Step 3: Database Configuration

### Understanding application.properties

The `application.properties` file tells Spring Boot how to connect to your database.

**File Location**: `src/main/resources/application.properties`

```properties
# Application name
spring.application.name=crud

# ===== DATABASE CONNECTION =====
spring.datasource.url=jdbc:mysql://localhost:3306/crud
spring.datasource.username=root
spring.datasource.password=Password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# ===== JPA/HIBERNATE CONFIGURATION =====
# Auto-update schema on startup
# - create-drop: Create table on startup, drop on shutdown (for development)
# - update: Update existing tables (recommended for development)
# - validate: Only validate the schema
# - none: Don't do anything
spring.jpa.hibernate.ddl-auto=update

# Show SQL queries in console
spring.jpa.show-sql=true

# Specify the database dialect
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
```

### What Each Property Means:

| Property | Meaning | Example |
|----------|---------|---------|
| `spring.datasource.url` | Where MySQL is running | `jdbc:mysql://localhost:3306/crud` |
| `spring.datasource.username` | MySQL username | `root` |
| `spring.datasource.password` | MySQL password | `Password` |
| `ddl-auto` | How to handle schema changes | `update` |
| `show-sql` | Print SQL queries to console | `true` |

### Step 3.1: Create Database in MySQL

```sql
-- Open MySQL Command Line or MySQL Workbench
-- Create the database
CREATE DATABASE crud;

-- Use the database
USE crud;
```

The tables will be created automatically by Spring Boot (because of `ddl-auto=update`)!

---

## Step 4: Create Entity Layer

The Entity represents a database table as a Java class.

**File**: `src/main/java/com/codetikki/crud/entity/User.java`

```java
package com.codetikki.crud.entity;

import jakarta.persistence.*;

/**
 * User Entity - Represents the 'user' table in database
 * 
 * JPA Annotations:
 * @Entity - Marks this class as a database entity
 * @Table - Maps this class to a specific table name
 * @Id - Marks this field as primary key
 * @GeneratedValue - Auto-increments the ID
 * @Column - Maps field to column with properties
 */
@Entity
@Table(name = "user")
public class User {

    // ===== FIELDS =====
    
    /**
     * Primary Key
     * @Id - This is the primary key
     * @GeneratedValue(strategy = GenerationType.IDENTITY) - Auto-increment
     */
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Email field
     * @Column - Specifies column properties
     * - name: Column name in database
     * - nullable: Cannot be NULL
     * - unique: Must be unique (no duplicates)
     * - length: Maximum characters (100)
     */
    @Column(name = "email_id", nullable = false, unique = true, length = 100)
    private String emailId;

    /**
     * User's full name
     * - nullable = false: Name is required
     * - length = 100: Maximum 100 characters
     */
    @Column(nullable = false, length = 100)
    private String name;

    /**
     * WhatsApp number (optional field)
     * - Default is 15 characters max for phone numbers
     */
    @Column(name = "whatsapp_number", length = 15)
    private String whatsappNumber;

    /**
     * Gender field
     * - Optional field
     * - Typical values: Male, Female, Other
     */
    @Column(length = 10)
    private String gender;

    // ===== GETTERS & SETTERS =====
    
    /**
     * Getters and Setters allow accessing private fields
     * This is a Java best practice for encapsulation
     */
    
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getEmailId() {
        return emailId;
    }

    public void setEmailId(String emailId) {
        this.emailId = emailId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getWhatsappNumber() {
        return whatsappNumber;
    }

    public void setWhatsappNumber(String whatsappNumber) {
        this.whatsappNumber = whatsappNumber;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    /**
     * Optional: Override toString for better debugging
     */
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", emailId='" + emailId + '\'' +
                ", name='" + name + '\'' +
                ", whatsappNumber='" + whatsappNumber + '\'' +
                ", gender='" + gender + '\'' +
                '}';
    }
}
```

### What Will Be Created in Database:

```sql
CREATE TABLE user (
    id BIGINT NOT NULL AUTO_INCREMENT,
    email_id VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    whatsapp_number VARCHAR(15),
    gender VARCHAR(10),
    PRIMARY KEY (id)
) ENGINE=InnoDB;
```

### Key Concepts:

| Annotation | Purpose | Example |
|-----------|---------|---------|
| `@Entity` | Marks class as database entity | ✅ Required |
| `@Table(name="user")` | Maps to table name | Optional (defaults to class name) |
| `@Id` | Primary key | Must have one |
| `@GeneratedValue` | Auto-increment strategy | `IDENTITY` for MySQL |
| `@Column` | Column properties | nullable, unique, length |

---

## Step 5: Create Repository Layer

Repository is a JPA interface that provides CRUD methods automatically.

**File**: `src/main/java/com/codetikki/crud/repository/UserRepository.java`

```java
package com.codetikki.crud.repository;

import com.codetikki.crud.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * UserRepository - Provides database operations for User entity
 * 
 * JpaRepository<Entity, IDType>:
 * - First parameter: Entity class (User)
 * - Second parameter: ID type (Long)
 * 
 * By extending JpaRepository, we get these methods automatically:
 * - save(User): Insert/Update user
 * - findById(Long): Get user by ID
 * - findAll(): Get all users
 * - deleteById(Long): Delete user by ID
 * - delete(User): Delete user object
 * - exists(Long): Check if user exists
 * - count(): Count total users
 * 
 * @Repository: Spring annotation to mark this as a repository bean
 */
@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    /**
     * You can create custom query methods here
     * Spring Data JPA generates SQL automatically based on method names
     * 
     * Examples of custom methods:
     * 
     * // Find user by email
     * User findByEmailId(String emailId);
     * 
     * // Find all users with a specific gender
     * List<User> findByGender(String gender);
     * 
     * // Find user by name (case-insensitive)
     * User findByNameIgnoreCase(String name);
     * 
     * // Delete user by email
     * void deleteByEmailId(String emailId);
     */
}
```

### What Methods Are Available?

By extending `JpaRepository`, you automatically get:

```java
// CREATE/UPDATE
User user = userRepository.save(new User()); // Save new or update existing

// READ
Optional<User> user = userRepository.findById(1L);       // Get by ID
List<User> users = userRepository.findAll();              // Get all
boolean exists = userRepository.existsById(1L);           // Check existence

// DELETE
userRepository.deleteById(1L);                            // Delete by ID
userRepository.delete(user);                              // Delete object
userRepository.deleteAll();                               // Delete all

// COUNT
long count = userRepository.count();                      // Count total
```

### Custom Query Methods:

Spring Data JPA has a special syntax for creating queries automatically:

```java
// Method naming pattern: findBy + FieldName
User findByEmailId(String emailId);          // WHERE email_id = ?

// Multiple conditions
List<User> findByGenderAndName(String gender, String name);  // AND query

// Contains search
List<User> findByNameContaining(String name);    // LIKE '%name%'

// Greater than / Less than
List<User> findByIdGreaterThan(Long id);         // ID > ?

// Order by
List<User> findAllOrderByNameAsc();              // ORDER BY name ASC

// Not equal
List<User> findByGenderNot(String gender);       // WHERE gender != ?
```

---

## Step 6: Create DAO Layer

DAO (Data Access Object) acts as a bridge between Service and Repository.

**File**: `src/main/java/com/codetikki/crud/dao/UserDao.java`

```java
package com.codetikki.crud.dao;

import com.codetikki.crud.entity.User;
import com.codetikki.crud.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;

/**
 * UserDao - Data Access Object
 * 
 * Purpose:
 * - Acts as bridge between Service layer and Repository layer
 * - Provides business-level data access methods
 * - Allows easy switching between repository implementations
 * - Centralizes database operations
 * 
 * Why separate DAO from Repository?
 * - Repository is JPA interface (Spring responsibility)
 * - DAO is business logic wrapper (Our responsibility)
 * - If we need to change database (e.g., MongoDB), we only change DAO
 * 
 * @Component: Spring annotation to mark this as a bean
 */
@Component
public class UserDao {

    /**
     * @Autowired: Dependency Injection
     * Spring automatically creates UserRepository and injects it here
     * 
     * What is Dependency Injection?
     * Instead of creating objects with "new", Spring creates and provides them
     * 
     * Benefits:
     * - Loose coupling (don't depend on implementation)
     * - Easy testing (can mock the repository)
     * - Automatic lifecycle management
     */
    @Autowired
    private UserRepository userRepository;

    /**
     * Save a new user or update existing user
     * 
     * @param user: The user object to save
     * @return: The saved user (with generated ID if new)
     */
    public User save(User user) {
        return userRepository.save(user);
    }

    /**
     * Get all users from database
     * 
     * @return: List of all users
     */
    public List<User> findAll() {
        return userRepository.findAll();
    }

    /**
     * Get user by ID
     * 
     * @param id: User ID to search for
     * @return: Optional containing user if found, empty if not found
     * 
     * What is Optional?
     * Optional is a container that may or may not contain a value
     * It's better than null because:
     * - Makes code more readable
     * - Forces you to handle missing data
     * - Prevents NullPointerException
     */
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    /**
     * Delete user by ID
     * 
     * @param id: User ID to delete
     */
    public void deleteById(Long id) {
        userRepository.deleteById(id);
    }

    /**
     * Delete a user object
     * 
     * @param user: The user object to delete
     */
    public void delete(User user) {
        userRepository.delete(user);
    }

    /**
     * Check if user exists
     * 
     * @param id: User ID to check
     * @return: true if exists, false otherwise
     */
    public boolean existsById(Long id) {
        return userRepository.existsById(id);
    }

    /**
     * Count total users
     * 
     * @return: Total number of users
     */
    public long count() {
        return userRepository.count();
    }
}
```

### When to Use DAO Pattern?

✅ **Use DAO when:**
- You want to hide repository implementation
- You need transaction management
- You want centralized database operations
- Your application is complex

❌ **Skip DAO if:**
- Simple CRUD application
- Small project with few operations
- Direct service-to-repository is acceptable

In your project, we use DAO to keep code organized!

---

## Step 7: Create Service Layer

Service layer contains business logic and validation.

**File**: `src/main/java/com/codetikki/crud/service/UserService.java`

```java
package com.codetikki.crud.service;

import com.codetikki.crud.dao.UserDao;
import com.codetikki.crud.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * UserService - Business Logic Layer
 * 
 * Responsibilities:
 * 1. Validate user input
 * 2. Implement business rules
 * 3. Handle exceptions
 * 4. Call DAO for database operations
 * 5. Apply transformations if needed
 * 
 * Why separate Service from Controller?
 * - Reusability: Same service can be used by multiple controllers
 * - Testability: Easy to test business logic separately
 * - Maintainability: Business logic in one place
 * - Scalability: Easy to add new features
 * 
 * @Service: Spring annotation marking this as a service bean
 */
@Service
public class UserService {

    /**
     * Dependency Injection of UserDao
     * UserService depends on UserDao to perform database operations
     */
    @Autowired
    private UserDao userDao;

    /**
     * CREATE: Add a new user
     * 
     * Business Logic:
     * - Validate email is not empty
     * - Call DAO to save
     * - Return saved user
     * 
     * @param user: User object to create
     * @return: Saved user with generated ID
     * @throws IllegalArgumentException: If email is null or empty
     */
    public User createUser(User user) {
        // Business Logic 1: Validate email
        if (user.getEmailId() == null || user.getEmailId().isEmpty()) {
            throw new IllegalArgumentException("Email ID cannot be null or empty");
        }

        // Business Logic 2: Can add more validations
        if (user.getName() == null || user.getName().isEmpty()) {
            throw new IllegalArgumentException("Name cannot be null or empty");
        }

        // If validations pass, save to database
        return userDao.save(user);
    }

    /**
     * READ: Get all users
     * 
     * @return: List of all users from database
     */
    public List<User> getAllUsers() {
        return userDao.findAll();
    }

    /**
     * READ: Get specific user by ID
     * 
     * @param id: User ID to search for
     * @return: Optional containing user if found
     */
    public Optional<User> getUserById(Long id) {
        return userDao.findById(id);
    }

    /**
     * UPDATE: Modify existing user
     * 
     * Process:
     * 1. Check if user exists
     * 2. Update only provided fields
     * 3. Save updated user
     * 4. Return updated user
     * 
     * @param id: ID of user to update
     * @param userDetails: User object with new data
     * @return: Updated user
     * @throws RuntimeException: If user not found
     */
    public User updateUser(Long id, User userDetails) {
        // Step 1: Find existing user
        Optional<User> optionalUser = userDao.findById(id);

        // Step 2: Check if user exists
        if (optionalUser.isPresent()) {
            // Get the user object
            User user = optionalUser.get();

            // Step 3: Update fields if provided
            if (userDetails.getName() != null) {
                user.setName(userDetails.getName());
            }
            if (userDetails.getEmailId() != null) {
                user.setEmailId(userDetails.getEmailId());
            }
            if (userDetails.getWhatsappNumber() != null) {
                user.setWhatsappNumber(userDetails.getWhatsappNumber());
            }
            if (userDetails.getGender() != null) {
                user.setGender(userDetails.getGender());
            }

            // Step 4: Save updated user
            return userDao.save(user);
        } else {
            // If user doesn't exist, throw exception
            throw new RuntimeException("User not found with id: " + id);
        }
    }

    /**
     * DELETE: Remove user
     * 
     * @param id: ID of user to delete
     */
    public void deleteUser(Long id) {
        userDao.deleteById(id);
    }

    /**
     * BONUS: Count total users
     * 
     * @return: Total number of users
     */
    public long getUserCount() {
        return userDao.count();
    }

    /**
     * BONUS: Check if user exists
     * 
     * @param id: User ID to check
     * @return: true if exists, false otherwise
     */
    public boolean userExists(Long id) {
        return userDao.existsById(id);
    }
}
```

### Service Layer Best Practices:

```java
// ❌ DON'T: Put validation in controller
@PostMapping
public void createUser(User user) {
    userRepository.save(user);  // What if email is empty?
}

// ✅ DO: Put validation in service
@Service
public class UserService {
    public User createUser(User user) {
        if (user.getEmailId() == null) {
            throw new IllegalArgumentException("Email required");
        }
        return userDao.save(user);
    }
}
```

---

## Step 8: Create Controller Layer

Controller handles HTTP requests and responses.

**File**: `src/main/java/com/codetikki/crud/controller/UserController.java`

```java
package com.codetikki.crud.controller;

import com.codetikki.crud.entity.User;
import com.codetikki.crud.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

/**
 * UserController - API Endpoint Layer
 * 
 * Responsibilities:
 * 1. Handle HTTP requests (GET, POST, PUT, DELETE)
 * 2. Map URLs to methods
 * 3. Call service layer for business logic
 * 4. Return HTTP responses (JSON)
 * 
 * Annotations:
 * @RestController: Marks this as REST API controller (returns JSON, not HTML)
 * @RequestMapping: Base URL path for all methods
 * @GetMapping: Handle GET requests
 * @PostMapping: Handle POST requests
 * @PutMapping: Handle PUT requests
 * @DeleteMapping: Handle DELETE requests
 */
@RestController
@RequestMapping("/users")
public class UserController {

    /**
     * Dependency Injection of UserService
     * Spring automatically creates and injects UserService
     */
    @Autowired
    private UserService userService;

    /**
     * ========== CREATE OPERATION ==========
     * 
     * HTTP Method: POST
     * URL: http://localhost:8080/users
     * Body: JSON with user data
     * 
     * What happens:
     * 1. Client sends POST request with JSON body
     * 2. Spring converts JSON to User object (@RequestBody)
     * 3. Call userService.createUser()
     * 4. Return created user as JSON with HTTP 200 status
     * 
     * @RequestBody: Converts JSON from request body to User object
     * @return: ResponseEntity with user object
     */
    @PostMapping
    public ResponseEntity<User> createUser(@RequestBody User user) {
        // Call service to create user (includes validation)
        User createdUser = userService.createUser(user);

        // Return HTTP 200 with created user
        return ResponseEntity.ok(createdUser);

        // Other response options:
        // return ResponseEntity.status(HttpStatus.CREATED).body(createdUser);
        // return ResponseEntity.status(201).body(createdUser);
    }

    /**
     * ========== READ ALL OPERATION ==========
     * 
     * HTTP Method: GET
     * URL: http://localhost:8080/users
     * Response: Array of all users
     * 
     * What happens:
     * 1. Client sends GET request
     * 2. Call userService.getAllUsers()
     * 3. Return list of users as JSON array
     * 
     * @return: List of all users
     */
    @GetMapping
    public List<User> getAllUsers() {
        // Call service to get all users
        return userService.getAllUsers();

        // Response example:
        // [
        //   { "id": 1, "emailId": "user1@example.com", "name": "John", ... },
        //   { "id": 2, "emailId": "user2@example.com", "name": "Jane", ... }
        // ]
    }

    /**
     * ========== READ BY ID OPERATION ==========
     * 
     * HTTP Method: GET
     * URL: http://localhost:8080/users/{id}
     * Example: http://localhost:8080/users/1
     * Response: Single user object or 404 if not found
     * 
     * What happens:
     * 1. Client sends GET request with ID in URL
     * 2. @PathVariable extracts ID from URL
     * 3. Call userService.getUserById()
     * 4. If found: Return user with HTTP 200
     * 5. If not found: Return HTTP 404
     * 
     * @PathVariable: Extracts {id} from URL
     * @return: ResponseEntity with user or 404 error
     */
    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
        // Call service to get user by ID (returns Optional)
        Optional<User> user = userService.getUserById(id);

        // Return user if found, otherwise return 404
        return user.map(ResponseEntity::ok)
                   .orElseGet(() -> ResponseEntity.notFound().build());

        // Explanation of above:
        // - user.map(): If user exists, apply the function
        // - ResponseEntity::ok: Return 200 with user
        // - orElseGet(): If user doesn't exist, execute this
        // - ResponseEntity.notFound().build(): Return 404

        // Simple alternative:
        // if (user.isPresent()) {
        //     return ResponseEntity.ok(user.get());
        // } else {
        //     return ResponseEntity.notFound().build();
        // }
    }

    /**
     * ========== UPDATE OPERATION ==========
     * 
     * HTTP Method: PUT
     * URL: http://localhost:8080/users/{id}
     * Example: http://localhost:8080/users/1
     * Body: JSON with updated user data
     * 
     * What happens:
     * 1. Client sends PUT request with ID and updated data
     * 2. Call userService.updateUser()
     * 3. If found: Return updated user with HTTP 200
     * 4. If not found: Return HTTP 404
     * 
     * @PathVariable Long id: ID from URL
     * @RequestBody User userDetails: Updated data from JSON
     * @return: ResponseEntity with updated user or 404
     */
    @PutMapping("/{id}")
    public ResponseEntity<User> updateUser(
            @PathVariable Long id,
            @RequestBody User userDetails) {
        try {
            // Call service to update user
            User updatedUser = userService.updateUser(id, userDetails);

            // Return HTTP 200 with updated user
            return ResponseEntity.ok(updatedUser);
        } catch (RuntimeException e) {
            // If user not found, return 404
            return ResponseEntity.notFound().build();
        }

        // Exception handling explained:
        // userService.updateUser() throws RuntimeException if user not found
        // We catch it and return 404 response
    }

    /**
     * ========== DELETE OPERATION ==========
     * 
     * HTTP Method: DELETE
     * URL: http://localhost:8080/users/{id}
     * Example: http://localhost:8080/users/1
     * Response: HTTP 204 (No Content)
     * 
     * What happens:
     * 1. Client sends DELETE request with ID
     * 2. Call userService.deleteUser()
     * 3. Return HTTP 204 (No Content) - operation successful, no response body
     * 
     * @PathVariable Long id: ID from URL
     * @return: ResponseEntity with no content
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        // Call service to delete user
        userService.deleteUser(id);

        // Return HTTP 204 (No Content) - successful deletion
        return ResponseEntity.noContent().build();

        // ResponseEntity<Void>: No response body (use <Void> for no content)
        // .noContent(): HTTP 204 status
        // .build(): Build the response
    }
}
```

### HTTP Status Codes Explained:

| Code | Meaning | When Used |
|------|---------|-----------|
| 200 | OK | Successful GET, POST, PUT |
| 201 | Created | After successful POST |
| 204 | No Content | After successful DELETE |
| 400 | Bad Request | Invalid input data |
| 404 | Not Found | Resource doesn't exist |
| 500 | Server Error | Unexpected server error |

### URL Patterns Explained:

```
@RequestMapping("/users")    // Base path
@PostMapping                 // POST /users
@GetMapping                  // GET /users
@GetMapping("/{id}")         // GET /users/{id}
@PutMapping("/{id}")         // PUT /users/{id}
@DeleteMapping("/{id}")      // DELETE /users/{id}
```

---

## Step 9: Run the Application

### Method 1: Using Maven Command

```bash
# Navigate to project directory
cd path/to/crud

# Run the application
mvn spring-boot:run
```

### Method 2: Using IDE

**IntelliJ IDEA:**
1. Right-click `CrudApplication.java`
2. Click "Run 'CrudApplication.main()'"

**VS Code:**
1. Install "Extension Pack for Java"
2. Open `CrudApplication.java`
3. Click "Run" above the `main` method

### Method 3: Build JAR and Run

```bash
# Build the project
mvn clean package

# Run the JAR file
java -jar target/crud-0.0.1-SNAPSHOT.jar
```

### Successful Startup Output:

```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.2.1)

2026-01-22T15:15:21.594+05:30  INFO 7920 --- [ main] com.codetikki.crud.CrudApplication       : Started CrudApplication in 9.689 seconds
```

✅ **Application is running at `http://localhost:8080`**

---

## API Endpoints Overview

### Summary of All Endpoints:

| Method | URL | Description | Body | Response |
|--------|-----|-------------|------|----------|
| POST | /users | Create user | User JSON | User object |
| GET | /users | Get all users | None | User array |
| GET | /users/{id} | Get user by ID | None | User object or 404 |
| PUT | /users/{id} | Update user | User JSON | User object or 404 |
| DELETE | /users/{id} | Delete user | None | 204 No Content |

---

## Complete Request/Response Examples

### 1. CREATE USER

**Request:**
```
POST http://localhost:8080/users
Content-Type: application/json

{
  "name": "John Doe",
  "emailId": "john@example.com",
  "whatsappNumber": "9876543210",
  "gender": "Male"
}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "name": "John Doe",
  "emailId": "john@example.com",
  "whatsappNumber": "9876543210",
  "gender": "Male"
}
```

**Error Response (400 Bad Request):**
```json
// If email is empty
{
  "error": "Email ID cannot be null or empty"
}
```

---

### 2. GET ALL USERS

**Request:**
```
GET http://localhost:8080/users
Content-Type: application/json
```

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "name": "John Doe",
    "emailId": "john@example.com",
    "whatsappNumber": "9876543210",
    "gender": "Male"
  },
  {
    "id": 2,
    "name": "Jane Smith",
    "emailId": "jane@example.com",
    "whatsappNumber": "9876543211",
    "gender": "Female"
  }
]
```

---

### 3. GET USER BY ID

**Request:**
```
GET http://localhost:8080/users/1
Content-Type: application/json
```

**Response if found (200 OK):**
```json
{
  "id": 1,
  "name": "John Doe",
  "emailId": "john@example.com",
  "whatsappNumber": "9876543210",
  "gender": "Male"
}
```

**Response if not found (404 Not Found):**
```
(Empty body with 404 status)
```

---

### 4. UPDATE USER

**Request:**
```
PUT http://localhost:8080/users/1
Content-Type: application/json

{
  "name": "John Updated",
  "emailId": "john.updated@example.com",
  "whatsappNumber": "9876543212",
  "gender": "Male"
}
```

**Response (200 OK):**
```json
{
  "id": 1,
  "name": "John Updated",
  "emailId": "john.updated@example.com",
  "whatsappNumber": "9876543212",
  "gender": "Male"
}
```

---

### 5. DELETE USER

**Request:**
```
DELETE http://localhost:8080/users/1
Content-Type: application/json
```

**Response (204 No Content):**
```
(Empty body with 204 status - successful deletion)
```

---

## Common Concepts Explained

### 1. What is REST API?

REST (Representational State Transfer) is an architectural style for building APIs.

**Key Principles:**
- **Resources**: Everything is a resource (Users, Products, etc.)
- **HTTP Methods**: Operations on resources
  - GET: Read
  - POST: Create
  - PUT: Update
  - DELETE: Remove
- **Stateless**: Each request contains all info
- **JSON**: Standard data format

**Example:**
```
Resource: Users
HTTP GET /users         → Read all users
HTTP POST /users        → Create user
HTTP PUT /users/1       → Update user 1
HTTP DELETE /users/1    → Delete user 1
```

---

### 2. What is Dependency Injection?

Dependency Injection (DI) is when Spring provides object dependencies automatically.

**Without DI (Manual Creation):**
```java
@Service
public class UserService {
    // We manually create UserDao
    private UserDao userDao = new UserDao();  // ❌ Tight coupling
}
```

**With DI (Spring Provides):**
```java
@Service
public class UserService {
    // Spring automatically provides UserDao
    @Autowired
    private UserDao userDao;  // ✅ Loose coupling
}
```

**Benefits:**
- Loose coupling
- Easy testing (can mock dependencies)
- Automatic lifecycle management
- Spring handles object creation

---

### 3. What is ResponseEntity?

ResponseEntity is a wrapper that allows you to return HTTP response with:
- Status code
- Headers
- Body

**Examples:**
```java
// 200 OK with body
return ResponseEntity.ok(user);

// 201 Created
return ResponseEntity.status(201).body(user);

// 404 Not Found
return ResponseEntity.notFound().build();

// 204 No Content
return ResponseEntity.noContent().build();

// Custom headers
return ResponseEntity.ok()
    .header("X-Custom-Header", "value")
    .body(user);
```

---

### 4. What is Optional?

Optional is a container that may or may not contain a value (instead of null).

**Without Optional:**
```java
User user = userRepository.findById(1L);  // May return null ❌
if (user != null) {
    return user;
}
```

**With Optional:**
```java
Optional<User> user = userRepository.findById(1L);  // Never null ✅
return user.map(ResponseEntity::ok)
           .orElseGet(() -> ResponseEntity.notFound().build());

// Or simpler:
if (user.isPresent()) {
    return ResponseEntity.ok(user.get());
}
```

**Optional Methods:**
```java
Optional<User> user = userRepository.findById(1L);

user.isPresent()           // true if user exists
user.get()                 // get the user (throws if not present)
user.orElse(null)          // get user or return null
user.orElseThrow()         // get user or throw exception
user.map(function)         // transform user if present
user.ifPresent(consumer)   // do something if present
```

---

### 5. What are Annotations?

Annotations are metadata that provide info about code but don't execute code themselves.

**Common Spring Annotations:**

```java
// Component/Bean Annotations
@Component      // Generic Spring component
@Service        // Business logic class
@Repository     // Database access class
@Controller     // Web controller (returns HTML)
@RestController // REST API controller (returns JSON)

// Mapping Annotations
@RequestMapping("/path")  // Base URL path
@GetMapping("/path")      // Handle GET requests
@PostMapping("/path")     // Handle POST requests
@PutMapping("/path")      // Handle PUT requests
@DeleteMapping("/path")   // Handle DELETE requests

// Parameter Annotations
@RequestBody      // Convert JSON body to object
@PathVariable     // Extract value from URL path
@RequestParam     // Extract value from query parameter
@RequestHeader    // Extract value from HTTP header

// Data/JPA Annotations
@Entity           // Mark class as database entity
@Table(name="")   // Specify table name
@Id               // Mark field as primary key
@GeneratedValue   // Auto-generate ID
@Column           // Map field to column
```

---

### 6. Complete Request Flow

Let's trace a request through all layers:

**Example: Creating a User**

1. **Client** (Postman)
   ```
   POST /users
   { "name": "John", "emailId": "john@example.com", ... }
   ```

2. **Controller** (UserController.java)
   ```java
   @PostMapping
   public ResponseEntity<User> createUser(@RequestBody User user) {
       // @RequestBody converts JSON to User object
       // Calls service.createUser(user)
       User createdUser = userService.createUser(user);
       return ResponseEntity.ok(createdUser);
   }
   ```

3. **Service** (UserService.java)
   ```java
   public User createUser(User user) {
       // Business logic: Validate email
       if (user.getEmailId() == null || user.getEmailId().isEmpty()) {
           throw new IllegalArgumentException("Email required");
       }
       // Call DAO to save
       return userDao.save(user);
   }
   ```

4. **DAO** (UserDao.java)
   ```java
   public User save(User user) {
       // Call repository
       return userRepository.save(user);
   }
   ```

5. **Repository** (UserRepository.java)
   ```java
   public interface UserRepository extends JpaRepository<User, Long> {
       // Spring generates SQL: INSERT INTO user (...)
   }
   ```

6. **Database**
   ```sql
   -- SQL executed by Hibernate
   INSERT INTO user (name, email_id, whatsapp_number, gender)
   VALUES ('John', 'john@example.com', '9876543210', 'Male');
   ```

7. **Response** (Back to Client)
   ```json
   {
     "id": 1,
     "name": "John",
     "emailId": "john@example.com",
     "whatsappNumber": "9876543210",
     "gender": "Male"
   }
   ```

---

### 7. Testing the API with Postman

**Install Postman:**
1. Download from [postman.com](https://www.postman.com/downloads/)
2. Create free account

**Testing Steps:**

1. **Create User:**
   - Method: POST
   - URL: `http://localhost:8080/users`
   - Body (JSON):
     ```json
     {
       "name": "John",
       "emailId": "john@example.com",
       "whatsappNumber": "9876543210",
       "gender": "Male"
     }
     ```

2. **Get All Users:**
   - Method: GET
   - URL: `http://localhost:8080/users`

3. **Get User by ID:**
   - Method: GET
   - URL: `http://localhost:8080/users/1`

4. **Update User:**
   - Method: PUT
   - URL: `http://localhost:8080/users/1`
   - Body (JSON):
     ```json
     {
       "name": "John Updated",
       "emailId": "john.updated@example.com",
       "whatsappNumber": "9876543211",
       "gender": "Male"
     }
     ```

5. **Delete User:**
   - Method: DELETE
   - URL: `http://localhost:8080/users/1`

---

## Summary

### What You've Learned:

✅ **Spring Boot Basics** - What is Spring Boot and why use it  
✅ **Layered Architecture** - Controller → Service → DAO → Repository → Entity  
✅ **Entity Layer** - Database model using JPA annotations  
✅ **Repository Layer** - Automatic CRUD operations  
✅ **DAO Layer** - Business-level data access  
✅ **Service Layer** - Business logic and validation  
✅ **Controller Layer** - REST API endpoints  
✅ **Database Configuration** - MySQL connection setup  
✅ **HTTP Methods** - GET, POST, PUT, DELETE  
✅ **Request/Response** - JSON serialization  
✅ **Dependency Injection** - Spring component management  
✅ **Testing** - Using Postman to test APIs  

### Next Steps:

1. **Error Handling:** Create custom exception handlers
   ```java
   @ExceptionHandler(Exception.class)
   public ResponseEntity<String> handleException(Exception e) {
       return ResponseEntity.badRequest().body(e.getMessage());
   }
   ```

2. **Validation:** Add input validation using annotations
   ```java
   public class User {
       @NotNull(message = "Name is required")
       private String name;
   }
   ```

3. **Security:** Add authentication/authorization
   ```java
   @Configuration
   @EnableWebSecurity
   public class SecurityConfig { }
   ```

4. **Testing:** Write unit and integration tests
   ```java
   @SpringBootTest
   public class UserServiceTest { }
   ```

5. **Documentation:** Add Swagger/OpenAPI
   ```xml
   <dependency>
       <groupId>org.springdoc</groupId>
       <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
   </dependency>
   ```

---

**Congratulations! You now understand Spring Boot CRUD APIs completely!** 🎉

For more help, refer to:
- [Spring Boot Official Docs](https://spring.io/projects/spring-boot)
- [Spring Data JPA Docs](https://spring.io/projects/spring-data-jpa)
- [RESTful API Design](https://restfulapi.net/)
