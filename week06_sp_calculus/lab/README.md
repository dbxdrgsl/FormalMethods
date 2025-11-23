# Lab 6: Binary Search Case Study

## Overview

This lab provides a complete case study of binary search verification, serving as a template for formal specification and verification. You'll see the full workflow from informal requirements to verified implementation.

## Case Study: Binary Search in Sorted Array

### Part 1: Informal Specification

**Problem**: Implement binary search to find target element in sorted array.

**Input**:
- `arr`: Array of integers, sorted ascending
- `target`: Integer to search for

**Output**:
- Index `i` where `arr[i] == target` (if exists)
- `-1` if not found

**Informal Constraints**:
- Array must be sorted
- May be empty
- May contain duplicates (any valid index acceptable)

**Desired Properties**:
1. **Correctness (found)**: If return index i ≥ 0, then arr[i] = target
2. **Correctness (not found)**: If return -1, target not in array
3. **Completeness**: If target exists, algorithm finds it
4. **Efficiency**: O(log n) time
5. **Safety**: No out-of-bounds access

### Part 2: Formal Specification

**Precondition**:
```dafny
predicate isSorted(arr: array<int>)
  reads arr
{
  forall i, j :: 0 <= i < j < arr.Length ==> arr[i] <= arr[j]
}

requires isSorted(arr)
```

**Postconditions**:
```dafny
ensures 0 <= result < arr.Length ==> arr[result] == target
ensures result == -1 ==> forall k :: 0 <= k < arr.Length ==> arr[k] != target
```

**Loop Invariants**:
```dafny
invariant 0 <= low <= high + 1 <= arr.Length
invariant forall k :: 0 <= k < low ==> arr[k] < target
invariant forall k :: high < k < arr.Length ==> arr[k] > target
```

**Explanation**:
1. **Bounds**: low and high stay valid and properly ordered
2. **Left exclusion**: Elements before low are < target
3. **Right exclusion**: Elements after high are > target

Together: If target exists, it's in range [low, high]!

### Part 3: Implementation

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
    var mid := low + (high - low) / 2;
    
    if arr[mid] < target {
      low := mid + 1;
    } else if arr[mid] > target {
      high := mid - 1;
    } else {
      return mid;
    }
  }
  
  return -1;
}
```

## Exercise: Complete the Analysis

**Task**: Formulate how formal specs cover informal properties 3, 4, and 5:
- Completeness
- Efficiency  
- Safety

**Questions**:
1. Does our specification guarantee completeness?
2. How does invariant structure ensure O(log n)?
3. Are out-of-bounds accesses prevented?

## Correspondence Table

| Informal Property | Formal Specification |
|---|---|
| Correctness (Found) | `ensures 0 <= result < arr.Length ==> arr[result] == target` |
| Correctness (Not Found) | `ensures result == -1 ==> forall k :: ... arr[k] != target` |
| Completeness | Follows from loop invariants + termination |
| Efficiency | Loop halves search space (implicit in algorithm) |
| Safety | Bounds invariant + Dafny's array access checking |

## Learning Objectives

- ✓ Complete specification workflow
- ✓ Translating informal to formal requirements
- ✓ Finding correct loop invariants for search algorithms
- ✓ Understanding binary search verification
- ✓ Template for case study assignments

## Key Takeaways

1. **Invariants are crucial**: Capture search window properties
2. **Exclusion properties**: Key to binary search correctness
3. **Bounds maintenance**: Prevents out-of-bounds access
4. **Formal specs clarify informal requirements**: Make implicit assumptions explicit

Use this as a template for your own case studies!
