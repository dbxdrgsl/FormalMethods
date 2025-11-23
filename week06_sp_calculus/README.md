# Week 06: Strongest Postcondition Calculus

## 📚 Course Overview

This week introduces **Strongest Postcondition (SP)** calculus, a forward reasoning method that complements Weakest Preconditions. You'll learn how SP works forwards from preconditions and see a complete case study of binary search verification.

## 🎯 Key Learning Objectives

1. **Calculate** SP mechanically for all constructs
2. **Understand** SP vs. WP trade-offs
3. **Use** forward reasoning for program analysis
4. **Combine** SP and WP for complete verification
5. **Apply** formal methods to complete case studies

## 📖 Curriculum Key Points

### 1. Forward vs. Backward Reasoning

**Weakest Precondition (WP) - Backward**:
- Start with desired postcondition Q
- Calculate: What must be true before?
- Question: "What do I need to establish Q?"
- Use case: Verification against specifications

**Strongest Postcondition (SP) - Forward**:
- Start with known precondition P
- Calculate: What can be concluded after?
- Question: "What can I conclude from P?"
- Use case: Program analysis, debugging

### 2. Strongest Postcondition Definition

**SP(S, P)** = strongest (most precise) condition that holds after executing S from any state satisfying P

**Properties**:
1. **Soundness**: `{P} S {SP(S, P)}`
2. **Strongest**: For any Q where `{P} S {Q}`, we have `SP(S, P) → Q`

### 3. SP Calculation Rules

**Assignment**:
```
SP(x := E, P) = ∃x₀. P[x₀/x] ∧ x = E[x₀/x]
```
Introduce old value, express x in terms of it

**Skip**:
```
SP(skip, P) = P
```

**Sequence**:
```
SP(S₁; S₂, P) = SP(S₂, SP(S₁, P))
```
Calculate forwards: SP of S₁ first, then SP of S₂

**Conditional**:
```
SP(if b then S₁ else S₂, P) = SP(S₁, P ∧ b) ∨ SP(S₂, P ∧ ¬b)
```

**While Loop**:
```
SP(while b do S, P) = I ∧ ¬b
```
where I is loop invariant such that:
- P → I (precondition implies invariant)
- SP(S, I ∧ b) → I (body preserves invariant)

### 4. Duality of SP and WP

**Relationship**:
```
{P} S {Q}  iff  P → WP(S, Q)  iff  SP(S, P) → Q
```

**Complete Verification**:
Both should hold:
- P → WP(S, Q) (backward check)
- SP(S, P) → Q (forward check)

### 5. When to Use Each

**Use WP when**:
- You know desired postcondition
- Designing by contract
- Most verification tools use WP

**Use SP when**:
- You know precondition, exploring consequences
- Forward symbolic execution
- Debugging ("what happens if I start here?")
- Understanding program behavior

**Use Both when**:
- Complete verification required
- Cross-checking results
- Teaching/understanding semantics

### 6. Example: Array Transformations

**Array Increment**:
```
{∀i. 0 ≤ i < n → a[i] ≥ 0}
for i := 0 to n-1 do a[i] := a[i] + 1
{?}

SP calculation shows:
{∀i. 0 ≤ i < n → a[i] ≥ 1}
```

Forward reasoning naturally describes effects!

## 🔬 Lab Requirements Analysis

### Lab 6: Binary Search Case Study

**Objective**: Complete end-to-end formal specification and verification of binary search as a template for case study assignments.

### Binary Search Analysis

#### Informal Specification

**Problem**: Find target element in sorted array

**Input**:
- `arr`: Sorted array of integers
- `target`: Integer to search for

**Output**:
- Index i where `arr[i] == target` (if exists)
- -1 if not found

**Properties**:
1. **Correctness (found)**: If return i ≥ 0, then arr[i] = target
2. **Correctness (not found)**: If return -1, target not in array
3. **Completeness**: If target exists, algorithm finds it
4. **Efficiency**: O(log n) time
5. **Safety**: No out-of-bounds access

#### Formal Specification

