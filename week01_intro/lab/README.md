# Lab 1: Bug Finding in Common Algorithms

## Overview

This lab focuses on developing your ability to identify bugs in common algorithms—a critical skill that motivates the need for formal verification. You'll analyze implementations in Java and Python, finding subtle errors that testing might miss but formal methods could catch.

## Learning Objectives

By completing this lab, you will:
- ✓ Develop critical code reading skills
- ✓ Identify common algorithmic errors
- ✓ Understand why bugs persist in well-known algorithms
- ✓ Appreciate the value of formal verification

## Exercises

### Exercise 1: QuickSort Implementation (1 point)

**Task**: Find problems in this Java implementation of the quicksort algorithm.

```java
public class QuickSort {
    public static void quicksort(int[] arr, int low, int high) {
        if (low < high) {
            int pivotIndex = partition(arr, low, high);
            quicksort(arr, low, pivotIndex - 1);
            quicksort(arr, pivotIndex, high);  // ⚠️ Potential issue here
        }
    }

    private static int partition(int[] arr, int low, int high) {
        int pivot = arr[(low + high) / 2];  // ⚠️ Potential overflow
        while (low <= high) {
            while (arr[low] < pivot) {
                low++;
            }
            while (arr[high] > pivot) {
                high--;
            }
            if (low <= high) {
                int temp = arr[low];
                arr[low] = arr[high];
                arr[high] = temp;
                low++;
                high--;
            }
        }
        return low;
    }

    public static void main(String[] args) {
        int[] numbers = {3, 7, 8, 5, 2, 1, 9, 5, 4};
        quicksort(numbers, 0, numbers.length - 1);
    }
}
```

**What to look for**:
- Integer overflow issues
- Off-by-one errors in recursive calls
- Infinite recursion potential
- Array index out of bounds

**Key Issues**:
1. **Integer overflow**: `(low + high) / 2` can overflow for large values
   - **Fix**: Use `low + (high - low) / 2`

2. **Incorrect recursive call**: `quicksort(arr, pivotIndex, high)` should be `quicksort(arr, pivotIndex + 1, high)`
   - **Problem**: Can cause infinite recursion when pivot doesn't move
   - **Impact**: Stack overflow on certain inputs

### Exercise 2: Binary Search Implementation (1 point)

**Task**: Find problems in this Java implementation of binary search.

```java
public class BinarySearch {
    public static int binarySearch(int[] arr, int target) {
        int low = 0, high = arr.length - 1;
        while (low < high) {  // ⚠️ Wrong termination condition
            int mid = (low + high) >>> 1;
            if (arr[mid] == target) {
                return mid;
            } else if (arr[mid] < target) {
                low = mid;  // ⚠️ Should be mid + 1
            } else {
                high = mid - 1;
            }
        }
        return (arr[low] == target) ? low : -1;
    }

    public static void main(String[] args) {
        int[] nums = {1, 3, 5, 7, 9, 11, 13};
        // Test the function
    }
}
```

**What to look for**:
- Loop termination conditions
- Update of search bounds
- Potential infinite loops
- Missing edge cases

**Key Issues**:
1. **Wrong termination condition**: `low < high` should be `low <= high`
   - **Problem**: Misses single-element search ranges
   - **Example**: Array of length 1 will never be searched properly

2. **Incorrect bound update**: `low = mid` should be `low = mid + 1`
   - **Problem**: Can cause infinite loop
   - **Example**: When `arr[mid] < target` and `high = mid`, loop repeats infinitely

3. **Note on `>>>` operator**: 
   - The unsigned right shift prevents overflow (good!)
   - Equivalent to `(low + high) / 2` but handles negative intermediate values

### Exercise 3: Matrix Multiplication Implementation (1 point)

**Task**: Find problems in this Python implementation of matrix multiplication.

