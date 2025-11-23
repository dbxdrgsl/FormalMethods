# Lab 4: Writing Specifications and Verifying Programs in Dafny

## Overview

This lab focuses on the complete verification workflow: writing specifications from informal descriptions, implementing algorithms, and proving correctness using Dafny. You'll practice translating requirements into formal pre/postconditions and finding loop invariants.

## Lab Objectives

This lab has three main goals:
1. **Spec → Code**: Write programs given formal specifications
2. **Code → Spec**: Write specifications for known algorithms  
3. **Informal → Formal**: Translate informal requirements to complete verified programs

**Key Principle**: Specifications must be **complete**—don't miss essential properties!

## Learning Objectives

By completing this lab, you will:
- ✓ Translate informal requirements to formal specifications
- ✓ Write complete preconditions and postconditions
- ✓ Find and verify loop invariants for array algorithms
- ✓ Verify programs automatically using Dafny
- ✓ Debug specification and implementation errors
- ✓ Understand the relationship between code and specifications

## Example: Finding Maximum of Two Numbers

### Informal Specification
"Write a program that returns the maximum between two numbers."

### Analysis

**Questions to Ask**:
- What type of numbers? (integers, reals, rationals?)
- Are there any constraints on inputs?
- What exactly qualifies as "maximum"?

**Design Decision**: Assume integers, but structure code for extensibility.

### Formal Specification

**Signature**:
```
Input: a, b -- integers
Output: max -- integer
```

**Properties**:
1. `max >= a` - Maximum is at least as large as first input
2. `max >= b` - Maximum is at least as large as second input  
3. `max == a OR max == b` - Maximum is actually one of the inputs (crucial!)

**Why property 3 matters**: Without it, `max = 1000` would satisfy properties 1-2 but be wrong!

### Implementation in Dafny

```dafny
method Max(a: int, b: int) returns (max: int)
  ensures max >= a && max >= b
  ensures max == a || max == b
{
  if a > b {
    max := a;
  } else {
    max := b;
  }
}
```

**Alternative Implementation**:
```dafny
method Max(a: int, b: int) returns (max: int)
  ensures max >= a && max >= b
  ensures max == a || max == b
{
  if a > b {
    return a;
  }
  return b;
}
```

Both verify automatically in Dafny!

## Exercise 1: Maximum of Three Integers (0.5 points)

**Task**: Write a method that returns the maximum of three integers with complete specifications.

### Requirements

**Signature**:
```dafny
method Max3(a: int, b: int, c: int) returns (max: int)
```

**What to Specify**:
1. Max must be ≥ all three inputs
2. Max must equal one of the inputs

### Solution Template

```dafny
method Max3(a: int, b: int, c: int) returns (max: int)
  ensures max >= a && max >= b && max >= c
  ensures max == a || max == b || max == c
{
  // Your implementation here
  // Hint: Use nested conditionals or find max of two, then compare with third
}
```

### Implementation Strategies

**Strategy 1: Nested Comparisons**
```dafny
{
  if a >= b && a >= c {
    max := a;
  } else if b >= c {
    max := b;
  } else {
    max := c;
  }
}
```

**Strategy 2: Use Max Helper**
```dafny
{
  var temp := Max(a, b);
  max := Max(temp, c);
}
```

### Common Mistakes

❌ **Incomplete postcondition**: Forgetting `max == a || max == b || max == c`
❌ **Incorrect logic**: Using `||` instead of `&&` in comparisons
❌ **Missing case**: Not handling all comparison scenarios

## Exercise 2: Minimum and Maximum of Two Numbers (0.5 points)

**Task**: Write a method that returns BOTH minimum and maximum of two numbers.

### Requirements

**Signature**:
```dafny
method MinMax(a: int, b: int) returns (min: int, max: int)
```

**What to Specify**:
1. `min` must be ≤ both inputs
2. `max` must be ≥ both inputs
3. `min` must equal one of the inputs
4. `max` must equal one of the inputs
5. **Crucial**: `min <= max` (min and max relationship!)

