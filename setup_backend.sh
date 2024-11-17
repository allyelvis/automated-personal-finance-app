#!/bin/bash

# Script to automate backend setup for Automated Personal Finance App

# Project directories
BACKEND_DIR="backend"
SRC_DIR="$BACKEND_DIR/src"
CONFIG_DIR="$SRC_DIR/config"
ROUTES_DIR="$SRC_DIR/routes"
CONTROLLERS_DIR="$SRC_DIR/controllers"
MODELS_DIR="$SRC_DIR/models"
MIDDLEWARE_DIR="$SRC_DIR/middleware"
UTILS_DIR="$SRC_DIR/utils"

# Start setup
echo "Starting backend setup..."

# Create directory structure
echo "Creating directory structure..."
mkdir -p $CONFIG_DIR $ROUTES_DIR $CONTROLLERS_DIR $MODELS_DIR $MIDDLEWARE_DIR $UTILS_DIR

# Create essential files
echo "Creating essential files..."

# package.json
cat <<EOL > $BACKEND_DIR/package.json
{
  "name": "automated-personal-finance-backend",
  "version": "1.0.0",
  "description": "Backend for Automated Personal Finance App",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "mongoose": "^7.0.0",
    "dotenv": "^16.0.0",
    "bcrypt": "^5.1.0",
    "jsonwebtoken": "^9.0.0",
    "cors": "^2.8.5"
  },
  "devDependencies": {
    "nodemon": "^2.0.22"
  },
  "author": "Ally Elvis Nzeyimana",
  "license": "MIT"
}
EOL

# .env
cat <<EOL > $BACKEND_DIR/.env
MONGO_URI=<your_mongodb_connection_string>
JWT_SECRET=<your_jwt_secret>
PORT=5000
EOL

# index.js
cat <<EOL > $SRC_DIR/index.js
require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/users', require('./routes/userRoutes'));

// MongoDB Connection
mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.error('MongoDB connection error:', err));

// Start server
app.listen(PORT, () => console.log(\`Server running on port \${PORT}\`));
EOL

# config/db.js
cat <<EOL > $CONFIG_DIR/db.js
const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true });
    console.log('MongoDB connected');
  } catch (error) {
    console.error('MongoDB connection failed:', error);
    process.exit(1);
  }
};

module.exports = connectDB;
EOL

# routes/userRoutes.js
cat <<EOL > $ROUTES_DIR/userRoutes.js
const express = require('express');
const { registerUser, loginUser } = require('../controllers/userController');
const router = express.Router();

router.post('/register', registerUser);
router.post('/login', loginUser);

module.exports = router;
EOL

# controllers/userController.js
cat <<EOL > $CONTROLLERS_DIR/userController.js
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const User = require('../models/userModel');

// Register a new user
exports.registerUser = async (req, res) => {
  const { name, email, password } = req.body;

  try {
    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = await User.create({ name, email, password: hashedPassword });

    res.status(201).json({ message: 'User registered successfully', user: newUser });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Login user
exports.loginUser = async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ email });
    if (!user) return res.status(404).json({ error: 'User not found' });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ error: 'Invalid credentials' });

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '1h' });
    res.json({ message: 'Login successful', token });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
EOL

# models/userModel.js
cat <<EOL > $MODELS_DIR/userModel.js
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);
EOL

# middleware/authMiddleware.js
cat <<EOL > $MIDDLEWARE_DIR/authMiddleware.js
const jwt = require('jsonwebtoken');

const authenticateToken = (req, res, next) => {
  const token = req.header('Authorization');
  if (!token) return res.status(401).json({ error: 'Access denied, no token provided' });

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    res.status(400).json({ error: 'Invalid token' });
  }
};

module.exports = authenticateToken;
EOL

# Install dependencies
echo "Installing dependencies..."
cd $BACKEND_DIR && npm install

echo "Backend setup complete!"
