const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
app.use(bodyParser.json());
app.use(cors());

// MySQL connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'student_db'
});

db.connect((err) => {
    if (err) throw err;
    console.log('MySQL Connected...');
});

// Create students table if not exists
const createTable = `
    CREATE TABLE IF NOT EXISTS students (
        id INT AUTO_INCREMENT PRIMARY KEY,
        firstName VARCHAR(255) NOT NULL,
        lastName VARCHAR(255) NOT NULL,
        course VARCHAR(255) NOT NULL,
        year VARCHAR(255) NOT NULL,
        enrolled BOOLEAN NOT NULL
    )
`;
db.query(createTable, (err, result) => {
    if (err) throw err;
    console.log('Students table created or already exists.');
});

// Start server
app.listen(3000, () => {
    console.log('Server started on http://localhost:3000');
});

app.post('/api/students', (req, res) => {
    const { firstName, lastName, course, year, enrolled } = req.body;
    const query = `INSERT INTO students (firstName, lastName, course, year, enrolled) VALUES (?, ?, ?, ?, ?)`;
    db.query(query, [firstName, lastName, course, year, enrolled], (err, result) => {
        if (err) throw err;
        res.status(201).json({ message: 'Student added', id: result.insertId });
    });
});

// Get all students
app.get('/api/students', (req, res) => {
    const query = `SELECT * FROM students`;
    db.query(query, (err, results) => {
        if (err) throw err;
        res.status(200).json(results);
    });
});

// Get student by ID
app.get('/api/students/:id', (req, res) => {
    const { id } = req.params;
    const query = `SELECT * FROM students WHERE id = ?`;
    db.query(query, [id], (err, result) => {
        if (err) throw err;
        res.status(200).json(result[0]);
    });
});

app.put('/api/students/:id', (req, res) => {
    const { id } = req.params;
    const { firstName, lastName, course, year, enrolled } = req.body;
    const query = `UPDATE students SET firstName = ?, lastName = ?, course = ?, year = ?, enrolled = ? WHERE id = ?`;
    db.query(query, [firstName, lastName, course, year, enrolled, id], (err, result) => {
        if (err) throw err;
        res.status(200).json({ message: 'Student updated' });
    });
});

app.delete('/api/students/:id', (req, res) => {
    const { id } = req.params;
    const query = `DELETE FROM students WHERE id = ?`;
    db.query(query, [id], (err, result) => {
        if (err) throw err;
        res.status(200).json({ message: 'Student deleted' });
    });
});
