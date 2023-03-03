const express = require("express");
const bodyParser = require("body-parser");
const app = express();
const mysql = require("mysql");


app.use(bodyParser.json());


const conn = mysql.createConnection({
	host: "restapidb.c4yyafmdw7yt.ap-south-1.rds.amazonaws.com",
	user: "root",
	password: "rajendra",
	database: "userdb",
});


app.post("/api/create", (req, res) => {
	let data = { name: req.body.name, age: req.body.age };
	let sql = "INSERT INTO user SET ?";
	let query = conn.query(sql, data, (err, result) => {
		if (err) throw err;
		res.send(JSON.stringify({ status: 200, error: null, response: "New Record is Added successfully" }));
	});
});

app.get('/',(req,res) => {
    res.send ("Hello world");
});


app.get("/api/view/:id", (req, res) => {
	let sql = "SELECT * FROM user WHERE id=" + req.params.id;
	let query = conn.query(sql, (err, result) => {
		if (err) throw err;
		res.send(JSON.stringify({ response: result }));
	});
});










app.listen (8080,() => {
    console.log ('index listening on port 8080')});