# Automated Personal Finance App

An Automated Personal Finance App to manage your finances, track income and expenses, set budgets, and gain insights with detailed analytics.

---

## Features

- **User Authentication**: Sign up, log in, and secure access.
- **Dashboard**: Get an overview of your financial health.
- **Transaction Management**: Add, edit, and delete transactions.
- **Budget Tracking**: Set and monitor budgets.
- **Reports and Analytics**: Visualize financial data with charts.
- **Notifications**: Receive alerts for bill payments and budget limits.
- **Bank Integration**: Import bank transactions automatically.

---

## Tech Stack

### Backend
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB
- **Authentication**: JWT
- **Libraries**: bcrypt, dotenv, cors

### Frontend
- **Library**: React.js
- **State Management**: Redux or Context API
- **Styling**: CSS Modules / SASS
- **Data Visualization**: Chart.js / Recharts

---

## Getting Started

### Prerequisites
- **Node.js** (v16+)
- **npm** or **yarn**
- **MongoDB** (Local or Atlas)

### Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/allyelvis/automated-personal-finance-app.git
   cd automated-personal-finance-app
   ```

2. **Run the Setup Script**
   ```bash
   node setup.js
   ```

3. **Environment Variables**
   Create a `.env` file in the root directories (`backend` and `frontend`) with the following variables:

   #### Backend
   ```
   MONGO_URI=<your_mongodb_connection_string>
   JWT_SECRET=<your_jwt_secret>
   ```

   #### Frontend
   ```
   REACT_APP_API_URL=http://localhost:5000/api
   ```

4. **Start the Project**
   - **Backend**: 
     ```bash
     cd backend
     npm start
     ```
   - **Frontend**:
     ```bash
     cd frontend
     npm start
     ```

### Project Structure
- `backend/` - Contains server-side code.
- `frontend/` - Contains client-side code.

---

## Scripts
- `setup.js`: Automates project setup by installing dependencies and configuring the environment.

---

## License
MIT License
```

---

### setup.js

Save the following script as `setup.js` in the root of your project:

```javascript
const { execSync } = require("child_process");
const fs = require("fs");

const commands = [
  {
    name: "Backend Setup",
    path: "backend",
    commands: [
      "npm install",
      "echo 'MONGO_URI=<your_mongodb_connection_string>' > .env",
      "echo 'JWT_SECRET=your_jwt_secret' >> .env",
    ],
  },
  {
    name: "Frontend Setup",
    path: "frontend",
    commands: [
      "npm install",
      "echo 'REACT_APP_API_URL=http://localhost:5000/api' > .env",
    ],
  },
];

const setup = async () => {
  console.log("Starting project setup...\n");

  for (const cmdGroup of commands) {
    console.log(`Setting up ${cmdGroup.name}...`);
    process.chdir(cmdGroup.path);

    for (const cmd of cmdGroup.commands) {
      console.log(`Running: ${cmd}`);
      try {
        execSync(cmd, { stdio: "inherit" });
      } catch (error) {
        console.error(`Error running command: ${cmd}`);
        process.exit(1);
      }
    }

    process.chdir("../");
    console.log(`${cmdGroup.name} setup complete!\n`);
  }

  console.log("Setup complete! You can now start your project.");
};

setup();
```

---

### Steps to Use

1. **Place the `setup.js` file** in the root of your project directory.
2. **Ensure `backend` and `frontend` directories exist**, with respective `package.json` files.
3. **Run the setup script**:
   ```bash
   node setup.js
   ```

This script will:
- Navigate to `backend` and `frontend` directories.
- Install dependencies for both.
- Generate `.env` files with placeholders.
