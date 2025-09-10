#!/bin/bash

# Setup script for Blockchain Voting System
# This script installs all required dependencies

echo "🔧 Setting up Blockchain Voting System..."
echo "========================================"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js from https://nodejs.org/"
    exit 1
else
    echo "✅ Node.js found: $(node --version)"
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm"
    exit 1
else
    echo "✅ npm found: $(npm --version)"
fi

# Check if Python is installed
if command -v python3 &> /dev/null; then
    PYTHON_CMD=python3
    echo "✅ Python found: $(python3 --version)"
elif command -v python &> /dev/null; then
    PYTHON_CMD=python
    echo "✅ Python found: $(python --version)"
else
    echo "❌ Python is not installed. Please install Python from https://python.org/"
    exit 1
fi

# Check if pip is installed
if ! command -v pip3 &> /dev/null && ! command -v pip &> /dev/null; then
    echo "❌ pip is not installed. Please install pip"
    exit 1
fi

# Install Node.js dependencies
echo ""
echo "📦 Installing Node.js dependencies..."
npm install
if [ $? -ne 0 ]; then
    echo "❌ Failed to install Node.js dependencies"
    exit 1
fi

# Install Truffle globally if not installed
if ! command -v truffle &> /dev/null; then
    echo "📦 Installing Truffle globally..."
    npm install -g truffle
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install Truffle. You may need to run with sudo"
        echo "   Try: sudo npm install -g truffle"
    else
        echo "✅ Truffle installed successfully"
    fi
else
    echo "✅ Truffle already installed: $(truffle --version | head -1)"
fi

# Install Python dependencies
echo ""
echo "🐍 Installing Python dependencies..."
cd Database_API
if command -v pip3 &> /dev/null; then
    pip3 install -r requirements.txt
else
    pip install -r requirements.txt
fi

if [ $? -ne 0 ]; then
    echo "❌ Failed to install Python dependencies"
    exit 1
fi
cd ..

# Create dist directory
echo ""
echo "📁 Creating dist directory..."
mkdir -p src/dist

echo ""
echo "✅ Setup completed successfully!"
echo ""
echo "📋 Next Steps:"
echo "   1. Install and start MySQL server"
echo "   2. Run Database_API/setup_database.sql in MySQL"
echo "   3. Update Database_API/.env with your MySQL credentials"
echo "   4. Install and start Ganache (GUI or CLI)"
echo "   5. Deploy smart contracts: truffle migrate --reset"
echo "   6. Start the application: ./start.sh"
echo ""
echo "📖 For detailed instructions, see README.md"