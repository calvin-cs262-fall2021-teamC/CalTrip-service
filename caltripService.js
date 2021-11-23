/**
 * This module implements a REST-inspired webservice for the Monopoly DB.
 * The database is hosted on ElephantSQL.
 *
 * Currently, the service supports the player table only.
 *
 * To guard against SQL injection attacks, this code uses pg-promise's built-in
 * variable escaping. This prevents a client from issuing this URL:
 *     https://cs262-monopoly-service.herokuapp.com/players/1%3BDELETE%20FROM%20PlayerGame%3BDELETE%20FROM%20Player
 * which would delete records in the PlayerGame and then the Player tables.
 * In particular, we don't use JS template strings because it doesn't filter
 * client-supplied values properly.
 *
 * TODO: Consider using Prepared Statements.
 *      https://vitaly-t.github.io/pg-promise/PreparedStatement.html
 *
 * @author: kvlinden
 * @date: Summer, 2020
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
router.get("/events/:id", readEvent);

// router.put("/events/:id", updateEvent);
router.post("/events", createEvent);

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

function readUsers(req, res, next) {
    db.many("SELECT * FROM TheUser")
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            next(err);
        })
}

function readEvents(req, res, next) {
    db.many("SELECT * FROM TheEvent")
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            next(err);
        });
}

function readEvent(req, res, next) {
    db.oneOrNone("SELECT * FROM TheEvent WHERE id=${id}", req.params)
        .then(data => {
            returnDataOr404(res, data);
        })
        .catch(err => {
            next(err);
        });
}

// function updateEvent(req, res, next) {
//     db.oneOrNone('UPDATE Event SET name=${body.name}, description=${body.description}, location=${body.location}, price=${body.price} WHERE id=${params.id} RETURNING id', req)
//         .then(data => {
//             returnDataOr404(res, data);
//         })
//         .catch(err => {
//             next(err);
//         });
// }

function createEvent(req, res, next) {
    db.one('INSERT INTO TheEvent(title, description, location, price, category) VALUES (${title}, ${description}, ${location}, ${price}, ${category} ) RETURNING id, title, description, location, price, category', req.body)
        .then(data => {
            res.send(data);
        })
        .catch(err => {
            next(err);
        });
}