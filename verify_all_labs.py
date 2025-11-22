#!/usr/bin/env python3
"""
Dafny Verification Script for All Labs
This script runs 'dafny verify' on all .dfy files in lab and dafny directories
"""

import os
import subprocess
import sys
from pathlib import Path
from typing import List, Tuple

# ANSI color codes
RED = '\033[0;31m'
GREEN = '\033[0;32m'
YELLOW = '\033[1;33m'
NC = '\033[0m'  # No Color


def check_dafny_installed() -> bool:
    """Check if dafny is installed and available in PATH"""
    try:
        result = subprocess.run(['dafny', '--version'], 
                              capture_output=True, 
                              text=True, 
                              check=False)
        if result.returncode == 0:
            print("Dafny version:")
            print(result.stdout.strip())
            print()
            return True
        return False
    except FileNotFoundError:
        return False


def find_dafny_files() -> List[Path]:
    """Find all .dfy files in week*/lab/ and week*/dafny/ directories"""
    dafny_files = []
    
    # Search in lab directories
    for lab_dir in Path('.').glob('week*/lab'):
        dafny_files.extend(lab_dir.rglob('*.dfy'))
    
    # Search in dafny directories
    for dafny_dir in Path('.').glob('week*/dafny'):
        dafny_files.extend(dafny_dir.rglob('*.dfy'))
    
    return sorted(dafny_files)


def verify_file(file_path: Path) -> bool:
    """Verify a single Dafny file"""
    try:
        result = subprocess.run(['dafny', 'verify', str(file_path)],
                              capture_output=True,
                              text=True,
                              check=False)
        return result.returncode == 0
    except Exception as e:
        print(f"{RED}Error running dafny: {e}{NC}")
        return False


def main():
    """Main function to verify all Dafny files"""
    print("=" * 50)
    print("Dafny Lab Verification Script (Python)")
    print("=" * 50)
    print()
    
    # Check if dafny is installed
    if not check_dafny_installed():
        print(f"{RED}Error: dafny command not found{NC}")
        print("Please install Dafny from: https://github.com/dafny-lang/dafny/releases")
        sys.exit(1)
    
    # Find all .dfy files
    print("Searching for .dfy files in lab and dafny directories...")
    print()
    
    dafny_files = find_dafny_files()
    
    if not dafny_files:
        print(f"{YELLOW}No .dfy files found in lab/ or dafny/ directories{NC}")
        sys.exit(0)
    
    # Verify each file
    total_files = len(dafny_files)
    passed_files = 0
    failed_files = 0
    failed_file_list = []
    
    for dfy_file in dafny_files:
        print(f"{YELLOW}Verifying:{NC} {dfy_file}")
        
        if verify_file(dfy_file):
            print(f"{GREEN}✓ Passed{NC}")
            passed_files += 1
        else:
            print(f"{RED}✗ Failed{NC}")
            failed_files += 1
            failed_file_list.append(str(dfy_file))
        print()
    
    # Display summary
    print("=" * 50)
    print("Verification Summary")
    print("=" * 50)
    print(f"Total files: {total_files}")
    print(f"{GREEN}Passed: {passed_files}{NC}")
    print(f"{RED}Failed: {failed_files}{NC}")
    print()
    
    if failed_files > 0:
        print(f"{RED}Failed files:{NC}")
        for failed_file in failed_file_list:
            print(f"  - {failed_file}")
        print()
        sys.exit(1)
    
    print(f"{GREEN}All verifications passed!{NC}")
    sys.exit(0)


if __name__ == '__main__':
    main()
