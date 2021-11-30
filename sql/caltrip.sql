--
-- This SQL script builds a CalTrip database, deleting any pre-existing version.
--
-- @author yy36
-- @date October 27, 2021
--

-- Drop previous versions of the tables if they they exist, in reverse order of foreign keys.
DROP TABLE IF EXISTS UserTrip;
DROP TABLE IF EXISTS Trip;
DROP TABLE IF EXISTS TheUser;
DROP TABLE IF EXISTS TheEvent;

-- Create the schema.
CREATE TABLE TheUser (
	ID SERIAL PRIMARY KEY, 
	firstName varchar(50) NOT NULL,
    lastName varchar(50) NOT NULL,
    emailAddress varchar(50) NOT NULL,
    password varchar(50) NOT NULL
	);

CREATE TABLE TheEvent (
    ID SERIAL PRIMARY KEY,
    title varchar(50),
    description varchar(300),
    startDate date,
    endDate date,
    location varchar(50),
    price varchar(50),
    category integer
    );

CREATE TABLE Trip (
    ID SERIAL PRIMARY KEY,
    eventID integer REFERENCES TheEvent(ID),
    userID integer REFERENCES TheUser(ID),
    seats varchar(50)
    );

CREATE TABLE UserTrip (
    tripID integer REFERENCES Trip(ID),
    userID integer REFERENCES TheUser(ID),
    userStatus varchar(50)
    );    

-- Allow users to select data from the tables.
GRANT SELECT ON TheUser TO PUBLIC;
GRANT SELECT ON TheEvent TO PUBLIC;
GRANT SELECT ON Trip TO PUBLIC;
GRANT SELECT ON UserTrip TO PUBLIC;

-- Lists the Event schema created
SELECT COUNT(*) FROM TheEvent; 			-- Returns the number of records
SELECT * FROM TheEvent;					-- Returns all the records
