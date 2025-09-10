# Demo Login Credentials

The blockchain voting system has been configured with demo user credentials for testing purposes.

## Available Demo Users

### Admin Account
- **Voter ID:** `admin`
- **Password:** `admin123`
- **Role:** `admin`
- **Access:** Admin panel to manage candidates and voting dates

### User/Voter Accounts
- **Voter ID:** `voter1`
- **Password:** `vote123`
- **Role:** `user`
- **Access:** Voting interface

- **Voter ID:** `voter2`
- **Password:** `vote456`
- **Role:** `user`
- **Access:** Voting interface

- **Voter ID:** `user`
- **Password:** `user123`
- **Role:** `user`
- **Access:** Voting interface

## How to Use

1. Start the Database API server:
   ```bash
   cd Database_API
   python3 -m uvicorn main:app --host 127.0.0.1 --port 8000
   ```

2. Start the Express web server:
   ```bash
   node index.js
   ```

3. Open http://127.0.0.1:8080 in your browser

4. Use any of the demo credentials above to log in

## API Endpoints

- `GET /demo-users` - Returns list of available demo users
- `GET /login?voter_id=<id>&password=<pass>` - Login endpoint

## Note

These are demo credentials only. In a production environment, you should:
- Configure a proper MySQL database
- Use secure password hashing
- Implement proper user management
- Remove the demo user fallback system