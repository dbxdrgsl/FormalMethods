# Week 01: Introduction to Formal Methods - Lecture Notes

## Overview

This week introduces the fundamental concepts of formal methods in software engineering, exploring why mathematical and logical techniques are essential for building reliable software systems.

## Key Concepts

### 1. What are Formal Methods?

**Definition**: Formal methods are mathematical techniques applied to the design and implementation of computer hardware and software to ensure correctness and reliability.

**Purpose**:
- Eliminate ambiguity through precise mathematical specifications
- Enable systematic verification of software properties
- Provide tools for reasoning about program correctness

### 2. The Need for Formal Methods

**Software Correctness** involves two key questions:
- **Validation**: Are we building the right product?
- **Correctness**: Is the product built correctly?

**Traditional approaches** (testing, code reviews) have limitations:
- Testing can only show the presence of bugs, not their absence
- Code reviews are subjective and can miss subtle issues
- Integration testing may not catch all edge cases

### 3. Real-World Failures

The course highlights several catastrophic software failures that formal methods could have prevented:

#### Example 1: Ariane 5 Flight 501 (1996)
- **Cost**: $370+ million loss
- **Cause**: Integer overflow (64-bit to 16-bit conversion)
- **Issue**: Value on 16-bit bus exceeded representable range
- **Result**: Rocket veered off course and exploded
- **Lesson**: Need for formal verification of numeric conversions

#### Example 2: Java Binary Search Bug
- **Duration**: Present for 9 years in Java's core library
- **Cause**: Integer overflow in `mid = (low + high) / 2`
- **Issue**: For large arrays, `low + high` could overflow
- **Fix**: Changed to `mid = low + (high - low) / 2`
- **Lesson**: Even simple, widely-used algorithms need verification

#### Example 3: Heartbleed (CVE-2014-0160)
- **Impact**: 66% of web servers worldwide vulnerable
- **Cause**: Missing bounds checking (4 lines of code)
- **Issue**: Buffer overflow in OpenSSL allowed memory disclosure
- **Result**: Passwords, private keys, and personal data exposed
- **Lesson**: Critical need for verification of security-sensitive code

### 4. Categories of Formal Methods

#### I. Specification Languages

**Model-Based Languages** (define system models and behaviors):
- **Z**: Uses set theory and predicate logic
- **VDM**: Focuses on system functions and data types
- **B-Method**: Defines state, operations, and proof obligations

**Property-Based Languages** (specify constraints and properties):
- **Alloy**: Expresses structural constraints using relations

**Example - B-Method Ticket System**:
```
MACHINE Ticket
VARIABLES serve, next
INVARIANT serve ∈ ℕ ∧ next ∈ ℕ ∧ serve ≤ next
INITIALISATION serve, next := 0, 0
OPERATIONS
    ss ← serv_next = 
        PRE serve < next
        THEN ss, serve := serve + 1, serve + 1
        END
    tt ← take_ticket = 
        tt, next := next, next + 1
END
```

#### II. Formal Verification Techniques

**Model Checking**:
- Explores all possible states and transitions
- Tools: SPIN, NuSMV
- Verifies temporal properties

**Automated Reasoning**:
- Uses SAT/SMT solvers to prove program properties
- Tools: Why3, Z3, CVC4, Alt-Ergo
- Automatically generates and verifies proof obligations

**Interactive Program Verification**:
- Developer-guided proof construction
- Tools: Coq, Isabelle, Agda, Idris
- Provides complete control over proof process

#### III. Program Analysis

**Static Analysis**:
- Analyzes source code without execution
- Techniques: Type checking, abstract interpretation, data flow analysis
- Tools: SonarQube, Clang Static Analyzer

**Dynamic Analysis**:
- Analyzes program during execution
- Techniques: Profiling, runtime verification, symbolic execution
- Tools: Valgrind, KLEE

#### IV. Development Methodologies

- **Refinement**: Systematic transformation from specification to implementation
- **Correct-by-Construction**: Build verified systems at each development stage
- **Design-by-Contract**: Formally specify method preconditions/postconditions
- **Verification-Aided Development**: Tools like Dafny for coding with verification
- **Model-Driven Development**: Generate code from verified models

### 5. Practical Applications

Formal methods are used in critical domains:

- **Aerospace**: Flight control systems, autopilots
- **Defense**: Weapons systems, communications
- **Nuclear Power**: Control and safety systems
- **Automotive**: Autonomous vehicles (e.g., Scania trucks)
- **Operating Systems**: seL4 (formally verified OS kernel)

### 6. Modern IDE Integration

Many IDE features originated from formal methods research:
- Static analysis (type checking, null pointer detection)
- Automated refactoring
- Code coverage analysis
- Linters and style checkers
- Plugin integration for verification tools

### 7. Understanding the Limitations

**Challenges**:
- Formal methods are difficult and require significant effort
- Steep learning curve for concepts and tools
- Expensive to apply (mainly used in critical systems)
- Cannot eliminate all vulnerabilities (depends on specification correctness)

**Misconceptions**:
- ❌ Formal methods replace testing → **No**, they complement existing techniques
- ❌ Need a PhD to use them → **No**, learnable with proper training
- ❌ Completely eliminate bugs → **No**, only as good as the specification

### 8. Why Formal Methods Work

- Based on mathematical and logical reasoning
- Eliminate ambiguity through precision
- Enable formal specification of code behavior
- Force deep understanding of software requirements
- Provide mechanical verification of correctness

## Learning Objectives

By the end of this week, you should be able to:

1. ✓ Explain what formal methods are and why they matter
2. ✓ Identify types of software failures that formal methods address
3. ✓ Distinguish between different categories of formal methods
4. ✓ Understand the trade-offs in applying formal methods
5. ✓ Recognize real-world applications of formal verification

## Course Logistics

- **Course Webpage**: https://edu.info.uaic.ro/metode-formale-inginerie-software/
- **Instructor**: Andrei Arusoaie
- **Grading**: Lab works (40%), Case study report (30%), Project (30%)
- **Minimum**: 50% to pass
- **Note**: No final exam or reexamination

## Further Reading

- [Ariane 5 Investigation Report](https://esamultimedia.esa.int/docs/esa-x-1819eng.pdf)
- [Z3 SMT Solver Guide](https://microsoft.github.io/z3guide/)
- [Clang Static Analyzer](https://llvm.org/devmtg/2020-09/slides/Using_the_clang_static_ananalyzer_to_find_bugs.pdf)
- Michael Wooldridge's Formal Methods lecture notes

## Next Steps

After reviewing these notes, proceed to:
1. Complete the lab exercises to apply bug-finding skills
2. Explore the Dafny code examples to see verification in action
3. Review the weekly summary for key takeaways
