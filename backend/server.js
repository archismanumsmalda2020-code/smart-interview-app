const path = require("path");
const express = require("express");
const cors = require("cors");
const connectDB = require("./config/db");

// 1. Load environment variables IMMEDIATELY
require("dotenv").config({
  path: path.resolve(__dirname, ".env")
});

// Debugging: Log all keys to see what's actually loaded
console.log("ALL ENV KEYS:", Object.keys(process.env));
console.log("GROQ KEY EXISTS:", !!process.env.GROQ_API_KEY);

// 2. Import Routes
const authRoutes = require("./routes/authRoutes");
const quizRoutes = require("./routes/quizRoutes");
const analysisRoutes = require("./routes/analysisRoutes");

const app = express();

// ================= MIDDLEWARE =================
app.use(cors({
  origin: true, 
  credentials: true
}));
app.use(express.json());

// ================= ROUTES =================
app.use("/api/auth", authRoutes);
app.use("/api/quiz", quizRoutes);
app.use("/api/analysis", analysisRoutes);

app.get("/", (req, res) => {
  res.send("🚀 AI Quiz Backend Running");
});

// ================= START SERVER =================
const PORT = process.env.PORT || 5000;

const startServer = async () => {
  try {
    await connectDB();
    app.listen(PORT, "0.0.0.0", () => {
      console.log(`Server running on http://localhost:${PORT}`);
    });
  } catch (error) {
    console.error("❌ Failed to start server:", error.message);
    process.exit(1);
  }
};

startServer();