### Solution Template

```dafny
method MinMax(a: int, b: int) returns (min: int, max: int)
  ensures min <= a && min <= b
  ensures max >= a && max >= b
  ensures min == a || min == b
  ensures max == a || max == b
  ensures min <= max  // Don't forget this!
{
  // Your implementation here
}
```

### Implementation Hint

```dafny
{
  if a <= b {
    min := a;
    max := b;
  } else {
    min := b;
    max := a;
  }
}
```

### Why `min <= max` Matters

Without this postcondition:
- If `a = 5, b = 5`, could Dafny prove `min = 5, max = 5` satisfy both?
- What if implementation had bug swapping min/max?

The `min <= max` ensures consistency!

## Exercise 3: Absolute Difference (0.5 points)

**Task**: Specify postconditions for absolute difference between two integers.

### Given Code

```dafny
method AbsDiff(a: int, b: int) returns (diff: int)
  // Add your ensures clauses here
{
  if a >= b {
    diff := a - b;
  } else {
    diff := b - a;
  }
}
```

### What Should You Specify?

Think about properties of absolute difference:
1. Always non-negative: `diff >= 0`
2. Symmetric: `|a - b| = |b - a|`
3. Correctness: `diff = a - b` when `a >= b`, otherwise `diff = b - a`

### Solution

```dafny
method AbsDiff(a: int, b: int) returns (diff: int)
  ensures diff >= 0
  ensures (a >= b ==> diff == a - b) && (a < b ==> diff == b - a)
  ensures diff == a - b || diff == b - a
{
  if a >= b {
    diff := a - b;
  } else {
    diff := b - a;
  }
}
```

### Alternative Specification

```dafny
method AbsDiff(a: int, b: int) returns (diff: int)
  ensures diff >= 0
  ensures diff * diff == (a - b) * (a - b)  // Square of difference
{
  if a >= b {
    diff := a - b;
  } else {
    diff := b - a;
  }
}
```

## Exercise 4: Array Maximum with Specifications (0.5 points)

**Task**: Add preconditions, postconditions, and loop invariants to verify array maximum algorithm.

### Given Code

```dafny
method ArrayMax(a: array<int>) returns (max: int)
  // Add your requires clause here
  // Add your ensures clauses here
{
  max := a[0];
  var i := 1;
  
  while i < a.Length
    // Add your invariants here
  {
    if a[i] > max {
      max := a[i];
    }
    i := i + 1;
  }
}
```

### Analysis

**What Could Go Wrong?**:
- Empty array → accessing `a[0]` fails
- Max not actually maximum → logic error
- Max not in array → could return arbitrary value

### Solution

```dafny
method ArrayMax(a: array<int>) returns (max: int)
  requires a.Length > 0  // Array must be non-empty
  ensures forall k :: 0 <= k < a.Length ==> max >= a[k]  // Max ≥ all elements
  ensures exists k :: 0 <= k < a.Length && max == a[k]   // Max is in array
{
  max := a[0];
  var i := 1;
  
  while i < a.Length
    invariant 1 <= i <= a.Length
    invariant forall k :: 0 <= k < i ==> max >= a[k]
    invariant exists k :: 0 <= k < i && max == a[k]
  {
    if a[i] > max {
      max := a[i];
    }
    i := i + 1;
  }
}
```

### Understanding the Invariants

**Invariant 1**: `1 <= i <= a.Length`
- **Purpose**: Loop bounds
- **Initially**: After `max := a[0]; i := 1`, have `i = 1`
- **Preserved**: `i := i + 1` increments but condition ensures `i <= a.Length`
- **At Exit**: `i = a.Length`

**Invariant 2**: `forall k :: 0 <= k < i ==> max >= a[k]`
- **Purpose**: Max property for elements seen so far
- **Initially**: When `i = 1`, only checked `a[0]`, and `max = a[0]` ✓
- **Preserved**: If `a[i] > max`, update max; otherwise max still ≥ all previous
- **At Exit**: When `i = a.Length`, covers entire array → postcondition satisfied!

