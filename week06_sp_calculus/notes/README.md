# Week 06: Strongest Postcondition Calculus - Lecture Notes

## Overview

This week introduces the **Strongest Postcondition (SP)** calculus, a forward reasoning method that complements Weakest Preconditions. While WP works backwards from postconditions, SP works forwards from preconditions to determine what can be concluded after execution.

## Key Concepts

### 1. Forward vs. Backward Reasoning

**Weakest Precondition (WP)** - Backward:
- Start with desired postcondition Q
- Calculate what must be true before: WP(S, Q)
- Question: "What do I need to establish Q?"

**Strongest Postcondition (SP)** - Forward:
- Start with known precondition P
- Calculate what can be concluded after: SP(S, P)
- Question: "What can I conclude from P?"

### 2. Strongest Postcondition Definition

**SP(S, P)** is the **strongest** (most precise) condition that holds after executing S from any state satisfying P.

**Properties**:
1. **Soundness**: {P} S {SP(S, P)}
2. **Strongest**: For any Q where {P} S {Q}, we have SP(S, P) → Q

### 3. SP Calculation Rules

#### Assignment
```
SP(x := E, P) = ∃x₀. P[x₀/x] ∧ x = E[x₀/x]
```
Introduce old value x₀, express x in terms of it.

**Example**:
```
SP(x := x + 1, x > 0)
= ∃x₀. (x₀ > 0) ∧ (x = x₀ + 1)
= x > 1
```

#### Skip
```
SP(skip, P) = P
```

#### Sequential Composition
```
SP(S₁; S₂, P) = SP(S₂, SP(S₁, P))
```
Calculate forwards: SP of S₁ first, then SP of S₂.

#### Conditional
```
SP(if b then S₁ else S₂, P)
= SP(S₁, P ∧ b) ∨ SP(S₂, P ∧ ¬b)
```

#### While Loop
```
SP(while b do S, P) = I ∧ ¬b
```
where I is a loop invariant such that:
- P → I (precondition implies invariant initially)
- SP(S, I ∧ b) → I (loop body preserves invariant)

### 4. When to Use SP vs. WP

**Use WP when**:
- You know desired postcondition
- Working with specifications (design by contract)
- Most verification tools use WP

**Use SP when**:
- You know precondition, exploring consequences
- Forward symbolic execution
- Debugging (what happens if I start here?)
- Understanding program behavior

**Often used together**: Calculate both and check SP(S, P) → Q

### 5. Relationship Between SP and WP

**Duality**:
```
{P} S {Q}  iff  P → WP(S, Q)  iff  SP(S, P) → Q
```

**Complete verification**:
```
P → WP(S, Q)  and  SP(S, P) → Q
```
Both should hold for correct program!

### 6. Example: Array Algorithms

**Array Increment**:
```
{∀i. 0 ≤ i < n → a[i] ≥ 0}
for i := 0 to n-1 do
  a[i] := a[i] + 1
{?}

SP calculation shows:
{∀i. 0 ≤ i < n → a[i] ≥ 1}
```

Forward reasoning naturally describes effect!

## Learning Objectives

By the end of this week, you should be able to:
1. ✓ Calculate SP mechanically for all constructs
2. ✓ Understand SP vs. WP trade-offs
3. ✓ Use forward reasoning for analysis
4. ✓ Combine SP and WP for verification
5. ✓ Apply SP to array transformations

## Summary

- **SP calculus** enables forward reasoning
- **SP** computes strongest (most precise) conclusion
- **Complements WP**: Different reasoning direction
- **Both are useful**: WP for specs, SP for analysis
- **Duality**: SP and WP are two sides of same coin

## Why This Matters

- Complete understanding of program semantics
- Different verification strategies
- Symbolic execution foundations
- Program analysis techniques

## Next Steps

1. Complete lab exercises using both SP and WP
2. Practice forward and backward reasoning
3. Compare results from both methods
4. Apply to real verification problems
