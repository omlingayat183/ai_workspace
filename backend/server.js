// const express = require('express');
// const cors = require('cors');
// const morgan = require('morgan');
// const dotenv = require('dotenv');
// const connectDB = require('./config/db');

// dotenv.config();

// const app = express();
// app.use(express.json());
// app.use(cors());
// app.use(morgan('dev'));

// connectDB();

// app.get('/', (req, res) => {
//   res.json({ message: "API is running..." });
// });

// const PORT = process.env.PORT || 5000;
// const errorHandler = require("./middleware/error");

// app.use(errorHandler);
// app.get("/test", (req, res) => {
//   res.json({
//     status: "working",
//     time: new Date().toISOString(),
//     server: "Express backend OK"
//   });
// });

// app.listen(PORT, () => console.log(`Server running on port ${PORT}`));


const express = require("express");
const cors = require("cors");
const morgan = require("morgan");
const dotenv = require("dotenv");
const connectDB = require("./config/db");

dotenv.config();

const app = express();

// Middlewares
app.use(express.json());
app.use(
  cors({
    origin: ["http://localhost:3000", "http://localhost:5000"],
    methods: ["GET", "POST", "PUT", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);
app.use(morgan("dev"));

// Connect DB
connectDB();

// Test route
app.get("/", (req, res) => {
  res.json({ message: "API is running..." });
});

// Health route
app.get("/health", (req, res) => {
  res.json({
    uptime: process.uptime(),
    status: "OK",
    timestamp: new Date().toISOString(),
  });
});

// Test route
app.get("/test", (req, res) => {
  res.json({
    status: "working",
    time: new Date().toISOString(),
    server: "Express backend OK",
  });
});

// Error Handler
app.use(require("./middleware/error"));

// Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
