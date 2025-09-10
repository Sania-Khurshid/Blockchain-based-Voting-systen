#!/bin/bash

# Blockchain Voting System Startup Script
# This script starts all required services for the voting system

echo "🗳️  Starting Blockchain Voting System..."
echo "======================================"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js from https://nodejs.org/"
    exit 1
fi

# Check if Python is installed
if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    echo "❌ Python is not installed. Please install Python from https://python.org/"
    exit 1
fi

# Check if npm packages are installed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing Node.js dependencies..."
    npm install
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install Node.js dependencies"
        exit 1
    fi
fi

# Create dist directory if it doesn't exist
if [ ! -d "src/dist" ]; then
    echo "📁 Creating dist directory..."
    mkdir -p src/dist
fi

# Build frontend bundles
echo "🔨 Building frontend bundles..."
npm run build
if [ $? -ne 0 ]; then
    echo "❌ Failed to build frontend bundles"
    echo "   This might be due to missing contract files or network issues"
    echo "   The application may still work if bundles were created previously"
fi

# Check if bundles exist
if [ ! -f "src/dist/app.bundle.js" ] || [ ! -f "src/dist/login.bundle.js" ]; then
    echo "❌ Frontend bundles not found. Please run 'npm run build' manually"
    exit 1
fi

# Check if Ganache is running (optional check)
echo "🔗 Checking Ganache connection..."
if ! curl -s http://127.0.0.1:7545 > /dev/null; then
    echo "⚠️  Warning: Ganache doesn't seem to be running on port 7545"
    echo "   Please make sure to start Ganache before using the application"
    echo "   - GUI: Start Ganache application"
    echo "   - CLI: Run 'ganache --port 7545 --deterministic' in another terminal"
fi

# Function to start services in background
start_services() {
    echo ""
    echo "🚀 Starting services..."
    
    # Start FastAPI backend
    echo "🐍 Starting FastAPI backend (port 8000)..."
    cd Database_API
    python3 -m uvicorn main:app --host 127.0.0.1 --port 8000 --reload &
    API_PID=$!
    cd ..
    
    # Wait a moment for API to start
    sleep 2
    
    # Start Express frontend
    echo "🌐 Starting Express frontend (port 8080)..."
    npm start &
    FRONTEND_PID=$!
    
    echo ""
    echo "✅ All services started successfully!"
    echo ""
    echo "📋 Service Information:"
    echo "   Frontend:    http://localhost:8080"
    echo "   Backend API: http://localhost:8000"
    echo "   Ganache:     http://localhost:7545"
    echo ""
    echo "🔑 Default Login Credentials:"
    echo "   Admin:    voter_id: admin,  password: admin123"
    echo "   User 1:   voter_id: voter1, password: password1"
    echo "   User 2:   voter_id: voter2, password: password2"
    echo ""
    echo "⚠️  Important Setup Notes:"
    echo "   1. Make sure MySQL is running and configured"
    echo "   2. Run Database_API/setup_database.sql in MySQL"
    echo "   3. Update Database_API/.env with your MySQL credentials"
    echo "   4. Make sure Ganache is running on port 7545"
    echo "   5. Deploy smart contracts with: truffle migrate --reset"
    echo ""
    
    # Wait for user input to stop
    echo "Press Ctrl+C or Enter to stop all services..."
    read -r
    
    # Kill background processes
    echo "🛑 Stopping services..."
    kill $API_PID $FRONTEND_PID 2>/dev/null
    echo "✅ All services stopped."
}

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "🛑 Shutting down services..."
    kill $API_PID $FRONTEND_PID 2>/dev/null
    exit 0
}

# Set trap to cleanup on Ctrl+C
trap cleanup SIGINT SIGTERM

# Start services
start_services