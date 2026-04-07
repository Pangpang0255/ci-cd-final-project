#!/usr/bin/env pwsh

Write-Host "**************************************************" -ForegroundColor Cyan
Write-Host " Setting up Node.js Counter Service Environment" -ForegroundColor Cyan
Write-Host "**************************************************" -ForegroundColor Cyan
Write-Host ""

# Check if Node.js is already installed
Write-Host "*** Checking for Node.js installation..." -ForegroundColor Yellow
$nodeCheck = node --version 2>$null
$npmCheck = npm --version 2>$null

if ($nodeCheck -and $npmCheck) {
    Write-Host "[OK] Node.js is already installed" -ForegroundColor Green
    Write-Host "  Node version: $nodeCheck"
    Write-Host "  npm version: $npmCheck"
} else {
    Write-Host "[ERROR] Node.js is not installed" -ForegroundColor Red
    Write-Host "Please install Node.js from: https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "*** Installing project dependencies..." -ForegroundColor Yellow
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to install dependencies" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "*** Setting up environment variables..." -ForegroundColor Yellow

# Create .env file if it doesn't exist
if (-not (Test-Path ".env")) {
    @"
NODE_ENV=development
PORT=8000
"@ | Out-File -FilePath ".env" -Encoding UTF8
    Write-Host "[OK] Created .env file" -ForegroundColor Green
} else {
    Write-Host "[OK] .env file already exists" -ForegroundColor Green
}

Write-Host ""
Write-Host "**************************************************" -ForegroundColor Cyan
Write-Host " Node.js Counter Service Environment Setup Complete" -ForegroundColor Cyan
Write-Host "**************************************************" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Green
Write-Host "  - npm start       : Run the service" -ForegroundColor Cyan
Write-Host "  - npm run dev     : Development with auto-reload" -ForegroundColor Cyan
Write-Host "  - npm test        : Run tests" -ForegroundColor Cyan
Write-Host ""
