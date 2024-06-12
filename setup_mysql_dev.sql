
-- create a database
CREATE DATABASE IF NOT EXISTS hbnb_dev_db;

-- Drop user if exist
DROP USER IF EXISTS 'hbnb_dev'@'localhost';

-- Create user
CREATE USER 'hbnb_dev'@'localhost' IDENTIFIED BY 'hbnb_dev_pwd';

-- Grant all privillages to the user
GRANT ALL PRIVILEGES ON `hbnb_dev_db` .* TO 'hbnb_dev'@'localhost';

-- Select privillages on the database
GRANT SELECT ON `performance_schema`.* TO 'hbnb_dev'@'localhost';

FLUSH PRIVILEGES;
