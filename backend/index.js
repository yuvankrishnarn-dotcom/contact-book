import express from "express";
import pkg from "pg";

const { Pool } = pkg;
const app = express();
app.use(express.json());

const pool = new Pool({
  host: process.env.DB_HOST,
  user: "postgres",
  password: "postgres",
  database: "contacts"
});

app.get("/contacts", async (_, res) => {
  const result = await pool.query("SELECT * FROM contacts");
  res.json(result.rows);
});

app.post("/contacts", async (req, res) => {
  const { name, phone } = req.body;
  await pool.query(
    "INSERT INTO contacts(name, phone) VALUES ($1, $2)",
    [name, phone]
  );
  res.sendStatus(201);
});

app.listen(3000);

