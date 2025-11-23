// Lab 5 — Arrays, specs, and searches (Dafny 2.2)

// Snapshot helper: turn array into a sequence
function A(a: array<int>): seq<int>
  reads a
{
  a[..]
}

// Nondecreasing sortedness
predicate sorted(a: array<int>)
  reads a
{
  forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
}

/******** 1) Min value and its index ********/
method ArrayMinIndex(a: array<int>) returns (min: int, minIndex: int)
  requires a.Length > 0
  ensures 0 <= minIndex < a.Length
  ensures min == a[minIndex]
  ensures forall j :: 0 <= j < a.Length ==> min <= a[j]
{
  min := a[0];
  minIndex := 0;
  var i := 1;
  while i < a.Length
    invariant 1 <= i <= a.Length
    invariant 0 <= minIndex < i
    invariant min == a[minIndex]
    invariant forall j :: 0 <= j < i ==> min <= a[j]
    decreases a.Length - i
  {
    if a[i] < min {
      min := a[i];
      minIndex := i;
    }
    i := i + 1;
  }
}

/******** 2) Range = max - min (nonnegative) ********/
method Range(a: array<int>) returns (delta: int)
  requires a.Length > 0
  ensures delta >= 0
{
  var mn := a[0];
  var mx := a[0];
  var i := 1;
  while i < a.Length
    invariant 1 <= i <= a.Length
    invariant forall j :: 0 <= j < i ==> mn <= a[j] <= mx
    decreases a.Length - i
  {
    if a[i] < mn { mn := a[i]; }
    if a[i] > mx { mx := a[i]; }
    i := i + 1;
  }
  delta := mx - mn;
}

/******** 3) Linear search ********/
method Find(a: array<int>, key: int) returns (index: int)
  ensures (index == -1 ==> forall j :: 0 <= j < a.Length ==> a[j] != key)
  ensures (index != -1 ==> 0 <= index < a.Length && a[index] == key)
{
  index := 0;
  while index < a.Length
    invariant 0 <= index <= a.Length
    invariant forall j :: 0 <= j < index ==> a[j] != key
    decreases a.Length - index
  {
    if a[index] == key { return; }
    index := index + 1;
  }
  index := -1;
}

/******** 4) Count occurrences ********/
method Count(a: array<int>, v: int) returns (cnt: int)
  ensures 0 <= cnt <= a.Length
{
  cnt := 0;
  var i := 0;
  while i < a.Length
    invariant 0 <= i <= a.Length
    invariant 0 <= cnt <= i
    decreases a.Length - i
  {
    if a[i] == v { cnt := cnt + 1; }
    i := i + 1;
  }
}

/******** 5) Last index of value (or -1) ********/
method LastIndexOf(a: array<int>, v: int) returns (idx: int)
  ensures -1 <= idx < a.Length
  ensures (idx == -1 ==> forall j :: 0 <= j < a.Length ==> a[j] != v)
  ensures (idx != -1 ==> a[idx] == v && forall j :: idx < j < a.Length ==> a[j] != v)
{
  idx := -1;
  var i := 0;
  while i < a.Length
    invariant 0 <= i <= a.Length
    invariant -1 <= idx < i
    invariant (idx == -1 ==> forall j :: 0 <= j < i ==> a[j] != v)
    invariant (idx != -1 ==> a[idx] == v && forall j :: idx < j < i ==> a[j] != v)
    decreases a.Length - i
  {
    if a[i] == v { idx := i; }
    i := i + 1;
  }
}

/******** 6) Binary search on sorted array ********/
method BinarySearch(a: array<int>, key: int) returns (index: int)
  requires sorted(a)
  ensures (index == -1 ==> forall j :: 0 <= j < a.Length ==> a[j] != key)
  ensures (index != -1 ==> 0 <= index < a.Length && a[index] == key)
{
  var low := 0;
  var high := a.Length; // search in [low, high)
  while low < high
    invariant 0 <= low <= high <= a.Length
    invariant forall j :: 0 <= j < low ==> a[j] < key
    invariant forall j :: high <= j < a.Length ==> a[j] > key
    decreases high - low
  {
    var mid := (low + high) / 2;
    if a[mid] < key {
      low := mid + 1;
    } else if a[mid] > key {
      high := mid;
    } else {
      return mid;
    }
  }
  index := -1;
}

/******** 7) First occurrence of key in sorted array (lower_bound) ********/
method FirstOccurrence(a: array<int>, key: int) returns (index: int)
  requires sorted(a)
  ensures (index == -1 ==> forall j :: 0 <= j < a.Length ==> a[j] != key)
  ensures (index != -1 ==> 0 <= index < a.Length && a[index] == key &&
                         forall j :: 0 <= j < index ==> a[j] < key)
{
  var low := 0;
  var high := a.Length; // maintain: [0, low) < key  and  [high, n) >= key
  while low < high
    invariant 0 <= low <= high <= a.Length
    invariant forall j :: 0 <= j < low ==> a[j] < key
    invariant forall j :: high <= j < a.Length ==> a[j] >= key
    decreases high - low
  {
    var mid := (low + high) / 2;
    if a[mid] >= key {
      high := mid;
    } else {
      low := mid + 1;
    }
  }
  if low < a.Length && a[low] == key {
    index := low;
  } else {
    index := -1;
  }
}
