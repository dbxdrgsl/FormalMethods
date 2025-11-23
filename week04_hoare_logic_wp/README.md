# Week 04: Hoare Logic and Weakest Preconditions

## 📚 Course Overview

This week introduces **Hoare Logic**, a formal system for reasoning about program correctness through logical assertions. You'll learn the **Weakest Precondition (WP)** calculus for systematic program verification.

## 🎯 Key Learning Objectives

1. **Understand** and use Hoare triples {P} S {Q}
2. **Apply** Hoare Logic proof rules
3. **Calculate** weakest preconditions mechanically
4. **Find** and verify loop invariants
5. **Write** formal specifications in Dafny
6. **Verify** programs using automated tools

## 📖 Curriculum Key Points

### 1. Hoare Triples

**Fundamental construct**: `{P} S {Q}`
- P: Precondition (assertion about initial state)
- S: Statement or program
- Q: Postcondition (assertion about final state)

**Meaning**: "If P holds before S executes, then Q will hold after (if S terminates)"

### 2. Partial vs. Total Correctness

**Partial**: {P} S {Q} - IF S terminates AND P holds, THEN Q holds
**Total**: [P] S [Q] - P holds IMPLIES S terminates AND Q holds

**Difference**: Total correctness guarantees termination

### 3. Hoare Logic Proof Rules

**Assignment** (most important!):
```
─────────────────────── [Assign]
{P[E/x]} x := E {P}
```
Work **backwards**: Replace x with E in postcondition

**While Loop**:
```
{I ∧ b} S {I}
───────────────────────────── [While]
{I} while b do S {I ∧ ¬b}
```
I is loop invariant (true before, during, after loop)

**Sequence**:
```
{P} S₁ {Q}    {Q} S₂ {R}
────────────────────────── [Seq]
{P} S₁; S₂ {R}
```

### 4. Weakest Precondition Calculus

**WP(S, Q)** = weakest condition that, if true before S, guarantees Q after

**Rules**:
- Assignment: `WP(x := E, Q) = Q[E/x]`
- Skip: `WP(skip, Q) = Q`
- Sequence: `WP(S₁; S₂, Q) = WP(S₁, WP(S₂, Q))`
- Conditional: `WP(if b then S₁ else S₂, Q) = (b → WP(S₁, Q)) ∧ (¬b → WP(S₂, Q))`
- While: `WP(while b do S, Q) = I` where I is invariant

**Key**: Enables automated precondition calculation!

### 5. Loop Invariants

**Properties**:
- True before loop starts
- Maintained by loop body
- Combined with ¬condition, implies postcondition

**Finding Strategy**:
1. Start with postcondition
2. Generalize (replace constants with loop variable)
3. Add bounds for loop variable
4. Check: Initially true? Preserved? Implies postcondition?

### 6. Total Correctness

**Loop Variants**: Expression that:
- Is non-negative before each iteration
- Decreases with each iteration
- Proves termination

**Example**: Countdown loop with variant n

## 🔬 Lab Requirements Analysis

### Lab 4: Specifications and Verification in Dafny

**Objective**: Complete verification workflow from informal requirements to verified implementation.

### Exercise Breakdown

#### Exercise 1: Max of Three (0.5 points)
**Specification**:
```dafny
ensures max >= a && max >= b && max >= c
ensures max == a || max == b || max == c
```

**Key**: Second property essential—prevents arbitrary large values

#### Exercise 2: Min and Max (0.5 points)
**Specification**:
```dafny
ensures min <= a && min <= b
ensures max >= a && max >= b
ensures min == a || min == b
ensures max == a || max == b
ensures min <= max  // Critical relationship!
```

#### Exercise 3: Absolute Difference (0.5 points)
**Properties**:
- Non-negative: `diff >= 0`
- Correctness: `(a >= b ==> diff == a - b) && (a < b ==> diff == b - a)`
- Equivalence: `diff == a - b || diff == b - a`

#### Exercise 4: Array Maximum (0.5 points)
**Precondition**: `requires a.Length > 0`

**Postconditions**:
```dafny
ensures forall k :: 0 <= k < a.Length ==> max >= a[k]  // Maximum property
ensures exists k :: 0 <= k < a.Length && max == a[k]   // Element exists
```

**Invariants**:
```dafny
invariant 1 <= i <= a.Length                           // Bounds
invariant forall k :: 0 <= k < i ==> max >= a[k]       // Max so far
invariant exists k :: 0 <= k < i && max == a[k]        // Element exists
```

**Key**: Invariants generalize postcondition to partial progress

#### Exercise 5: Array Minimum (1 point)
**Similar to max, but**:
- Use `<=` instead of `>=`
- Check `<` in loop condition

#### Exercise 6: Array Range (1 point)
**Two strategies**:
1. **Two passes**: Find max, find min separately (simpler)
2. **Single pass**: Track both in one loop (more efficient)

**Specification**:
```dafny
ensures range >= 0
ensures exists i, j :: range == a[i] - a[j] && 
        (forall k :: a[i] >= a[k]) &&  // i is max
        (forall k :: a[j] <= a[k])     // j is min
```

### Common Specification Patterns

**Value in range**: `low <= result <= high`
**Value in array**: `exists k :: 0 <= k < a.Length && result == a[k]`
**Comparison with all**: `forall k :: 0 <= k < a.Length ==> result >= a[k]`
**Conditional correctness**: `condition ==> property`

### Verification Workflow

1. **Specify**: Write pre/postconditions
2. **Implement**: Write the program
3. **Annotate**: Add loop invariants
4. **Verify**: Use Dafny
5. **Debug**: If fails, strengthen invariant or fix code

## 📂 Directory Structure

```
week04_hoare_logic_wp/
├── README.md          # This file
├── notes/README.md    # Comprehensive theory
├── lab/README.md      # Exercise guide
├── dafny/             # Examples
└── source/            # Original materials
    ├── 4_notes.md
    ├── 4_slides.md
    └── 4_lab.md
```

## 🔗 Key Takeaways

- **Hoare Logic** provides formal system for program correctness
- **Hoare Triples** express specifications precisely
- **WP Calculus** automates precondition calculation
- **Loop Invariants** are key to verifying loops
- **Dafny** automates verification using these principles
- **Complete specifications** are as important as correct code!

## ➡️ Next Week

Week 05 extends WP calculus to handle loops and arrays more deeply, introducing loop variants for termination proofs and verification conditions.
