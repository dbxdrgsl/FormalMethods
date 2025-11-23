# Week 05: Weakest Preconditions for Loops and Arrays - Lecture Notes

## Overview

This week extends Hoare Logic with the **Weakest Precondition (WP)** calculus, a systematic method for automated program verification. You'll learn how to calculate preconditions mechanically and handle loops with invariants and variants for total correctness.

## Key Concepts

### 1. Motivation for Weakest Preconditions

**The Challenge**: Hoare Logic proof rules require:
- Finding intermediate assertions for sequences
- Guessing loop invariants
- Manual proof construction

**The Solution**: Weakest Precondition calculus:
- ✅ Systematic, mechanical calculation
- ✅ Works backwards from postcondition
- ✅ Enables automated verification
- ✅ No guesswork for most constructs

### 2. Weakest Liberal Precondition (WLP)

**Definition**: WLP(S, Q) is the **weakest** condition that, if true before S executes, guarantees Q holds after (assuming S terminates).

**Properties**:
1. **Soundness**: {WLP(S, Q)} S {Q}
2. **Weakest**: For any P where {P} S {Q}, we have P → WLP(S, Q)

### 3. WLP Calculation Rules

#### Assignment
```
WLP(x := E, Q) = Q[E/x]
```
Replace x with E in Q (substitution).

**Example**:
```
WLP(x := x + 1, x > 5) = (x + 1) > 5 = x > 4
```

#### Skip
```
WLP(skip, Q) = Q
```

#### Sequential Composition
```
WLP(S₁; S₂, Q) = WLP(S₁, WLP(S₂, Q))
```
Calculate backwards: WP of S₂ first, then use as postcondition for S₁.

**Example**:
```
WLP(x := 1; y := x + 1, y = 2)
= WLP(x := 1, WLP(y := x + 1, y = 2))
= WLP(x := 1, x + 1 = 2)
= WLP(x := 1, x = 1)
= 1 = 1
= true
```

#### Conditional
```
WLP(if b then S₁ else S₂, Q) = (b → WLP(S₁, Q)) ∧ (¬b → WLP(S₂, Q))
```

Equivalently:
```
= (b ∧ WLP(S₁, Q)) ∨ (¬b ∧ WLP(S₂, Q))
```

#### While Loop
```
WLP(while b do S, Q) = I
```
where I is a loop invariant such that:
- I ∧ ¬b → Q (invariant + exit condition implies postcondition)
- I ∧ b → WLP(S, I) (loop body preserves invariant)

**Note**: Loop invariants must still be provided by the programmer!

### 4. Total Correctness and Weakest Precondition (WP)

**WP(S, Q)** guarantees both:
1. Q holds after execution
2. S terminates

**Key Difference**:
- WLP: Partial correctness (if terminates)
- WP: Total correctness (must terminate)

### 5. Loop Variants for Termination

**Loop Variant**: An expression V (natural number) that:
1. Is non-negative before each iteration
2. Decreases with each iteration

**Modified While Rule for WP**:
```
WP(while b do S, Q) = I
```
where:
- I ∧ ¬b → Q
- I ∧ b → WP(S, I) ∧ (V decreases)
- I ∧ b → V ≥ 0

**Example** - Countdown loop:
```
{n ≥ 0}
while n > 0 do
  n := n - 1
{n = 0}

Variant: n
Initially: n ≥ 0 ✓
Decreases: n' = n - 1 < n ✓
Non-negative: n > 0 → n - 1 ≥ 0 ✓
```

### 6. Verification Conditions

**Workflow**:
1. Annotate program with specifications (pre/post/invariants)
2. Calculate WP mechanically
3. Generate **Verification Conditions (VCs)**: logical formulas to prove
4. Pass VCs to SMT solver (e.g., Z3)
5. If all VCs valid → program correct!

**Example**:
```
{x ≥ 0}
y := 0;
while x > 0 do
  invariant y = initial_x - x ∧ x ≥ 0
  y := y + 1;
  x := x - 1
{y = initial_x}

VCs generated:
1. x ≥ 0 → (y = 0 ∧ x ≥ 0)[0/y]  // Initial invariant
2. (y = initial_x - x ∧ x ≥ 0 ∧ ¬(x > 0)) → y = initial_x  // Exit implies post
3. (y = initial_x - x ∧ x ≥ 0 ∧ x > 0) → WP(y := y + 1; x := x - 1, invariant)  // Body preserves invariant
```

## Learning Objectives

By the end of this week, you should be able to:
1. ✓ Calculate WLP mechanically for all constructs
2. ✓ Understand difference between WLP and WP
3. ✓ Find loop invariants and variants
4. ✓ Generate verification conditions
5. ✓ Prove total correctness with termination
6. ✓ Apply WP calculus to array programs

## Summary

- **WLP/WP calculus** enables automated verification
- **WLP** for partial correctness (if terminates)
- **WP** for total correctness (must terminate)
- **Loop invariants** still need human insight
- **Loop variants** prove termination
- **Verification conditions** connect specs to proofs

## Why This Matters

- Foundation of modern verification tools (Dafny, Why3)
- Enables push-button verification
- Reduces verification to SMT solving
- Scales to large programs

## Next Steps

1. Complete lab exercises on arrays with loops
2. Practice calculating WP for complex programs
3. Find invariants and variants systematically
4. Prepare for strongest postcondition calculus
