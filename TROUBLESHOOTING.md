# Troubleshooting Guide - Blockchain Voting System

This guide helps you resolve common issues when setting up and running the blockchain voting system.

## Installation Issues

### "Node.js not found" or "npm not found"
**Problem**: Node.js or npm is not installed or not in PATH
**Solution**: 
1. Download and install Node.js from https://nodejs.org/
2. Restart your terminal after installation
3. Verify with: `node --version` and `npm --version`

### "Python not found" or "pip not found"
**Problem**: Python or pip is not installed or not in PATH
**Solution**:
1. Download and install Python from https://python.org/
2. During installation, check "Add Python to PATH"
3. Restart your terminal
4. Verify with: `python --version` and `pip --version`

### "Permission denied" when installing global packages
**Problem**: Need administrator privileges to install global npm packages
**Solution**:
- **Windows**: Run command prompt as Administrator
- **macOS/Linux**: Use `sudo npm install -g truffle`

### "UNMET DEPENDENCY" errors
**Problem**: npm dependencies are not properly installed
**Solution**:
```bash
# Delete node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

## Database Issues

### "Can't connect to MySQL server"
**Problem**: MySQL server is not running or wrong connection settings
**Solution**:
1. **Start MySQL server**:
   - **Windows**: Start MySQL service from Services panel
   - **macOS**: `brew services start mysql` or MySQL System Preferences
   - **Linux**: `sudo systemctl start mysql` or `sudo service mysql start`

2. **Verify MySQL is running**:
   ```bash
   # Test connection
   mysql -u root -p
   ```

3. **Check connection settings** in `Database_API/.env`:
   ```env
   MYSQL_USER="your_username"
   MYSQL_PASSWORD="your_password" 
   MYSQL_HOST="localhost"
   MYSQL_DB="voting_system"
   ```

### "Database doesn't exist" error
**Problem**: The voting_system database hasn't been created
**Solution**:
```sql
-- Connect to MySQL and run:
CREATE DATABASE voting_system;
-- Then run Database_API/setup_database.sql
```

### "Table 'voters' doesn't exist"
**Problem**: Database tables haven't been created
**Solution**:
```bash
# Run the database setup script
mysql -u your_username -p voting_system < Database_API/setup_database.sql
```

### "Access denied for user"
**Problem**: Wrong MySQL username/password or insufficient privileges
**Solution**:
1. Verify credentials are correct
2. Grant privileges to your user:
   ```sql
   GRANT ALL PRIVILEGES ON voting_system.* TO 'your_username'@'localhost';
   FLUSH PRIVILEGES;
   ```

## Blockchain Issues

### "Connection refused" on port 7545
**Problem**: Ganache is not running
**Solution**:
1. **Using Ganache GUI**: Start the Ganache application
2. **Using Ganache CLI**: 
   ```bash
   ganache --port 7545 --deterministic
   ```
3. Verify Ganache is running by visiting http://localhost:7545

### "Network with id '*' is not configured" 
**Problem**: Truffle can't connect to Ganache network
**Solution**:
1. Check `truffle-config.js` network settings match Ganache
2. Ensure Ganache is running on the correct port (7545)
3. Try: `truffle migrate --reset --network development`

### "Contract not deployed" error
**Problem**: Smart contracts haven't been deployed to the blockchain
**Solution**:
```bash
# Compile and deploy contracts
truffle compile
truffle migrate --reset
```

### "Insufficient funds" error
**Problem**: Account doesn't have enough Ether for transactions
**Solution**:
1. In Ganache GUI: Reset/restart workspace
2. In Ganache CLI: Restart with fresh accounts
3. Import new accounts from Ganache into MetaMask

## Frontend Issues

### "Cannot GET /dist/app.bundle.js"
**Problem**: Frontend bundles haven't been built
**Solution**:
```bash
# Build the frontend bundles
npm run build

# Or create dist directory first if needed
mkdir -p src/dist
npm run build
```

### "Browserify not found"
**Problem**: Browserify dependency missing
**Solution**:
```bash
npm install browserify --save-dev
# Or reinstall all dependencies
npm install
```

### "MetaMask not connecting"
**Problem**: MetaMask not configured for local network
**Solution**:
1. **Add local network in MetaMask**:
   - Network Name: Ganache Local
   - RPC URL: http://127.0.0.1:7545
   - Chain ID: 1337 (or check in Ganache)
   - Currency Symbol: ETH

2. **Import accounts from Ganache**:
   - Copy private keys from Ganache
   - Import into MetaMask

3. **Reset MetaMask account** if transactions are stuck:
   - MetaMask Settings → Advanced → Reset Account

## Server Issues

### "Port already in use" errors
**Problem**: Another service is using the required ports
**Solution**:
1. **Find what's using the port**:
   ```bash
   # On macOS/Linux
   lsof -i :8080
   lsof -i :8000
   lsof -i :7545
   
   # On Windows
   netstat -ano | findstr :8080
   ```

2. **Kill the process or change ports**:
   - Kill: `kill -9 <PID>`
   - Or modify ports in `index.js` and uvicorn command

### "Cannot read property of undefined" errors
**Problem**: Environment variables not loaded properly
**Solution**:
1. Check `.env` files exist and have correct format
2. Restart the servers after changing `.env` files
3. Verify no extra spaces or quotes in `.env` values

### "CORS policy" errors in browser
**Problem**: Cross-origin requests blocked
**Solution**:
1. Ensure all services are running on correct ports
2. Check CORS settings in `Database_API/main.py`
3. Use the same domain (localhost or 127.0.0.1) for all services

## Application Issues

### "Login failed" error
**Problem**: Authentication not working
**Solution**:
1. **Check database connection** and voters table
2. **Verify credentials** using test accounts:
   - Admin: voter_id: `admin`, password: `admin123`
   - User: voter_id: `voter1`, password: `password1`
3. **Check browser console** for detailed error messages

### "Voting failed" or transaction errors
**Problem**: Blockchain transaction issues
**Solution**:
1. **Check voting dates** are set and current time is within range
2. **Verify MetaMask** is connected and account has ETH
3. **Check if already voted** - each address can only vote once
4. **Reset MetaMask** account if transactions are stuck

### "No candidates showing"
**Problem**: No candidates have been added or contract issues
**Solution**:
1. **Login as admin** and add candidates first
2. **Check smart contract** deployment: `truffle migrate --reset`
3. **Verify contract address** in browser console

## Getting Help

### Debug Steps
1. **Check browser console** (F12) for JavaScript errors
2. **Check server logs** in terminals running the services
3. **Verify all services are running**:
   - Frontend: http://localhost:8080
   - Backend: http://localhost:8000
   - Ganache: http://localhost:7545

### Log Files
- **Frontend logs**: Browser console (F12)
- **Backend logs**: Terminal running uvicorn
- **Ganache logs**: Ganache application or CLI output

### Common Solutions
1. **Restart everything**: Stop all services and restart
2. **Clean install**: Delete `node_modules`, run `npm install`
3. **Reset blockchain**: Restart Ganache, redeploy contracts
4. **Check firewall**: Ensure ports 7545, 8000, 8080 are open

If you're still having issues, please check:
1. All prerequisites are installed and updated
2. All services are running on correct ports
3. Environment variables are properly configured
4. Database is set up with correct tables and data