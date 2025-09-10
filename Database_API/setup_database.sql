-- Database setup script for Blockchain Voting System
-- Run this script in your MySQL database to set up the required tables and sample data

-- Create database (run this if the database doesn't exist)
CREATE DATABASE IF NOT EXISTS voting_system;
USE voting_system;

-- Create voters table
DROP TABLE IF EXISTS voters;
CREATE TABLE voters (
    voter_id VARCHAR(50) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'user') NOT NULL DEFAULT 'user',
    name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data (admin and test users)
INSERT INTO voters (voter_id, password, role, name) VALUES 
('admin', 'admin123', 'admin', 'System Administrator'),
('voter1', 'password1', 'user', 'Test Voter 1'),
('voter2', 'password2', 'user', 'Test Voter 2'),
('voter3', 'password3', 'user', 'Test Voter 3'),
('user123', 'mypassword', 'user', 'Demo User');

-- Display created data
SELECT * FROM voters;

-- Show table structure
DESCRIBE voters;