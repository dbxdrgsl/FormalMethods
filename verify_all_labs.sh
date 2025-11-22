#!/bin/bash

# Dafny Verification Script for All Labs
# This script runs 'dafny verify' on all .dfy files in lab directories

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "Dafny Lab Verification Script"
echo "========================================="
echo ""

# Check if dafny is installed
if ! command -v dafny &> /dev/null; then
    echo -e "${RED}Error: dafny command not found${NC}"
    echo "Please install Dafny from: https://github.com/dafny-lang/dafny/releases"
    exit 1
fi

# Display Dafny version
echo "Dafny version:"
dafny --version
echo ""

# Counter for results
total_files=0
passed_files=0
failed_files=0

# Find all .dfy files in week*/lab/ directories
echo "Searching for .dfy files in lab directories..."
echo ""

for dfy_file in week*/lab/**/*.dfy week*/lab/*.dfy; do
    # Skip if no files found (glob didn't match)
    if [ ! -f "$dfy_file" ]; then
        continue
    fi
    
    total_files=$((total_files + 1))
    echo -e "${YELLOW}Verifying:${NC} $dfy_file"
    
    # Run dafny verify
    if dafny verify "$dfy_file"; then
        echo -e "${GREEN}✓ Passed${NC}"
        passed_files=$((passed_files + 1))
    else
        echo -e "${RED}✗ Failed${NC}"
        failed_files=$((failed_files + 1))
    fi
    echo ""
done

# Also check dafny directories
for dfy_file in week*/dafny/**/*.dfy week*/dafny/*.dfy; do
    # Skip if no files found (glob didn't match)
    if [ ! -f "$dfy_file" ]; then
        continue
    fi
    
    total_files=$((total_files + 1))
    echo -e "${YELLOW}Verifying:${NC} $dfy_file"
    
    # Run dafny verify
    if dafny verify "$dfy_file"; then
        echo -e "${GREEN}✓ Passed${NC}"
        passed_files=$((passed_files + 1))
    else
        echo -e "${RED}✗ Failed${NC}"
        failed_files=$((failed_files + 1))
    fi
    echo ""
done

# Display summary
echo "========================================="
echo "Verification Summary"
echo "========================================="
echo "Total files: $total_files"
echo -e "${GREEN}Passed: $passed_files${NC}"
echo -e "${RED}Failed: $failed_files${NC}"
echo ""

if [ $total_files -eq 0 ]; then
    echo -e "${YELLOW}No .dfy files found in lab/ or dafny/ directories${NC}"
    exit 0
fi

if [ $failed_files -gt 0 ]; then
    exit 1
fi

echo -e "${GREEN}All verifications passed!${NC}"
exit 0
