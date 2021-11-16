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
	ID integer PRIMARY KEY, 
	name varchar(50),
    emailAddress varchar(50) NOT NULL,
    password varchar(50)
	);

CREATE TABLE TheEvent (
    ID integer PRIMARY KEY,
    title varchar(50),
    description varchar(300),
    location varchar(50),
    price integer
    );

CREATE TABLE Trip (
    ID integer PRIMARY KEY,
    eventID integer REFERENCES TheEvent(ID),
    userID integer REFERENCES TheUser(ID),
    seats integer,
    date timestamp
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

-- Add sample records.
INSERT INTO TheUser VALUES (1, 'Kun Kang', 'kk58@students.calvin.edu', 'chestnutkk99');
INSERT INTO TheUser VALUES (2, 'John White', 'jmw75@students.calvin.edu', 'black12345');
INSERT INTO TheUser VALUES (3, 'YK Choi', 'yc55@students.calvin.edu', '1357why');

INSERT INTO TheEvent VALUES (1, 'Skiing', 'Are you ready to go skiing?','Grand Haven', 20);
INSERT INTO TheEvent VALUES (2, 'Parade of Lights', 'Santa arrives escorted by bands, floats, trucks and family and friends, all decked out in thousands of sparkling holiday lights!', 'Holland', 0);
INSERT INTO TheEvent VALUES (3, 'Comic-con', 'Come dress up like the geek you really are!', 'DeVos Place', 30);

INSERT INTO Trip VALUES (1, 1, 2, 6, '2021-12-20 12:00:00');
INSERT INTO Trip VALUES (2, 2, 2, 4, '2021-11-30 23:30:00');
INSERT INTO Trip VALUES (3, 3, 3, 4, '2021-11-12 18:00:00');
INSERT INTO Trip VALUES (4, 3, 3, 3, '2021-11-13 10:30:00');

INSERT INTO UserTrip VALUES (1, 2, 'driver');
INSERT INTO UserTrip VALUES (2, 1, 'rider');
INSERT INTO UserTrip VALUES (2, 2, 'driver');
INSERT INTO UserTrip VALUES (4, 1, 'rider');
INSERT INTO UserTrip VALUES (4, 2, 'rider');
INSERT INTO UserTrip VALUES (4, 3, 'driver');

-- Lists the Event schema created
SELECT COUNT(*) FROM TheEvent; 			-- Returns the number of records
SELECT * FROM TheEvent;					-- Returns all the records
