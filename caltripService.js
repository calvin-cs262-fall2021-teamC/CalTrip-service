/**
 * This module implements a REST-inspired webservice for the CalTrip DB.
 * The database is hosted on ElephantSQL.
 *
 * Currently, the service supports the user, event, and joinedUser table .
 *
 * TODO: Consider using Prepared Statements.
 *      https://vitaly-t.github.io/pg-promise/PreparedStatement.html
 *
 * @author: CalTrip
 * @date: December 12, 2021
 */

// Set up the database connection.
const pgp = require('pg-promise')();
const db = pgp({
    host: process.env.DB_SERVER,
    port: process.env.DB_PORT,
    database: process.env.DB_USER,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD
});

// Configure the server and its routes.

const express = require('express');
const app = express();
const port = process.env.PORT || 3000;
const router = express.Router();
router.use(express.json());

router.get("/", readHelloMessage);
router.get("/users", readUsers);
router.get("/events", readEvents);
router.get("/events/:id/users", readJoinedUsers);
router.get("/events/:id", readEvent);

router.put("/events/:id", updateEvent);
router.post("/events", createEvent);
router.post("/users", createUser);
router.post("/user", findUser);
router.post("/events/:id/users", createJoinedUsers);


app.use(router);
app.use(errorHandler);
app.listen(port, () => console.log(`Listening on port ${port}`));

// Implement the CRUD operations.

function errorHandler(err, req, res) {
    if (app.get('env') === "development") {
        console.log(err);
    }
    res.sendStatus(err.status || 500);
}

function returnDataOr404(res, data) {
    if (data == null) {
        res.sendStatus(404);
    } else {
        res.send(data);
    }
}

function readHelloMessage(req, res) {
    res.send('Hello, CS 262 CalTrip service!');
}

// Retrieves the information of users
function readUsers(req, res, next) {
    db.many("SELECT * FROM TheUser")
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            next(err);
        })
}

// Creates an account
function createUser(req, res, next) {
    db.one('INSERT INTO TheUser(firstName, lastName, emailAddress, password) VALUES (${firstName}, ${lastName}, ${emailAddress}, ${password}) RETURNING id, firstName, lastName, emailAddress, password', req.body)
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            next(err);
        });
}

// Retrieves the information of events and list in ascending order by date 
function readEvents(req, res, next) {
    db.many("SELECT id, title, description, TO_CHAR(startdate::DATE, 'yyyy/mm/dd'), location, price, category FROM TheEvent ORDER BY startDate ASC")
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            next(err);
        });
}

// Retrieves the information of an event
function readEvent(req, res, next) {
    db.oneOrNone("SELECT id, title, description, TO_CHAR(startdate::DATE, 'yyyy/mm/dd'), location, price, category FROM TheEvent WHERE id=${id}", req.params)
        .then(data => {
            returnDataOr404(res, data);
        })
        .catch(err => {
            next(err);
        });
}

// Retrieves a list of users who have joined the event
function readJoinedUsers(req, res, next) {
    db.many("SELECT firstName, lastName, status, seats FROM JoinedUser, TheUser WHERE TheUser.ID=userID AND eventID=${id}", req.params)
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            next(err)
        });
}

function updateEvent(req, res, next) {
    db.oneOrNone('UPDATE TheEvent SET title=${body.title}, description=${body.description}, startdate=${body.startdate}, location=${body.location}, price=${body.price}, category=${body.category} WHERE id=${params.id} RETURNING id, title, description, startdate, location, price, category', req)
        .then(data => {
            returnDataOr404(res, data);
        })
        .catch(err => {
            next(err);
        });
}

// Saves information of joined users 
function createJoinedUsers(req, res, next) {
    db.one('INSERT INTO JoinedUser(eventID, userID, status, seats) VALUES (${eventID}, ${userID}, ${status}, ${seats}) RETURNING id, userID, status, seats', req.body)
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            next(err);
        });
}

// Creates a new event
function createEvent(req, res, next) {
    db.one('INSERT INTO TheEvent(title, description, startdate, location, price, category) VALUES (${title}, ${description}, ${startdate}, ${location}, ${price}, ${category} ) RETURNING id, title, description, startdate, location, price, category', req.body)
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            next(err);
        });
}

function findUser(req, res, next) {
  db.one('SELECT * FROM TheUser WHERE emailAddress=${emailAddress} AND password=${password}', req.body)
    .then(data => {
      returnDataOr404(res, data);
    })
    .catch(err => {
        next(err);
    });
}
