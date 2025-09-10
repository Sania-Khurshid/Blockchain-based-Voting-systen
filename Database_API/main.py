  # Import required modules
import dotenv
import os
import mysql.connector
from fastapi import FastAPI, HTTPException, status, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.encoders import jsonable_encoder
from mysql.connector import errorcode
import jwt

# Loading the environment variables
dotenv.load_dotenv()

# Initialize the todoapi app
app = FastAPI()

# Define the allowed origins for CORS
origins = [
    "http://localhost:8080",
    "http://127.0.0.1:8080",
]

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Sample users for demo purposes (replace with database in production)
DEMO_USERS = {
    "admin": {"password": "admin123", "role": "admin"},
    "voter1": {"password": "vote123", "role": "user"},
    "voter2": {"password": "vote456", "role": "user"},
    "user": {"password": "user123", "role": "user"}
}

# Connect to the MySQL database (fallback to demo users if no database)
try:
    cnx = mysql.connector.connect(
        user=os.environ['MYSQL_USER'],
        password=os.environ['MYSQL_PASSWORD'],
        host=os.environ['MYSQL_HOST'],
        database=os.environ['MYSQL_DB'],
    )
    cursor = cnx.cursor()
    print("Connected to MySQL database")
except mysql.connector.Error as err:
    print(f"Database connection failed: {err}")
    print("Using demo user credentials instead")
    cnx = None
    cursor = None

# Define the authentication middleware
async def authenticate(request: Request):
    try:
        api_key = request.headers.get('authorization')
        if not api_key:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Missing authorization header"
            )
        
        token = api_key.replace("Bearer ", "")
        
        # Verify JWT token
        try:
            decoded = jwt.decode(token, os.environ['SECRET_KEY'], algorithms=['HS256'])
            return decoded
        except jwt.InvalidTokenError:
            # If JWT fails, check if it's a voter_id in demo users (for backward compatibility)
            if cursor is not None:
                cursor.execute("SELECT * FROM voters WHERE voter_id = %s", (token,))
                if token in [row[0] for row in cursor.fetchall()]:
                    return {"voter_id": token}
            elif token in DEMO_USERS:
                return {"voter_id": token}
            
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token"
            )
    except Exception:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Forbidden"
        )

# Define the POST endpoint for login
@app.get("/login")
async def login(request: Request, voter_id: str, password: str):
    # Remove authenticate() call - users shouldn't need to be authenticated to log in!
    role = await get_role(voter_id, password)

    # Assuming authentication is successful, generate a token
    token = jwt.encode({'password': password, 'voter_id': voter_id, 'role': role}, os.environ['SECRET_KEY'], algorithm='HS256')

    return {'token': token, 'role': role}

# Endpoint to get demo credentials for testing
@app.get("/demo-users")
async def get_demo_users():
    """Returns available demo user credentials for testing purposes"""
    return {
        "message": "Demo user credentials for testing",
        "users": [
            {"voter_id": "admin", "password": "admin123", "role": "admin"},
            {"voter_id": "voter1", "password": "vote123", "role": "user"},
            {"voter_id": "voter2", "password": "vote456", "role": "user"},
            {"voter_id": "user", "password": "user123", "role": "user"}
        ],
        "note": "Use these credentials when the database is not configured"
    }

# Replace 'admin' with the actual role based on authentication
async def get_role(voter_id, password):
    # First try database if available
    if cursor is not None:
        try:
            cursor.execute("SELECT role FROM voters WHERE voter_id = %s AND password = %s", (voter_id, password,))
            role = cursor.fetchone()
            if role:
                return role[0]
        except mysql.connector.Error as err:
            print(f"Database error: {err}")
    
    # Fallback to demo users
    if voter_id in DEMO_USERS and DEMO_USERS[voter_id]["password"] == password:
        return DEMO_USERS[voter_id]["role"]
    
    # If no match found
    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid voter id or password"
    )
