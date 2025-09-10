# Quick Setup Guide

This is a streamlined guide for getting the Blockchain Voting System up and running quickly.

## Prerequisites

1. **Node.js** (v14+) - [Download here](https://nodejs.org/)
2. **Python** (v3.8+) - [Download here](https://python.org/)
3. **MySQL Server** - [Download here](https://dev.mysql.com/downloads/mysql/)
4. **Ganache** - [Download here](https://trufflesuite.com/ganache/)

## Quick Start (5 minutes)

### 1. Install Dependencies
```bash
# Run the automated setup script
./setup.sh

# Or manually:
npm install
cd Database_API && pip install -r requirements.txt && cd ..
npm install -g truffle
```

### 2. Database Setup
```bash
# Start MySQL and run:
mysql -u root -p < Database_API/setup_database.sql
```

### 3. Configure Environment
Edit `Database_API/.env`:
```env
MYSQL_USER="root"
MYSQL_PASSWORD="your_mysql_password"
MYSQL_HOST="localhost"
MYSQL_DB="voting_system"
```

### 4. Start Blockchain
- Open Ganache application
- Create new workspace with RPC Server: `http://127.0.0.1:7545`

### 5. Deploy Contracts
```bash
truffle migrate --reset
```

### 6. Build & Run
```bash
npm run build
./start.sh
```

### 7. Access Application
Open browser: `http://localhost:8080`

**Login credentials:**
- Admin: `admin` / `admin123`
- User: `voter1` / `password1`

## Troubleshooting

If you encounter issues, see `TROUBLESHOOTING.md` or the full `README.md`.

## Common Issues

- **Build fails**: Run `npm install` and ensure all dependencies are installed
- **Database connection**: Check MySQL is running and credentials in `.env`
- **Contract deployment**: Ensure Ganache is running on port 7545
- **Frontend errors**: Check browser console, may need to connect MetaMask