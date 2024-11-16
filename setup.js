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
