"""
Simple mock authentication API for testing the voting system
This provides basic login functionality without requiring a MySQL database
"""

from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
import jwt
import os

# Initialize the FastAPI app
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

# Mock user database
MOCK_USERS = {
    "admin001": {"password": "admin123", "role": "admin"},
    "voter001": {"password": "voter123", "role": "user"},
    "voter002": {"password": "voter456", "role": "user"},
    "voter003": {"password": "voter789", "role": "user"},
}

SECRET_KEY = "d2b861a623b1d0e89f7c91c313bce1db34fbce8356ca80cf38b72e4c5a832ed5f0fa7136ef0ed5c32641308daa88c29c108d85835afcf37e5385c8e2c4cacee6"

# Simple authentication check
async def authenticate_voter(voter_id: str, password: str):
    if voter_id in MOCK_USERS and MOCK_USERS[voter_id]["password"] == password:
        return MOCK_USERS[voter_id]["role"]
    return None

# Define the GET endpoint for login
@app.get("/login")
async def login(request: Request, voter_id: str, password: str):
    role = await authenticate_voter(voter_id, password)
    
    if not role:
        raise HTTPException(
            status_code=401,
            detail="Invalid voter id or password"
        )

    # Generate a token
    token = jwt.encode(
        {'password': password, 'voter_id': voter_id, 'role': role}, 
        SECRET_KEY, 
        algorithm='HS256'
    )

    return {'token': token, 'role': role}

@app.get("/")
async def root():
    return {
        "message": "Mock Authentication API for Blockchain Voting System",
        "status": "running",
        "test_accounts": {
            "admin": {"id": "admin001", "password": "admin123"},
            "voters": [
                {"id": "voter001", "password": "voter123"},
                {"id": "voter002", "password": "voter456"},
                {"id": "voter003", "password": "voter789"}
            ]
        }
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)