# Week 05: Weakest Preconditions for Loops and Arrays

## 📚 Course Overview

This week extends the Weakest Precondition calculus with advanced techniques for loops and arrays, including **loop variants** for termination and **verification conditions** for automated checking.

## 🎯 Key Learning Objectives

1. **Calculate** WLP mechanically for all constructs
2. **Understand** difference between WLP and WP
3. **Find** loop invariants and variants systematically
4. **Generate** verification conditions
5. **Prove** total correctness with termination
6. **Apply** WP calculus to array algorithms

## 📖 Curriculum Key Points

### 1. WLP vs. WP

**Weakest Liberal Precondition (WLP)**:
- For **partial correctness** (IF terminates)
- `{WLP(S, Q)} S {Q}` assuming S terminates

**Weakest (Strict) Precondition (WP)**:
- For **total correctness** (MUST terminate)
- Guarantees both correctness AND termination

### 2. Loop Variants for Termination

**Loop Variant**: Natural number expression V that:
1. Is non-negative before each iteration: `V ≥ 0`
2. Decreases with each iteration: `V' < V`

**Example - Countdown**:
```
while n > 0 do n := n - 1
Variant: n
```

### 3. WP Rules

**Assignment**: `WP(x := E, Q) = Q[E/x]`
**Skip**: `WP(skip, Q) = Q`
**Sequence**: `WP(S₁; S₂, Q) = WP(S₁, WP(S₂, Q))`
**Conditional**: `WP(if b then S₁ else S₂, Q) = (b → WP(S₁, Q)) ∧ (¬b → WP(S₂, Q))`
**While**: `WP(while b do S, Q) = I` where:
- I ∧ ¬b → Q (exit implies postcondition)
- I ∧ b → WP(S, I) (body preserves invariant)
- I ∧ b → V ≥ 0 ∧ V decreases (termination)

### 4. Verification Conditions

**Workflow**:
1. Annotate program with specs
2. Calculate WP mechanically
3. Generate **Verification Conditions (VCs)**: logical formulas
4. Pass VCs to SMT solver (Z3)
5. All VCs valid → program correct!

**Example VCs**:
- Precondition implies initial invariant
- Invariant + ¬condition implies postcondition
- Invariant + condition implies WP(body, invariant)
- Variant decreases and stays non-negative

### 5. Forward vs. Backward Reasoning

**WP (Backward)**:
- Start with desired postcondition
- Calculate what must be true before
- Question: "What do I need?"

**SP (Forward - next week)**:
- Start with known precondition
- Calculate what can be concluded after
- Question: "What can I conclude?"

## 🔬 Lab Requirements Analysis

### Lab 5: Advanced Array Algorithms

**Objective**: Apply WP calculus and loop invariants to more complex array problems.

### Exercise Breakdown

#### Exercise 1: Min with Index (0.5 points)
**Find both minimum value AND its position**

**Specifications**:
```dafny
requires a.Length > 0
ensures min <= all elements
ensures min == a[minIndex]
ensures 0 <= minIndex < a.Length
```

**Invariants**: Track both min value and its index

#### Exercise 2: Array Range (0.5 points)
**Return max - min**

**Strategy**: Reuse or inline ArrayMax and ArrayMin

#### Exercise 3: Linear Search (0.5 points)
**Find element, return index or -1**

**Key Specifications**:
```dafny
ensures index >= 0 ==> a[index] == key
ensures index == -1 ==> (forall i :: 0 <= i < a.Length ==> a[i] != key)
```

**Invariant**: Elements checked so far don't contain key

#### Exercise 4: Count Occurrences (0.5 points)
**Count how many times value appears**

**Specification**:
```dafny
ensures count == |{i | 0 <= i < a.Length && a[i] == key}|
```

**Invariant**: Count equals occurrences in [0..i)

#### Exercise 5: Last Occurrence (1 point)
**Find LAST occurrence of value**

**Strategy**: 
- Search from end backwards, OR
- Track last seen index during forward search

**Key Difference**: Return rightmost matching index

#### Exercise 6: Binary Search (1 point)
**Search in sorted array - O(log n)**

**Precondition**:
```dafny
predicate sorted(a: array<int>) {
  forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
}
```

**Key Invariants**:
```dafny
invariant 0 <= low <= high + 1 <= a.Length
invariant forall k :: 0 <= k < low ==> a[k] < target      // Left exclusion
invariant forall k :: high < k < a.Length ==> a[k] > target  // Right exclusion
```

**Critical**: Invariants ensure if target exists, it's in [low, high]!

### Debugging Tips

**Postcondition fails**: Invariant too weak—strengthen it
**Invariant not maintained**: Too strong—weaken it  
**Missing bounds**: Add loop variable constraints
**Off-by-one**: Carefully check loop ranges

## 📂 Directory Structure

```
week05_wp_loops_arrays/
├── README.md          # This file
├── notes/README.md    # WP theory
├── lab/README.md      # Exercise guide
├── dafny/             # Examples
└── source/            # Original materials
    ├── 5_notes.md
    ├── 5_weakest_precondition_calculus.md
    └── 5_lab.md
```

## 🔗 Key Takeaways

- **WLP/WP calculus** enables automated verification
- **WLP** for partial correctness (if terminates)
- **WP** for total correctness (must terminate)
- **Loop variants** prove termination
- **Verification conditions** connect specs to proofs
- **Array algorithms** showcase power of formal methods

## ➡️ Next Week

Week 06 introduces **Strongest Postcondition (SP)** calculus, the forward reasoning complement to WP, enabling analysis from preconditions forward.