```python
def matrix_multiply(A, B):
    m = len(A)
    n = len(A[0])
    p = len(B[0])
    
    if n != len(B):
        raise ValueError("Matrices dimensions are incompatible")
    
    C = [[0] * p] * m  # ⚠️ Shallow copy issue
    
    for i in range(m):
        for j in range(p):
            sum_of_products = 0
            for k in range(n):
                sum_of_products += A[k][j] * B[i][k]  # ⚠️ Wrong indices
            
            C[i][j] = sum_of_products
    
    return C
```

**What to look for**:
- Array initialization issues
- Index ordering in matrix operations
- Shallow vs. deep copy problems
- Mathematical correctness

**Key Issues**:
1. **Shallow copy**: `C = [[0] * p] * m` creates references to the same list
   - **Problem**: All rows point to the same memory
   - **Fix**: Use `C = [[0] * p for _ in range(m)]`
   - **Impact**: Modifying one row affects all rows

2. **Wrong indices**: `A[k][j] * B[i][k]` should be `A[i][k] * B[k][j]`
   - **Problem**: Matrix multiplication formula is incorrect
   - **Correct formula**: C[i][j] = Σ(A[i][k] × B[k][j]) for k = 0 to n-1
   - **Impact**: Completely wrong results

### Exercise 4: Longest Increasing Subsequence (1 point)

**Task**: Find problems in this Python implementation of finding the longest increasing subsequence.

```python
def longest_increasing_subsequence(arr):
    if not arr:
        return 0
    
    n = len(arr)
    dp = [1] * n
    
    for i in range(1, n):
        for j in range(i):
            if arr[j] <= arr[i]:  # ⚠️ Should be strict inequality
                dp[i] = max(dp[i], dp[j] + 1)
    
    return max(dp)

if __name__ == "__main__":
    arr = [3, 10, 2, 1, 20, 4, 10]
    print("Length of LIS:", longest_increasing_subsequence(arr))
```

**What to look for**:
- Definition of "increasing" (strict vs. non-strict)
- Algorithm correctness
- Edge case handling

**Key Issues**:
1. **Wrong comparison**: `arr[j] <= arr[i]` should be `arr[j] < arr[i]`
   - **Problem**: Uses "non-decreasing" instead of "strictly increasing"
   - **Terminology**: 
     - Increasing: each element strictly greater than previous
     - Non-decreasing: allows equal consecutive elements
   - **Example**: For `[1, 2, 2, 3]`, current code counts subsequence of length 4
     - But longest *strictly* increasing subsequence should be 3: `[1, 2, 3]`

## Common Themes

These exercises illustrate common bug patterns:

1. **Integer Overflow**: Easy to miss, hard to test
2. **Off-by-One Errors**: Boundary conditions are tricky
3. **Shallow Copy Issues**: Reference vs. value semantics
4. **Index Confusion**: Easy to swap indices in nested loops
5. **Comparison Operators**: `<` vs. `<=` matters significantly

## Why Formal Methods Help

For each bug found:
- **Testing** might catch it *if* you write the right test case
- **Code review** might catch it *if* the reviewer is careful
- **Formal verification** *will* catch it by mathematically proving correctness

Formal methods can:
- Prove absence of overflow for all inputs
- Verify loop invariants ensure correctness
- Check array bounds automatically
- Validate mathematical properties

## Next Steps

1. Try to fix each bug you identified
2. Write test cases that would expose these bugs
3. Think about how you would formally specify the correct behavior
4. Consider: What invariants should these algorithms maintain?

## Grading Criteria

Each exercise is worth 1 point. Full credit requires:
- Identifying all major bugs
- Explaining why each bug is problematic
- Providing or suggesting a fix
- Understanding the impact on program behavior

## Resources

- [Java Binary Search Bug Story](https://research.google/blog/extra-extra-read-all-about-it-nearly-all-binary-searches-and-mergesorts-are-broken/)
- Course lecture notes on real-world software failures
- Dafny examples showing formal verification of these algorithms

## Tips

- Don't just run the code—analyze it carefully
- Think about edge cases and boundary conditions  
- Consider what could go wrong with extreme inputs
- Ask yourself: "What invariants should this maintain?"
- Remember: If it compiles and runs, it might still be wrong!
