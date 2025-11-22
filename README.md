# Formal Methods + Dafny Course

This repository contains course materials for a Formal Methods course using Dafny for program verification.

## Course Structure

The course is organized into 6 weeks, each with dedicated materials:

### Week 01: Introduction
- Introduction to formal methods and Dafny
- Location: `week01_intro/`

### Week 02: Formal Systems
- Formal systems fundamentals, syntax, and semantics
- Location: `week02_formal_systems/`

### Week 03: IMP Semantics
- Semantics of the IMP programming language
- Location: `week03_imp_semantics/`

### Week 04: Hoare Logic & Weakest Preconditions
- Hoare logic and weakest precondition calculus
- Location: `week04_hoare_logic_wp/`

### Week 05: WP for Loops and Arrays
- Weakest preconditions for loops and array operations
- Location: `week05_wp_loops_arrays/`

### Week 06: Strongest Postcondition Calculus
- Strongest postcondition calculus and forward reasoning
- Location: `week06_sp_calculus/`

## Directory Structure

Each week folder contains:
- `summary.md` - Week overview and learning objectives
- `lab/` - Lab exercises for hands-on practice
- `dafny/` - Dafny code examples and verification exercises
- `notes/` - Lecture notes and supplementary materials

Additional directories:
- `pdfs_source/` - Original PDF source files for course materials

## Verification Scripts

Two scripts are provided to verify all Dafny code in the repository:

### Bash Script
```bash
./verify_all_labs.sh
```

### Python Script
```bash
python3 verify_all_labs.py
```

Both scripts will:
- Search for all `.dfy` files in `week*/lab/` and `week*/dafny/` directories
- Run `dafny verify` on each file
- Display a summary of passed and failed verifications

## Prerequisites

- [Dafny](https://github.com/dafny-lang/dafny/releases) - Download and install the latest version
- Ensure `dafny` is available in your PATH

## Usage

1. Navigate to a specific week folder
2. Review the `summary.md` for an overview
3. Check `notes/` for lecture materials
4. Complete exercises in `lab/`
5. Study examples in `dafny/`
6. Verify your code using the verification scripts

## Contributing

When adding new materials:
- Place PDFs in `pdfs_source/`
- Add lab exercises to the appropriate week's `lab/` directory
- Add Dafny examples to the appropriate week's `dafny/` directory
- Update the week's `summary.md` as needed

## License

This course material is provided for educational purposes.