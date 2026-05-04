-- node57 database initialization
CREATE DATABASE IF NOT EXISTS node57_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE node57_db;

-- Example table to verify DB is functional
CREATE TABLE IF NOT EXISTS app_metadata (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `key`       VARCHAR(255) NOT NULL UNIQUE,
  `value`     TEXT,
  created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO app_metadata (`key`, `value`)
VALUES ('initialized_at', NOW())
ON DUPLICATE KEY UPDATE `value` = NOW();