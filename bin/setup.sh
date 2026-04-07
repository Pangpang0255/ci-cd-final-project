#!/bin/bash

# This script can run on both Linux/Mac and Windows (with WSL or Git Bash)
# For Windows PowerShell, use: .\bin\setup.ps1

echo "**************************************************"
echo " Setting up Node.js Counter Service Environment"
echo "**************************************************"

# Check if Node.js is already installed
if command -v node &> /dev/null && command -v npm &> /dev/null; then
    echo "✓ Node.js is already installed"
    node --version
    npm --version
else
    echo "✗ Node.js is not installed"
    echo "Please install Node.js from: https://nodejs.org/"
    exit 1
fi

echo ""
echo "*** Installing project dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo "✗ Failed to install dependencies"
    exit 1
fi

echo ""
echo "*** Setting up environment variables..."

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    cat > .env << EOF
NODE_ENV=development
PORT=8000
EOF
    echo "✓ Created .env file"
else
    echo "✓ .env file already exists"
fi

echo ""
echo "**************************************************"
echo " Node.js Counter Service Environment Setup Complete"
echo "**************************************************"
echo ""
echo "Next steps:"
echo "  - npm start       : Run the service"
echo "  - npm run dev     : Development with auto-reload"
echo "  - npm test        : Run tests"
echo ""