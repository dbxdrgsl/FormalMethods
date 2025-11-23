// Lab06.dfy â Binary Search on a Sorted Array

predicate isSorted(a: array<int>)
  reads a
{
  forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
}

method BinarySearch(arr: array<int>, target: int) returns (result: int)
  requires arr != null
  requires isSorted(arr)
  ensures  0 <= result < arr.Length ==> arr[result] == target
  ensures  result == -1 ==> forall k :: 0 <= k < arr.Length ==> arr[k] != target
  ensures  (exists k :: 0 <= k < arr.Length && arr[k] == target)
           ==> 0 <= result < arr.Length && arr[result] == target
{
  var low := 0;
  var high := arr.Length - 1;

  // Invariants follow the âwindow + exclusionsâ pattern
  while low <= high
    invariant 0 <= low <= high + 1 <= arr.Length
    invariant forall k :: 0 <= k < low ==> arr[k] < target
    invariant forall k :: high < k < arr.Length ==> arr[k] > target
    decreases high - low + 1
  {
    // mid computed in an overflow-safe style; Dafny ints are unbounded,
    // but this form mirrors best practice
    var mid := low + (high - low) / 2;

    if arr[mid] < target {
      low := mid + 1;
    } else if arr[mid] > target {
      high := mid - 1;
    } else {
      result := mid;
      return;
    }
  }

  // Not found
  result := -1;
}

// Optional tiny smoke test to keep the file runnable (no prints needed)
method Main()
{
  var a := new int[5];
  a[0], a[1], a[2], a[3], a[4] := 1, 3, 5, 7, 9;
  assert isSorted(a);
  var i := BinarySearch(a, 7);
  assert i == 3;
  var j := BinarySearch(a, 2);
  assert j == -1;
}