**Invariant 3**: `exists k :: 0 <= k < i && max == a[k]`
- **Purpose**: Max actually appears in array (not arbitrary large value)
- **Initially**: `max = a[0]` and `k = 0` witnesses existence ✓
- **Preserved**: If max updated to `a[i]`, then `k = i` is witness; otherwise previous witness still valid
- **At Exit**: When `i = a.Length`, max equals some element in full array → postcondition satisfied!

### Common Mistakes

❌ **Forgetting `a.Length > 0`**: Crashes on empty array
❌ **Wrong invariant bounds**: Using `0 <= i` instead of `1 <= i`  
❌ **Too weak invariant**: Only `max >= a[0]` doesn't establish full property
❌ **Missing existence**: Forgetting `max` must equal some array element

## Exercise 5: Array Minimum (1 point)

**Task**: Write a complete program to find the minimum element in an array with full specifications.

### Requirements

Write both the specification AND implementation.

### Solution Template

```dafny
method ArrayMin(a: array<int>) returns (min: int)
  requires a.Length > 0
  ensures forall k :: 0 <= k < a.Length ==> min <= a[k]
  ensures exists k :: 0 <= k < a.Length && min == a[k]
{
  min := a[0];
  var i := 1;
  
  while i < a.Length
    invariant 1 <= i <= a.Length
    invariant forall k :: 0 <= k < i ==> min <= a[k]
    invariant exists k :: 0 <= k < i && min == a[k]
  {
    if a[i] < min {  // Note: < not >
      min := a[i];
    }
    i := i + 1;
  }
}
```

### Key Differences from Max

- **Comparison**: Use `<` instead of `>`
- **Postcondition**: `min <= a[k]` instead of `max >= a[k]`
- **Logic**: Same structure, opposite direction

## Exercise 6: Range (Max - Min) of Array (1 point)

**Task**: Write a method that returns the difference between maximum and minimum elements.

### Requirements

**Signature**:
```dafny
method ArrayRange(a: array<int>) returns (range: int)
```

**What to Specify**:
1. Array must be non-empty (precondition)
2. Range is non-negative (postcondition)
3. Range equals max - min (postcondition)
4. There exist elements equal to max and min (postcondition)

### Solution Strategy 1: Find Max and Min Separately

```dafny
method ArrayRange(a: array<int>) returns (range: int)
  requires a.Length > 0
  ensures range >= 0
  ensures exists i, j :: 0 <= i < a.Length && 0 <= j < a.Length &&
          range == a[i] - a[j] &&
          (forall k :: 0 <= k < a.Length ==> a[i] >= a[k]) &&
          (forall k :: 0 <= k < a.Length ==> a[j] <= a[k])
{
  var max := ArrayMax(a);
  var min := ArrayMin(a);
  range := max - min;
}
```

### Solution Strategy 2: Single Pass

```dafny
method ArrayRange(a: array<int>) returns (range: int)
  requires a.Length > 0
  ensures range >= 0
  ensures exists i, j :: 0 <= i < a.Length && 0 <= j < a.Length &&
          range == a[i] - a[j] &&
          (forall k :: 0 <= k < a.Length ==> a[i] >= a[k]) &&
          (forall k :: 0 <= k < a.Length ==> a[j] <= a[k])
{
  var max := a[0];
  var min := a[0];
  var i := 1;
  
  while i < a.Length
    invariant 1 <= i <= a.Length
    invariant forall k :: 0 <= k < i ==> max >= a[k]
    invariant forall k :: 0 <= k < i ==> min <= a[k]
    invariant exists k :: 0 <= k < i && max == a[k]
    invariant exists k :: 0 <= k < i && min == a[k]
  {
    if a[i] > max {
      max := a[i];
    }
    if a[i] < min {
      min := a[i];
    }
    i := i + 1;
  }
  
  range := max - min;
}
```

### Challenge: Which is Better?

**Strategy 1 (Two Passes)**:
- ✅ Simpler logic
- ✅ Reuses verified code
- ❌ Two loop iterations

