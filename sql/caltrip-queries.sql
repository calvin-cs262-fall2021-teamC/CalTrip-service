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
SELECT title
    FROM TheEvent
    WHERE price = 0
    ;

-- Get the name and the email address of users
SELECT TheUser.name, emailAddress
    FROM TheUser
    ;

-- Get a list of all the drivers
SELECT name
    FROM TheUser, JoinedUser
    WHERE TheUser.ID = JoinedUser.userID
    AND status = 'driver'

