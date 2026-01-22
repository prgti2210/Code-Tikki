-- ============================================================
-- CRUD Application Database Schema
-- Database: crud
-- Created by Spring Boot (Hibernate)
-- ============================================================

-- ============================================================
-- 1. CREATE DATABASE
-- ============================================================
-- Execute this first if database doesn't exist
CREATE DATABASE IF NOT EXISTS crud;

-- Use the database
USE crud;

-- ============================================================
-- 2. USER TABLE SCHEMA
-- ============================================================

CREATE TABLE IF NOT EXISTS user (
    -- PRIMARY KEY: Unique identifier for each user
    id BIGINT NOT NULL AUTO_INCREMENT,
    
    -- EMAIL_ID: User's email address
    -- - NOT NULL: Email is required
    -- - UNIQUE: No two users can have same email
    -- - VARCHAR(100): Up to 100 characters
    email_id VARCHAR(100) NOT NULL UNIQUE,
    
    -- NAME: User's full name
    -- - NOT NULL: Name is required
    -- - VARCHAR(100): Up to 100 characters
    name VARCHAR(100) NOT NULL,
    
    -- WHATSAPP_NUMBER: User's WhatsApp phone number
    -- - VARCHAR(15): Phone numbers can be up to 15 digits
    -- - NULL allowed: This field is optional
    whatsapp_number VARCHAR(15),
    
    -- GENDER: User's gender
    -- - VARCHAR(10): Short string (Male, Female, Other)
    -- - NULL allowed: This field is optional
    gender VARCHAR(10),
    
    -- PRIMARY KEY: Define primary key constraint
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 3. TABLE STRUCTURE EXPLANATION
-- ============================================================
/*

Column Name      | Data Type     | Constraints           | Purpose
─────────────────────────────────────────────────────────────────
id               | BIGINT        | PRIMARY KEY, AUTO_INC | Unique user identifier
email_id         | VARCHAR(100)  | NOT NULL, UNIQUE      | User email (must be unique)
name             | VARCHAR(100)  | NOT NULL              | User full name
whatsapp_number  | VARCHAR(15)   | Optional              | WhatsApp contact number
gender           | VARCHAR(10)   | Optional              | User gender

Keys:
- PRIMARY KEY (id): Automatically increments for each new user
- UNIQUE (email_id): Prevents duplicate email addresses

Constraints:
- NOT NULL: Field is required (cannot be empty)
- NULL: Field is optional (can be empty)

Data Types:
- BIGINT: Large integer (good for IDs, range: -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807)
- VARCHAR(n): Variable-length string up to n characters
  - VARCHAR(100): Can store strings of any length up to 100 chars
  - VARCHAR(15): Typical for phone numbers

Engine:
- InnoDB: Supports transactions, foreign keys, crash recovery
- UTF8MB4: Supports all Unicode characters (including emojis)

*/

-- ============================================================
-- 4. INDEXES (For faster queries)
-- ============================================================

-- Index on email_id (already unique, so it acts as index)
-- This speeds up searches by email
ALTER TABLE user ADD INDEX idx_email_id (email_id);

-- Index on name (for name searches)
-- This speeds up searches by name
ALTER TABLE user ADD INDEX idx_name (name);

-- ============================================================
-- 5. SAMPLE DATA (For testing)
-- ============================================================

-- Insert sample users
INSERT INTO user (email_id, name, whatsapp_number, gender) VALUES
('john@example.com', 'John Doe', '9876543210', 'Male'),
('jane@example.com', 'Jane Smith', '9876543211', 'Female'),
('mike@example.com', 'Mike Johnson', '9876543212', 'Male'),
('sarah@example.com', 'Sarah Williams', '9876543213', 'Female'),
('alex@example.com', 'Alex Brown', '9876543214', 'Other');

-- ============================================================
-- 6. USEFUL QUERIES FOR TESTING
-- ============================================================

-- View all users
SELECT * FROM user;

-- Count total users
SELECT COUNT(*) as total_users FROM user;

-- Find user by email
SELECT * FROM user WHERE email_id = 'john@example.com';

-- Find all users with specific gender
SELECT * FROM user WHERE gender = 'Male';

-- Find users by name pattern (contains "John")
SELECT * FROM user WHERE name LIKE '%John%';

-- View table structure
DESCRIBE user;

-- View table creation statement
SHOW CREATE TABLE user;

-- ============================================================
-- 7. DATA MODIFICATION OPERATIONS
-- ============================================================

-- CREATE: Insert new user
INSERT INTO user (email_id, name, whatsapp_number, gender)
VALUES ('newuser@example.com', 'New User', '9876543215', 'Male');

-- READ: Get all users
SELECT * FROM user;

-- READ: Get user by ID
SELECT * FROM user WHERE id = 1;

-- UPDATE: Modify user information
UPDATE user 
SET name = 'John Updated', whatsapp_number = '9999999999' 
WHERE id = 1;

-- DELETE: Remove user
DELETE FROM user WHERE id = 1;

-- ============================================================
-- 8. CONSTRAINTS & VALIDATIONS
-- ============================================================

-- These constraints are enforced at database level:

-- 1. PRIMARY KEY (id)
--    - Every user must have unique ID
--    - Cannot be NULL
--    - Auto-increments

-- 2. NOT NULL (email_id, name)
--    - Must provide email and name
--    - Cannot insert user without these fields

-- 3. UNIQUE (email_id)
--    - No duplicate emails allowed
--    - Database will reject: INSERT INTO user (email_id, ...) if email exists

-- 4. VARCHAR length
--    - Data longer than specified length will be truncated or rejected
--    - VARCHAR(100) for name means max 100 characters

-- ============================================================
-- 9. RELATIONSHIP DIAGRAM
-- ============================================================

/*

Currently: Single User Table (No relationships)

If you needed to add more tables later:

Example: Add Address Table (One user can have multiple addresses)

CREATE TABLE address (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    street VARCHAR(255),
    city VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
);

This creates a One-to-Many relationship:
- One User → Many Addresses
- user_id in address table references id in user table

*/

-- ============================================================
-- 10. BACKUP & RESTORE OPERATIONS
-- ============================================================

-- Backup database to file (run in terminal, not in MySQL):
-- mysqldump -u root -p crud > crud_backup.sql

-- Restore from backup (run in terminal):
-- mysql -u root -p crud < crud_backup.sql

-- Export table to CSV:
-- SELECT * FROM user INTO OUTFILE '/tmp/user_export.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"';

-- ============================================================
-- 11. IMPORTANT NOTES
-- ============================================================

/*

1. AUTO_INCREMENT:
   - Starts at 1 for first record
   - Increments by 1 for each new record
   - If you delete a record, the ID is not reused
   
2. UNIQUE Constraint:
   - Prevents duplicate values
   - Can be applied to email, phone, username, etc.
   - NULL values don't violate UNIQUE (multiple NULL is allowed)

3. NOT NULL Constraint:
   - Field must always have a value
   - Cannot insert record without this field
   - Cannot update to NULL

4. VARCHAR vs CHAR:
   - VARCHAR: Variable length (1-n characters, storage varies)
   - CHAR: Fixed length (always n characters, padded with spaces)
   - Use VARCHAR when length varies (like names, emails)

5. Collation (utf8mb4_unicode_ci):
   - utf8mb4: Supports all Unicode characters
   - unicode_ci: Case-insensitive comparison
   - Good for international names and emojis

6. InnoDB Engine:
   - Supports transactions (BEGIN, COMMIT, ROLLBACK)
   - Supports foreign keys
   - Has crash recovery
   - Default MySQL engine

*/

-- ============================================================
-- 12. CLEANUP (Delete all data and tables)
-- ============================================================

-- Delete all users (but keep table)
-- DELETE FROM user;

-- Drop table (delete table and data)
-- DROP TABLE user;

-- Drop database (delete everything)
-- DROP DATABASE crud;

-- ============================================================
-- END OF SCHEMA
-- ============================================================