**Strategy 2 (Single Pass)**:
- ✅ More efficient (one pass)
- ❌ More complex invariants
- ❌ More code to verify

Both are correct! Choice depends on priorities (simplicity vs. efficiency).

## General Tips for Success

### 1. Start with Preconditions

**Questions to Ask**:
- What assumptions does the code make?
- What inputs would cause crashes or undefined behavior?
- Are there array bounds, non-null requirements?

### 2. Determine Postconditions

**Questions to Ask**:
- What properties should the result have?
- Is the result always in a certain range?
- Does the result relate to inputs in a specific way?
- Are there multiple properties to specify?

### 3. Finding Loop Invariants

**Strategy**:
1. **Start with postcondition**: What should be true when loop exits?
2. **Generalize**: Replace constants with loop variable
3. **Add bounds**: Ensure loop variable in valid range
4. **Check initially**: True before first iteration?
5. **Check preservation**: Maintained by loop body?
6. **Check sufficiency**: Implies postcondition when loop exits?

**Template**:
```
Postcondition: P(n)
Invariant: P(i) ∧ bounds(i)
```

### 4. Debugging Verification Failures

**Dafny says "postcondition might not hold"**:
- Check invariant is strong enough to imply postcondition
- Verify invariant + negated condition → postcondition

**Dafny says "invariant might not be maintained"**:
- Check invariant actually preserved by loop body
- Add assertions inside loop to see where it breaks

**Dafny says "assertion might not hold"**:
- Invariant may be too weak
- Add intermediate assertions to narrow down issue

### 5. Use Assertions for Debugging

```dafny
while i < a.Length
  invariant 1 <= i <= a.Length
  invariant forall k :: 0 <= k < i ==> max >= a[k]
{
  if a[i] > max {
    max := a[i];
  }
  assert max >= a[i];  // Check property holds here
  i := i + 1;
  assert 1 <= i <= a.Length;  // Check bounds still valid
}
```

## Grading Criteria

- **Exercise 1** (0.5 pts): Correct specifications and implementation for Max3
- **Exercise 2** (0.5 pts): Complete MinMax with all properties
- **Exercise 3** (0.5 pts): Appropriate postconditions for AbsDiff
- **Exercise 4** (0.5 pts): Correct precondition, postconditions, and invariants for ArrayMax
- **Exercise 5** (1 pt): Complete ArrayMin with specifications and invariants
- **Exercise 6** (1 pt): Complete ArrayRange with specifications and implementation

**Evaluation Criteria**:
- Completeness of specifications (no missing properties)
- Correctness of implementation
- Appropriate loop invariants
- Successful verification in Dafny
- Code clarity and structure

## Common Specification Patterns

### Property: Value in Range
```dafny
ensures low <= result <= high
```

### Property: Value in Array
```dafny
ensures exists k :: 0 <= k < a.Length && result == a[k]
```

### Property: Comparison with All Elements
```dafny
ensures forall k :: 0 <= k < a.Length ==> result >= a[k]  // Maximum
ensures forall k :: 0 <= k < a.Length ==> result <= a[k]  // Minimum
```

### Property: Result is One of Inputs
```dafny
ensures result == a || result == b || result == c
```

### Property: Conditional Correctness
```dafny
ensures condition ==> property1
ensures !condition ==> property2
```

## Conclusion

This lab teaches the complete formal verification workflow:
1. Understanding informal requirements
2. Translating to formal specifications
3. Implementing algorithms
4. Finding loop invariants
5. Verifying with automated tools

These skills are essential for:
- Writing correct, verified software
- Understanding program behavior formally
- Building safety-critical systems
- Documenting code with precise contracts

**Key Lesson**: Complete specifications are as important as correct code!

## Further Practice

If you finish early:
1. Write ArraySum with loop invariant for partial sums
2. Implement binary search with verification
3. Verify array sorting algorithms
4. Prove equivalence of different implementations
5. Explore Dafny's counterexample feature for invalid specs
