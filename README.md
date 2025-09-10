# Blockchain-based Voting System

A decentralized voting application built with Ethereum blockchain, featuring a web-based interface for secure and transparent voting.

## System Architecture

This system consists of three main components:
1. **Smart Contracts** - Ethereum blockchain contracts for vote storage and validation
2. **Frontend Server** - Express.js server serving the web interface (Port 8080)
3. **Backend API** - FastAPI server for user authentication and database operations (Port 8000)

## Prerequisites

Before running this system, ensure you have the following installed:

### Required Software
- **Node.js** (v14.0.0 or higher) - [Download here](https://nodejs.org/)
- **Python** (v3.8 or higher) - [Download here](https://python.org/)
- **MySQL Server** - [Download here](https://dev.mysql.com/downloads/mysql/)
- **Truffle Framework** - For smart contract deployment
- **Ganache** - Local Ethereum blockchain (GUI or CLI)

### Installation Commands
```bash
# Install Truffle globally
npm install -g truffle

# Install Ganache CLI (optional - you can use Ganache GUI instead)
npm install -g ganache
```

## Setup Instructions

### 1. Clone and Install Dependencies

```bash
# Clone the repository
git clone <repository-url>
cd Blockchain-based-Voting-systen

# Install Node.js dependencies
npm install

# Install Python dependencies for the backend API
cd Database_API
pip install fastapi uvicorn mysql-connector-python python-dotenv pyjwt python-multipart
cd ..
```

### 2. Database Setup

#### Create MySQL Database
1. Start your MySQL server
2. Create a new database for the voting system:
```sql
CREATE DATABASE voting_system;
USE voting_system;

-- Create voters table
CREATE TABLE voters (
    voter_id VARCHAR(50) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'user') NOT NULL DEFAULT 'user',
    name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data (admin and test users)
INSERT INTO voters (voter_id, password, role, name) VALUES 
('admin', 'admin123', 'admin', 'System Administrator'),
('voter1', 'password1', 'user', 'Test Voter 1'),
('voter2', 'password2', 'user', 'Test Voter 2');
```

#### Configure Database Connection
Edit `Database_API/.env` with your MySQL credentials:
```env
MYSQL_USER="your_mysql_username"
MYSQL_PASSWORD="your_mysql_password"
MYSQL_HOST="localhost"
MYSQL_DB="voting_system"
SECRET_KEY="d2b861a623b1d0e89f7c91c313bce1db34fbce8356ca80cf38b72e4c5a832ed5f0fa7136ef0ed5c32641308daa88c29c108d85835afcf37e5385c8e2c4cacee6"
```

### 3. Blockchain Setup

#### Option A: Using Ganache GUI
1. Download and install [Ganache](https://trufflesuite.com/ganache/)
2. Create a new workspace
3. Set RPC Server to `HTTP://127.0.0.1:7545`
4. Ensure the port matches `truffle-config.js` (port 7545)

#### Option B: Using Ganache CLI
```bash
# Start Ganache CLI on port 7545
ganache --port 7545 --deterministic
```

### 4. Deploy Smart Contracts

```bash
# Compile contracts
truffle compile

# Deploy contracts to local blockchain
truffle migrate --reset
```

### 5. Build Frontend

The application uses browserify to bundle JavaScript files. Add the following to your `package.json` scripts:
```json
{
  "scripts": {
    "build": "browserify src/js/app.js -o src/dist/app.bundle.js && browserify src/js/login.js -o src/dist/login.bundle.js",
    "start": "node index.js",
    "dev": "npm run build && npm start"
  }
}
```

Create the dist directory and build:
```bash
# Create dist directory
mkdir -p src/dist

# Build the frontend bundles
npm run build
```

## Running the Application

### Start All Services

You need to run all three components in separate terminal windows:

#### Terminal 1: Start Ganache (if using CLI)
```bash
ganache --port 7545 --deterministic
```

#### Terminal 2: Start Backend API
```bash
cd Database_API
python -m uvicorn main:app --host 127.0.0.1 --port 8000 --reload
```

#### Terminal 3: Start Frontend Server
```bash
npm start
```

### Alternative: Quick Start Script
You can create a start script. Create `start.sh`:
```bash
#!/bin/bash
echo "Starting Blockchain Voting System..."

# Start Ganache in background (if using CLI)
ganache --port 7545 --deterministic &
GANACHE_PID=$!

# Start FastAPI backend in background
cd Database_API && python -m uvicorn main:app --host 127.0.0.1 --port 8000 --reload &
API_PID=$!

# Start Express frontend
cd .. && npm start &
FRONTEND_PID=$!

echo "All services started!"
echo "Frontend: http://localhost:8080"
echo "Backend API: http://localhost:8000"
echo "Ganache: http://localhost:7545"

# Wait for user input to stop
read -p "Press Enter to stop all services..."

# Kill all background processes
kill $GANACHE_PID $API_PID $FRONTEND_PID
```

## Accessing the Application

1. **Open your browser** and navigate to: `http://localhost:8080`
2. **Login** with test credentials:
   - Admin: `voter_id: admin`, `password: admin123`
   - User: `voter_id: voter1`, `password: password1`

### Admin Functions (after logging in as admin)
- Add candidates for voting
- Set voting start and end dates
- Monitor voting process

### Voter Functions (after logging in as user)
- View available candidates
- Cast votes (one vote per voter)
- View voting results

## Troubleshooting

### Common Issues

#### "UNMET DEPENDENCY" errors
```bash
# Delete node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

#### "Cannot connect to database" error
- Verify MySQL server is running
- Check credentials in `Database_API/.env`
- Ensure database and table exist

#### "Connection refused" on port 7545
- Start Ganache before deploying contracts
- Verify Ganache is running on port 7545
- Check `truffle-config.js` port configuration

#### "Contract not deployed" error
- Run `truffle migrate --reset` after starting Ganache
- Ensure contracts compiled successfully with `truffle compile`

#### MetaMask Connection Issues
- Connect MetaMask to local network (127.0.0.1:7545)
- Import Ganache accounts into MetaMask using private keys
- Ensure MetaMask is unlocked

### Port Conflicts
If ports are already in use, modify:
- Frontend: Change port in `index.js` (line ~79)
- Backend: Change port in uvicorn command
- Ganache: Use different port and update `truffle-config.js`

## Development

### Project Structure
```
├── contracts/           # Solidity smart contracts
├── migrations/          # Truffle migration scripts
├── src/
│   ├── html/           # Frontend HTML files
│   ├── css/            # Stylesheets
│   ├── js/             # JavaScript source files
│   └── dist/           # Built/bundled JavaScript files
├── Database_API/        # FastAPI backend
├── truffle-config.js   # Truffle configuration
├── package.json        # Node.js dependencies
└── index.js           # Express server
```

### Making Changes
1. **Smart contracts**: Edit files in `contracts/`, then run `truffle migrate --reset`
2. **Frontend**: Edit files in `src/`, then run `npm run build`
3. **Backend**: Edit `Database_API/main.py`, server auto-reloads

## Security Notes

- Change the `SECRET_KEY` in both `.env` files for production
- Use strong passwords for MySQL and user accounts
- This setup is for development/testing only
- For production, use proper SSL/TLS certificates and secure hosting

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Verify all prerequisites are correctly installed
3. Ensure all services are running on correct ports
4. Check browser console for JavaScript errors
5. Review server logs for backend errors