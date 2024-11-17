#!/bin/bash

# Script to automate frontend setup for Automated Personal Finance App

# Project directory
FRONTEND_DIR="frontend"
SRC_DIR="$FRONTEND_DIR/src"
COMPONENTS_DIR="$SRC_DIR/components"
PAGES_DIR="$SRC_DIR/pages"
STYLES_DIR="$SRC_DIR/styles"
CONTEXT_DIR="$SRC_DIR/context"
UTILS_DIR="$SRC_DIR/utils"

# Start setup
echo "Starting frontend setup..."

# Create directory structure
echo "Creating directory structure..."
mkdir -p $COMPONENTS_DIR $PAGES_DIR $STYLES_DIR $CONTEXT_DIR $UTILS_DIR

# Initialize React project
echo "Initializing React project..."
npx create-react-app $FRONTEND_DIR

# Navigate to the project directory
cd $FRONTEND_DIR

# Install dependencies
echo "Installing additional dependencies..."
npm install axios react-router-dom@6 react-icons

# Create essential files
echo "Creating essential files..."

# App.css
cat <<EOL > $STYLES_DIR/App.css
body {
  font-family: Arial, sans-serif;
  background-color: #f4f4f9;
  margin: 0;
  padding: 0;
}

header {
  background: #6200ea;
  color: #fff;
  padding: 10px;
  text-align: center;
}

.container {
  max-width: 1200px;
  margin: 20px auto;
  padding: 20px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}
EOL

# App.js
cat <<EOL > $SRC_DIR/App.js
import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import HomePage from './pages/HomePage';
import DashboardPage from './pages/DashboardPage';

function App() {
  return (
    <Router>
      <header>
        <h1>Automated Personal Finance App</h1>
      </header>
      <div className="container">
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/dashboard" element={<DashboardPage />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
EOL

# HomePage.js
cat <<EOL > $PAGES_DIR/HomePage.js
import React from 'react';

const HomePage = () => {
  return (
    <div>
      <h2>Welcome to the Automated Personal Finance App</h2>
      <p>Manage your finances with ease!</p>
    </div>
  );
};

export default HomePage;
EOL

# DashboardPage.js
cat <<EOL > $PAGES_DIR/DashboardPage.js
import React from 'react';

const DashboardPage = () => {
  return (
    <div>
      <h2>Dashboard</h2>
      <p>Track your income, expenses, and budgets here.</p>
    </div>
  );
};

export default DashboardPage;
EOL

# axios instance (axios.js)
cat <<EOL > $UTILS_DIR/axios.js
import axios from 'axios';

const instance = axios.create({
  baseURL: process.env.REACT_APP_API_URL || 'http://localhost:5000/api',
});

export default instance;
EOL

# context for global state
cat <<EOL > $CONTEXT_DIR/AppContext.js
import React, { createContext, useReducer } from 'react';

const AppContext = createContext();

const initialState = {
  user: null,
};

const reducer = (state, action) => {
  switch (action.type) {
    case 'SET_USER':
      return { ...state, user: action.payload };
    default:
      return state;
  }
};

export const AppProvider = ({ children }) => {
  const [state, dispatch] = useReducer(reducer, initialState);

  return (
    <AppContext.Provider value={{ state, dispatch }}>
      {children}
    </AppContext.Provider>
  );
};

export default AppContext;
EOL

# Update .env
cat <<EOL > .env
REACT_APP_API_URL=http://localhost:5000/api
EOL

# Cleanup
echo "Cleaning up unnecessary files..."
rm -rf $SRC_DIR/App.test.js $SRC_DIR/logo.svg $SRC_DIR/setupTests.js $SRC_DIR/reportWebVitals.js

echo "Frontend setup complete!"
