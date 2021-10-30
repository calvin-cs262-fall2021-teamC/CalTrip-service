--
-- This SQL script implements sample queries on the CalTrip database.
--
-- @author yy36
-- @date October 27, 2021
--

-- Get the number of Event records
SELECT *
  FROM TheEvent
  ;

-- Get the name of events that are free
SELECT name
    FROM TheEvent
    WHERE price = 0
    ;

-- Get the name and the email address of users
SELECT TheUser.name, emailAddress
    FROM TheUser
    ;

-- Get a list of all the drivers
SELECT name
    FROM TheUser, UserTrip
    WHERE TheUser.ID = UserTrip.userID
    AND userStatus = 'driver'
    ;

-- Get users who are attending an event on 2021-11-13 10:30:00
SELECT name
    FROM TheUser, UserTrip, Trip
    WHERE TheUser.ID = UserTrip.userID
        AND UserTrip.tripID = Trip.ID
        AND date = '2021-11-13 10:30:00'
