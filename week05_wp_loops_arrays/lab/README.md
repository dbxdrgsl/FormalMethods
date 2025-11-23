# Lab 5: Advanced Array Algorithms with Loop Invariants

## Overview

This lab advances your verification skills with more complex array algorithms including searching, counting, and binary search. You'll practice writing complete specifications with loop invariants for partial and total correctness.

## Exercises

### Exercise 1: Array Minimum with Index (0.5 points)

Find both the minimum value AND its position in the array.

**Key Specifications**:
- `requires a.Length > 0`
- `ensures min <= all elements`
- `ensures min == a[minIndex]`
- `ensures 0 <= minIndex < a.Length`

**Invariants needed**:
- Index bounds
- min is minimum of elements seen so far
- minIndex points to actual minimum location

### Exercise 2: Array Range (0.5 points)

Return difference between max and min elements.

**Approach**: Reuse or inline previous methods.

### Exercise 3: Linear Search (0.5 points)

Find if element exists in array, return its index or -1.

**Key Specifications**:
- `ensures index >= 0 ==> a[index] == key`
- `ensures index == -1 ==> (forall i :: 0 <= i < a.Length ==> a[i] != key)`

**Invariants**:
- Search progress: checked elements [0..index) don't contain key
- Index bounds

### Exercise 4: Count Occurrences (0.5 points)

Count how many times a value appears.

**Key Specifications**:
- `ensures count == |{i | 0 <= i < a.Length && a[i] == key}|`

**Invariants**:
- count equals occurrences in [0..i)
- Index bounds

### Exercise 5: Last Occurrence (1 point)

Find LAST occurrence of value in array.

**Strategy**: Search from end backwards OR track last seen index.

**Key Difference from First Occurrence**:
- Return rightmost matching index
- Ensure no later occurrence exists

### Exercise 6: Binary Search (1 point)

Search in sorted array with O(log n) complexity.

**Precondition**:
```dafny
predicate sorted(a: array<int>)
  reads a
{
  forall j, k :: 0 <= j < k < a.Length ==> a[j] <= a[k]
}
```

**Key Invariants**:
- `0 <= low <= high <= a.Length`
- If key exists, it's in range [low..high)
- Elements before low are < key
- Elements at/after high are >= key (or > key depending on variant)

**Challenge**: Getting the invariant exactly right for correctness!

## General Tips

1. **Start with postconditions**: What must be true at the end?
2. **Generalize to invariant**: Replace constants with loop variable
3. **Add bounds**: Ensure indices stay valid
4. **Check maintenance**: Does loop body preserve invariant?
5. **Verify exit**: Does invariant + ¬condition → postcondition?

## Grading

Each exercise graded on:
- Complete specifications
- Correct loop invariants
- Successful Dafny verification
- Code clarity

Total: 4.5 points available