**Precondition**:
```dafny
predicate isSorted(arr: array<int>) {
  forall i, j :: 0 <= i < j < arr.Length ==> arr[i] <= arr[j]
}

requires isSorted(arr)
```

**Postconditions**:
```dafny
ensures 0 <= result < arr.Length ==> arr[result] == target  // Found correctly
ensures result == -1 ==> forall k :: 0 <= k < arr.Length ==> arr[k] != target  // Not found correctly
```

**Loop Invariants** (Critical!):
```dafny
invariant 0 <= low <= high + 1 <= arr.Length  // Bounds
invariant forall k :: 0 <= k < low ==> arr[k] < target  // Left exclusion
invariant forall k :: high < k < arr.Length ==> arr[k] > target  // Right exclusion
```

**Explanation**:
1. **Bounds invariant**: Ensures low and high stay valid
2. **Left exclusion**: Elements before low are < target (eliminated)
3. **Right exclusion**: Elements after high are > target (eliminated)

**Together**: If target exists, it MUST be in [low, high]!

#### Implementation

```dafny
method BinarySearch(arr: array<int>, target: int) returns (result: int)
  requires isSorted(arr)
  ensures 0 <= result < arr.Length ==> arr[result] == target
  ensures result == -1 ==> forall k :: 0 <= k < arr.Length ==> arr[k] != target
{
  var low := 0;
  var high := arr.Length - 1;
  
  while low <= high
    invariant 0 <= low <= high + 1 <= arr.Length
    invariant forall k :: 0 <= k < low ==> arr[k] < target
    invariant forall k :: high < k < arr.Length ==> arr[k] > target
  {
    var mid := low + (high - low) / 2;  // Avoid overflow!
    
    if arr[mid] < target {
      low := mid + 1;  // Eliminate left half
    } else if arr[mid] > target {
      high := mid - 1;  // Eliminate right half
    } else {
      return mid;  // Found!
    }
  }
  
  return -1;  // Not found
}
```

### Key Insights

**Why Invariants Work**:
- Maintain search window property
- Each iteration eliminates half the search space
- When low > high, no valid candidates remain
- Exclusion properties ensure correctness

**Avoiding Overflow**:
- `mid = low + (high - low) / 2` prevents overflow
- Better than `mid = (low + high) / 2`

**Efficiency**:
- Search space halves each iteration
- O(log n) implicit in algorithm structure
- Formal verification doesn't prove complexity directly

### Case Study Template

This lab serves as template for:
1. **Informal → Formal**: Translating requirements
2. **Complete Specification**: Pre/post/invariants
3. **Verification**: Proving correctness
4. **Documentation**: Clear explanations

Use this structure for your own case study assignments!

## 📂 Directory Structure

```
week06_sp_calculus/
├── README.md          # This file
├── notes/README.md    # SP theory
├── lab/README.md      # Binary search case study
├── dafny/             # Examples
└── source/            # Original materials
    ├── 6_notes_spc.md
    ├── 6_strongest-postcondition-calculus.md
    └── 6_lab.md
```

## 🔗 Key Takeaways

- **SP calculus** enables forward reasoning
- **SP** computes strongest (most precise) conclusion
- **Complements WP**: Different reasoning directions
- **Both useful**: WP for specs, SP for analysis
- **Duality**: SP and WP are two sides of same coin
- **Case studies**: Show complete verification workflow
- **Binary search**: Classic algorithm with subtle invariants

## 📚 Course Completion

**Congratulations!** You've completed the formal methods curriculum:

1. **Week 01**: Motivation and landscape
2. **Week 02**: Formal systems and logic
3. **Week 03**: Operational semantics
4. **Week 04**: Hoare Logic and WP
5. **Week 05**: Advanced WP for loops/arrays
6. **Week 06**: SP calculus and case studies

**Skills Acquired**:
- Formal specification writing
- Program verification
- Loop invariant discovery
- Tool-assisted verification (Dafny)
- Case study development

**Next Steps**:
- Apply to real projects
- Explore advanced topics
- Contribute to verified software
- Continue learning formal methods!
