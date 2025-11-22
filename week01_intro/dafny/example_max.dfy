// Example: Simple verified function in Dafny
// This is a basic example demonstrating Dafny verification

method Max(a: int, b: int) returns (m: int)
  ensures m >= a && m >= b
  ensures m == a || m == b
{
  if a > b {
    m := a;
  } else {
    m := b;
  }
}

// Test method
method TestMax()
{
  var result := Max(5, 10);
  assert result == 10;
  
  result := Max(15, 3);
  assert result == 15;
}
