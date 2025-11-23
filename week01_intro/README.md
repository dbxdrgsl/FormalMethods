# Week 01: Introduction to Formal Methods

## 📚 Course Overview

This week introduces the fundamental concepts of **formal methods**—mathematical techniques used to design and verify computer hardware and software. The course motivates why formal methods are essential for building reliable, safety-critical systems.

## 🎯 Key Learning Objectives

By the end of this week, you will be able to:
1. **Understand** what formal methods are and why they matter in software engineering
2. **Identify** types of software failures that formal methods can prevent
3. **Recognize** different categories and tools in the formal methods landscape
4. **Analyze** code for common algorithmic bugs
5. **Appreciate** the limitations of testing versus formal verification

## 📖 Curriculum Key Points

### 1. What Are Formal Methods?

**Definition**: Formal methods are mathematical and logical techniques applied to the design and implementation of computer systems to ensure correctness and reliability.

**Core Components**:
- **Formal specifications**: Precise mathematical descriptions of system behavior
- **Formal semantics**: Mathematical models of program execution
- **Proof systems**: Logical rules to prove program correctness

**Purpose**:
- Eliminate ambiguity in requirements and specifications
- Enable systematic verification of software properties
- Provide guarantees that go beyond testing

### 2. The Need for Formal Methods

**Software Correctness Questions**:
- **Validation**: Are we building the right product?
- **Correctness**: Is the product built correctly?

**Limitations of Traditional Approaches**:
- **Testing**: Can only show presence of bugs, not their absence
- **Code Reviews**: Subjective and can miss subtle issues
- **Integration Testing**: May not catch all edge cases or rare conditions

**Where Formal Methods Excel**:
- Safety-critical systems (aerospace, medical, automotive)
- Security-sensitive code (cryptography, authentication)
- Financial systems where errors are costly
- Compiler correctness and OS kernels

### 3. Real-World Failures (Motivating Examples)

#### Example 1: Ariane 5 Flight 501 (1996)
- **Cost**: $370+ million loss
- **Cause**: 64-bit to 16-bit integer conversion overflow
- **Issue**: Value exceeded representable range on 16-bit bus
- **Result**: Rocket self-destructed 37 seconds after launch
- **Lesson**: Need for formal verification of numeric conversions

#### Example 2: Java Binary Search Bug
- **Duration**: Present for 9 years in Java's standard library
- **Cause**: Integer overflow in `mid = (low + high) / 2`
- **Issue**: For large arrays, `low + high` could overflow
- **Fix**: Changed to `mid = low + (high - low) / 2`
- **Lesson**: Even simple, well-known algorithms need verification

#### Example 3: Heartbleed (CVE-2014-0160)
- **Impact**: 66% of web servers worldwide vulnerable
- **Cause**: Missing bounds checking (just 4 lines of code)
- **Issue**: Buffer overflow in OpenSSL allowed memory disclosure
- **Data Exposed**: Passwords, private keys, personal information
- **Lesson**: Critical need for verification of security-sensitive code

### 4. Formal Methods Landscape

The course introduces several categories of formal methods:

#### I. Specification Languages
- **Model-based**: Z, VDM, B-Method (define system models)
- **Property-based**: Alloy (express structural constraints)

#### II. Verification Techniques
- **Model Checking**: SPIN, NuSMV (explore all states)
- **Automated Reasoning**: Why3, Z3, CVC4 (SMT solvers)
- **Interactive Verification**: Coq, Isabelle, Agda (developer-guided proofs)

#### III. Program Analysis
- **Static Analysis**: SonarQube, Clang (analyze without execution)
- **Dynamic Analysis**: Valgrind, KLEE (analyze during execution)

#### IV. Development Methodologies
- **Design-by-Contract**: Formal preconditions/postconditions
- **Verification-Aided Development**: Tools like Dafny
- **Correct-by-Construction**: Build verified systems incrementally

### 5. Practical Applications

Formal methods are actively used in:
- **Aerospace**: Flight control systems, autopilots
- **Defense**: Weapons systems, communications
- **Nuclear Power**: Control and safety systems
- **Automotive**: Autonomous vehicles (e.g., Scania trucks)
- **Operating Systems**: seL4 (formally verified OS kernel)
- **IDE Features**: Many modern IDE features originated from formal methods research

### 6. Understanding the Trade-offs

**Challenges**:
- Steep learning curve for concepts and tools
- Expensive to apply (mainly used in critical systems)
- Cannot eliminate all bugs (depends on specification correctness)
- Requires significant effort and expertise

