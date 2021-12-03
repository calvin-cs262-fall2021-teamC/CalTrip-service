--
-- This SQL script builds a CalTrip database, deleting any pre-existing version.
--
-- @author yy36, kk58
-- @date December 01, 2021
--

-- Drop previous versions of the tables if they they exist, in reverse order of foreign keys.
DROP TABLE IF EXISTS JoinedUser;
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
    title varchar(50) NOT NULL,
    description varchar(300) NOT NULL,
    startDate integer NOT NULL,
    endDate integer NOT NULL,
    location varchar(50) NOT NULL,
    price varchar(50) NOT NULL,
    category integer
    );

CREATE TABLE JoinedUser (
    ID SERIAL PRIMARY KEY,
    userID integer REFERENCES TheUser(ID),
		eventID integer REFERENCES TheEvent(ID),
    status varchar(50),                             -- rider or driver
    seats integer
);

-- Allow users to select data from the tables.
GRANT SELECT ON TheUser TO PUBLIC;
GRANT SELECT ON TheEvent TO PUBLIC;
GRANT SELECT ON JoinedUser TO PUBLIC;

-- Lists the Event schema created
SELECT COUNT(*) FROM TheEvent; 			-- Returns the number of records
SELECT * FROM TheEvent;					-- Returns all the records
