/**************************************************************************
    
    Database : MYSQL
    Purpose : Create Uber Ride share tables designed for OLTP
    This script will create below tables:
        1. Driver
        2. Rider
        3. Vehicle
        4. Trip
        5. Driver_Vehicle_Assignment
        6. Payment
        7. Trip_Feedback
***************************************************************************/

-- Driver Table creation
DROP TABLE IF EXISTS Driver;
CREATE TABLE Driver (
    Driver_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    License_Number VARCHAR(50) UNIQUE NOT NULL,
    License_Expiry DATE NOT NULL,
    Rating DECIMAL(3,2),
    Phone VARCHAR(20) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
	Creation_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    End_Date DATETIME,
    Active BOOLEAN DEFAULT TRUE
);


-- Rider Table creation
DROP TABLE IF EXISTS Rider;
CREATE TABLE Rider (
    Rider_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20) UNIQUE NOT NULL,
    Creation_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Last_Updated_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Vehicle TABLE creation
DROP TABLE IF EXISTS Vehicle;
CREATE TABLE Vehicle (
    Vehicle_ID INT PRIMARY KEY AUTO_INCREMENT,
    Make VARCHAR(50),
    Model VARCHAR(50),
    Color VARCHAR(30),
    Capacity INT,
    Vehicle_Type VARCHAR(50),
    Number_Plate VARCHAR(20) UNIQUE,
    Active BOOLEAN DEFAULT TRUE,
	Creation_Date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Trip Table creation
DROP TABLE IF EXISTS Trip;
CREATE TABLE Trip (
    Trip_ID INT PRIMARY KEY AUTO_INCREMENT,
    Rider_ID INT NOT NULL,
    Driver_ID INT NOT NULL,
    Vehicle_ID INT NOT NULL,
    Start_Location VARCHAR(255),
    End_Location VARCHAR(255),
    Pickup_Longitude DECIMAL(10, 6),
    Pickup_Latitude DECIMAL(10, 6),
    Dropoff_Longitude DECIMAL(10, 6),
    Dropoff_Latitude DECIMAL(10, 6),
    Requested_time DATETIME NOT NULL,
    Start_Time DATETIME,
    End_Time DATETIME,
    Fare_Amount DECIMAL(10, 2),
    Trip_Duration INT, -- In minutes
    Trip_Status VARCHAR(50) NOT NULL,

    FOREIGN KEY (Rider_ID) REFERENCES Rider(Rider_ID),
    FOREIGN KEY (Driver_ID) REFERENCES Driver(Driver_ID),
    FOREIGN KEY (Vehicle_ID) REFERENCES Vehicle(Vehicle_ID)
);


-- Driver-Vehicle Assignment Table creation
CREATE TABLE Driver_Vehicle_Assignment (
    Assignment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Driver_ID INT NOT NULL,
    Vehicle_ID INT NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE,

    FOREIGN KEY (Driver_ID) REFERENCES Driver(Driver_ID),
    FOREIGN KEY (Vehicle_ID) REFERENCES Vehicle(Vehicle_ID),
    CHECK (Start_Date <= IFNULL(End_Date, Start_Date))
);


-- Payment Table creation
DROP TABLE IF EXISTS Payment;
CREATE TABLE Payment (
    Payment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Trip_ID INT UNIQUE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Payment_Method VARCHAR(50),
    Payment_Status VARCHAR(50),
    Creation_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Payment_Date DATETIME,

    FOREIGN KEY (Trip_ID) REFERENCES Trip(Trip_ID)
);


-- Trip_Feedback Table creation
DROP TABLE IF EXISTS Trip_Feedback;
CREATE TABLE Trip_Feedback (
    Trip_ID INT,
    Rated_BY_User_ID INT,   -- FK to Rider or Driver
    Rated_TO_User_ID INT,   -- FK to Rider or Driver
    Rated_BY_Type ENUM('RIDER','DRIVER'),
    Rated_TO_Type ENUM('RIDER','DRIVER'),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Review TEXT,
    Creation_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    Last_update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    Created_By VARCHAR(50),
	Updated_By VARCHAR(50),

    PRIMARY KEY (Trip_ID, Rated_BY_User_ID, Rated_TO_User_ID),
    FOREIGN KEY (Trip_ID) REFERENCES Trip(Trip_ID)
);