**Benefits**:
- Proves correctness for ALL inputs (not just test cases)
- Finds bugs before deployment
- Provides formal documentation of intended behavior
- Enables safe refactoring with confidence

**Misconceptions to Avoid**:
- ❌ Formal methods replace testing → They complement testing
- ❌ Need PhD to use them → Learnable with proper training
- ❌ Completely eliminate bugs → Only as good as specifications

## 🔬 Lab Requirements Analysis

### Lab 1: Bug Finding in Common Algorithms

**Objective**: Develop critical code reading skills by identifying bugs in standard algorithms—motivating the need for formal verification.

**Skills Developed**:
- Careful analysis of algorithmic correctness
- Understanding edge cases and boundary conditions
- Recognizing common bug patterns (overflow, off-by-one, etc.)
- Appreciating why bugs persist even in well-known code

### Exercise Breakdown

#### Exercise 1: QuickSort Implementation (1 point)
**What to Find**:
- Integer overflow in pivot calculation: `(low + high) / 2`
- Incorrect recursive call: Should be `quicksort(arr, pivotIndex + 1, high)`
- Potential infinite recursion if pivot doesn't move

**Key Learning**: Even simple optimizations can introduce subtle bugs

#### Exercise 2: Binary Search Implementation (1 point)
**What to Find**:
- Wrong termination condition: `low < high` should be `low <= high`
- Incorrect bound update: `low = mid` should be `low = mid + 1`
- Potential infinite loop scenario

**Key Learning**: Loop invariants and termination conditions are critical

#### Exercise 3: Matrix Multiplication in Python (1 point)
**What to Find**:
- Shallow copy issue: `C = [[0] * p] * m` creates references to same list
- Wrong indices: `A[k][j] * B[i][k]` should be `A[i][k] * B[k][j]`

**Key Learning**: Language semantics matter for correctness

#### Exercise 4: Longest Increasing Subsequence (1 point)
**What to Find**:
- Wrong comparison: `arr[j] <= arr[i]` should be `arr[j] < arr[i]`
- Difference between "increasing" vs. "non-decreasing" subsequences

**Key Learning**: Precise specification is essential

### Common Themes Across Exercises

1. **Integer Overflow**: Easy to miss, hard to test, but formal methods catch automatically
2. **Off-by-One Errors**: Boundary conditions are notoriously tricky
3. **Shallow vs. Deep Copy**: Reference semantics can cause unexpected behavior
4. **Index Confusion**: Easy to swap indices in nested loops
5. **Comparison Operators**: `<` vs. `<=` has significant semantic differences

### Why These Exercises Matter

**Testing Approach**:
- Might catch bugs IF you write the right test cases
- Requires exhaustive thinking about edge cases
- Cannot prove absence of bugs

**Formal Methods Approach**:
- WILL catch bugs by proving correctness mathematically
- Verifies all possible inputs automatically
- Provides guarantee of correctness

## 📂 Directory Structure

```
week01_intro/
├── README.md          # This file - week overview
├── summary.md         # Quick summary
├── notes/
│   └── README.md      # Comprehensive lecture notes
├── lab/
│   └── README.md      # Detailed lab exercise guide
├── dafny/             # Dafny code examples
└── source/            # Original PDF copilot materials
    ├── 1_intro.md     # Source lecture material
    └── 1_lab.md       # Source lab material
```

## 🚀 Getting Started

1. **Read**: Start with `notes/README.md` for comprehensive lecture content
2. **Practice**: Work through exercises in `lab/README.md`
3. **Explore**: Check `source/` for original source materials
4. **Code**: Experiment with examples in `dafny/` folder

## 🔗 Key Takeaways

- **Formal methods** provide mathematical guarantees of correctness
- **Real-world failures** demonstrate the cost of software bugs
- **Testing alone** is insufficient for critical systems
- **Bug finding** skills motivate the need for formal verification
- **The landscape** of formal methods is diverse and growing
- **Trade-offs** exist: formal methods are powerful but require investment

## 📚 Resources

- [Ariane 5 Investigation Report](https://esamultimedia.esa.int/docs/esa-x-1819eng.pdf)
- [Binary Search Bug Story](https://research.google/blog/extra-extra-read-all-about-it-nearly-all-binary-searches-and-mergesorts-are-broken/)
- Course webpage: https://edu.info.uaic.ro/metode-formale-inginerie-software/

## ➡️ Next Week

Week 02 will introduce **formal systems** and **propositional logic**, providing the mathematical foundation for formal verification. You'll learn about syntax, semantics, inference rules, and how to encode logic in Dafny.
