#!/bin/bash

# Setup script for Blockchain Voting System
# This script sets up the minimal components to get the system working

echo "🚀 Setting up Blockchain Voting System..."

# Step 1: Install Node.js dependencies
echo "📦 Installing Node.js dependencies..."
npm install

# Step 2: Create build directory and mock contract artifact
echo "🏗️ Creating build artifacts..."
mkdir -p build/contracts
cat > build/contracts/Voting.json << 'EOF'
{
  "contractName": "Voting",
  "abi": [
    {
      "inputs": [
        {"name": "name", "type": "string"},
        {"name": "party", "type": "string"}
      ],
      "name": "addCandidate",
      "outputs": [{"name": "", "type": "uint256"}],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [{"name": "candidateID", "type": "uint256"}],
      "name": "vote",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "checkVote",
      "outputs": [{"name": "", "type": "bool"}],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getCountCandidates",
      "outputs": [{"name": "", "type": "uint256"}],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [{"name": "candidateID", "type": "uint256"}],
      "name": "getCandidate",
      "outputs": [
        {"name": "", "type": "uint256"},
        {"name": "", "type": "string"},
        {"name": "", "type": "string"},
        {"name": "", "type": "uint256"}
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ],
  "bytecode": "0x608060405234801561001057600080fd5b50610c8a806100206000396000f3fe",
  "networks": {},
  "schemaVersion": "3.4.4",
  "updatedAt": "2023-01-01T00:00:00.000Z"
}
EOF

# Step 3: Create JavaScript bundles
echo "📦 Creating JavaScript bundles..."
mkdir -p src/dist
npx browserify src/js/login.js -o src/dist/login.bundle.js
npx browserify src/js/app.js -o src/dist/app.bundle.js

# Step 4: Install Python dependencies
echo "🐍 Installing Python dependencies..."
pip3 install fastapi uvicorn mysql-connector-python pyjwt python-dotenv

echo "✅ Setup complete!"
echo ""
echo "🌟 To run the system:"
echo "1. Start the web server: node index.js"
echo "2. Start the mock API: python3 Database_API/mock_auth.py"
echo "3. Open browser: http://localhost:8080"
echo ""
echo "🔑 Test accounts:"
echo "Admin: admin001 / admin123"
echo "Voter: voter001 / voter123"
echo "Voter: voter002 / voter456"
echo "Voter: voter003 / voter789"