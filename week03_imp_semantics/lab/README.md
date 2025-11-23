# Lab 3: Operational Semantics and Program Evaluation in Dafny

## Overview

This lab provides hands-on practice with operational semantics by working with the IMP language definitions from the lecture notes. You'll write lemmas to prove properties about expression evaluation, statement execution, and program behavior using Dafny's verification capabilities.

## Prerequisites

You must use the Dafny definitions from the lecture notes, including:
- `AExp` - Arithmetic expressions
- `BExp` - Boolean expressions  
- `Stmt` - Statements
- `State` - Program states (maps from identifiers to integers)
- `evalAExp` - Arithmetic expression evaluation function
- `evalBExp` - Boolean expression evaluation function
- `evalStmt` - Statement evaluation predicate

## Learning Objectives

By completing this lab, you will:
- ✓ Understand how operational semantics works in practice
- ✓ Write formal specifications using Dafny lemmas
- ✓ Prove properties about expression evaluation
- ✓ Verify statement execution produces expected states
- ✓ Master the gas parameter for loops and sequences
- ✓ Debug verification failures systematically

## Exercise 1: Arithmetic Expression Evaluation (0.5 points)

**Task**: Write a lemma to assert the result of evaluating `(x + 5) * (y + -3)` in state `σ = {x ↦ 2, y ↦ 5}`.

### Understanding the Problem

**Expression**: `(x + 5) * (y + -3)`

**State**: `σ = {x ↦ 2, y ↦ 5}`

**Manual Evaluation**:
1. Evaluate `x + 5`:
   - `x` in `σ` is `2`
   - `2 + 5 = 7`
2. Evaluate `y + (-3)`:
   - `y` in `σ` is `5`
   - `5 + (-3) = 2`
3. Multiply results: `7 * 2 = 14`

**Expected Result**: `14`

### Solution Template

```dafny
lemma exercise1()
{
  // Define the expression: (x + 5) * (y + -3)
  var expr := Times(
    Plus(Var(x), Num(5)),
    Plus(Var(y), Num(-3))
  );
  
  // Define the state: σ = {x ↦ 2, y ↦ 5}
  var sigma := map[x := 2, y := 5];
  
  // Assert the evaluation result
  assert evalAExp(expr, sigma) == 14;
}
```

### Key Points

- Use `Times`, `Plus`, `Var`, and `Num` constructors
- Build expression inside-out: subexpressions first
- State is a `map<Id, int>`
- `evalAExp` returns the computed value
- Dafny verifies the assertion automatically!

## Exercise 2: Boolean Expression Evaluation (0.5 points)

**Task**: Write a lemma to assert the result of `!(x < 4) && (y < (x + y))` where state is `σ = {x ↦ 5, y ↦ 10}`.

### Understanding the Problem

**Expression**: `!(x < 4) && (y < (x + y))`

**State**: `σ = {x ↦ 5, y ↦ 10}`

**Manual Evaluation**:
1. Evaluate `x < 4`:
   - `x` is `5`, so `5 < 4` is `false`
2. Negate: `!(false)` is `true`
3. Evaluate `x + y`:
   - `5 + 10 = 15`
4. Evaluate `y < (x + y)`:
   - `10 < 15` is `true`
5. Conjunction: `true && true` is `true`

**Expected Result**: `true`

### Solution Template

```dafny
lemma exercise2()
{
  // Define the expression: !(x < 4) && (y < (x + y))
  var expr := And(
    Not(Less(Var(x), Num(4))),
    Less(Var(y), Plus(Var(x), Var(y)))
  );
  
  // Define the state: σ = {x ↦ 5, y ↦ 10}
  var sigma := map[x := 5, y := 10];
  
  // Assert the evaluation result
  assert evalBExp(expr, sigma) == true;
}
```

### Key Points

- Use `And`, `Not`, `Less` constructors
- `Less` takes two arithmetic expressions
- Nested expressions evaluate recursively
- Boolean operations follow standard logic

## Exercise 3: Sequential Assignment (1 point)

**Task**: Prove that executing `x := 10; y := x * x` from initial state `σ = {x ↦ 0, y ↦ 0}` produces final state `σf = {x ↦ 10, y ↦ 100}`.

### Understanding the Problem

**Program**: `x := 10; y := x * x`

**Initial State**: `σ = {x ↦ 0, y ↦ 0}`

**Execution Steps**:
1. Execute `x := 10`:
   - Evaluate `10` → `10`
   - Update state: `σ₁ = {x ↦ 10, y ↦ 0}`
2. Execute `y := x * x` in `σ₁`:
   - Evaluate `x * x`:
     - `x` is `10`
     - `10 * 10 = 100`
   - Update state: `σ₂ = {x ↦ 10, y ↦ 100}`

**Final State**: `σf = {x ↦ 10, y ↦ 100}`

### Understanding Gas

For sequential composition `Seq(s1, s2)`:
- Need `gas > 0` for the `Seq` itself
- Need `gas - 1` for `s1`
- Need `gas - 1` for `s2`

For simple assignments, `gas = 1` suffices per statement.
For `Seq(Assign, Assign)`, we need:
- `gas = 2`: One for each assignment inside the sequence

### Solution Template

```dafny
lemma exercise3()
{
  // Define statements
  var s1 := Assign(x, Num(10));
  var s2 := Assign(y, Times(Var(x), Var(x)));
  var prog := Seq(s1, s2);
  
  // Define states
  var sigma := map[x := 0, y := 0];
  var sigmaF := map[x := 10, y := 100];
  
  // Prove the execution
  assert evalStmt(prog, sigma, sigmaF, 2);
}
```

### Key Points

- `Seq` requires enough gas for both statements
- Second statement sees state produced by first
- Gas must account for all execution steps
- Dafny traces through intermediate states automatically

## Exercise 4: Conditional Branch Selection (1 point)

**Task**: Prove that evaluating `if (x < y) then x := y + 1 else skip` in state `σ = {x ↦ 5, y ↦ 8}` takes the then-branch and produces `σf = {x ↦ 9, y ↦ 8}`.

### Understanding the Problem

**Program**: `if (x < y) then x := y + 1 else skip`

**Initial State**: `σ = {x ↦ 5, y ↦ 8}`

**Execution**:
1. Evaluate condition `x < y`:
   - `5 < 8` is `true`
2. Take then-branch: execute `x := y + 1`
   - Evaluate `y + 1`:
     - `y` is `8`
     - `8 + 1 = 9`
   - Update: `σf = {x ↦ 9, y ↦ 8}`

**Final State**: `σf = {x ↦ 9, y ↦ 8}`

### Gas for Conditionals

The `If` statement requires:
- `gas > 0` for the `If` itself
- `gas - 1` for the chosen branch
- The **gas** equals the gas needed by the chosen branch

For `Assign`, we need `gas = 1`.
For `If(_, Assign, _)`, we need `gas = 2` (1 for If, 1 for Assign).

### Solution Template

```dafny
lemma exercise4()
{
  // Define the conditional statement
  var cond := Less(Var(x), Var(y));
  var thenBranch := Assign(x, Plus(Var(y), Num(1)));
  var elseBranch := Skip;
  var ifStmt := If(cond, thenBranch, elseBranch);
  
  // Define states
  var sigma := map[x := 5, y := 8];
  var sigmaF := map[x := 9, y := 8];
  
  // Prove execution
  assert evalStmt(ifStmt, sigma, sigmaF, 2);
}
```

### Key Points

- Condition must evaluate to determine branch
- Gas must be sufficient for chosen branch
- Only one branch executes
- Final state reflects executed branch

## Exercise 5: Loop Termination (1 point)

**Task**: Prove that the loop `while (0 < x) do x := x + 1` terminates immediately (zero iterations) in state `σ = {x ↦ 0}`.

### Understanding the Problem

**Program**: `while (0 < x) do x := x + 1`

**Initial State**: `σ = {x ↦ 0}`

**Execution**:
1. Evaluate condition `0 < x`:
   - `x` is `0`
   - `0 < 0` is `false`
2. Condition false → exit loop immediately
3. State unchanged: `σf = {x ↦ 0}`

**Iterations**: 0 (loop body never executes)

### Gas for While Loops

For a loop that doesn't execute:
- `gas = 1`: Just enough to check condition and exit
- No recursion happens

General formula:
- **gas ≥ 2 × iterations + 1**
- For 0 iterations: `gas = 1`
- For 1 iteration: `gas ≥ 3`
- For n iterations: `gas ≥ 2n + 1`

### Solution Template

```dafny
lemma exercise5()
{
  // Define the while loop
  var cond := Less(Num(0), Var(x));
  var body := Assign(x, Plus(Var(x), Num(1)));
  var loop := While(cond, body);
  
  // Define state (unchanged)
  var sigma := map[x := 0];
  var sigmaF := map[x := 0];
  
  // Prove immediate termination
  assert evalStmt(loop, sigma, sigmaF, 1);
}
```

### Key Points

- False condition → immediate termination
- State remains unchanged
- Minimal gas (1) suffices
- No intermediate states created

## Exercise 6: Complex Program with Helper Assertions (1 point)

**Task**: Complete the lemma with helper assertions to guide Dafny's verification.

### Given Code

```dafny
lemma ex6()
{
  var assign1 := Assign(x, Num(15));
  var assign2 := Assign(y, Num(15));
  var assign3 := Assign(z, Var(y));
  var assign4 := Assign(z, Var(x));
  var cond := Less(Var(x), Var(y));
  var iff := If(cond, assign3, assign4);
  var seq1 := Seq(assign1, assign2);
  var seq2 := Seq(seq1, iff);

  var sigma := map[x := 0, y := 0];
  var sigma1 := sigma[x := 15];
  var sigma2 := sigma1[y := 15];
  var sigma3 := sigma2[z := 15];

  // Fill in helper assertions here
  
  assert evalStmt(seq2, sigma, sigma3, 3);
}
```

### Understanding the Program

**Program Structure**: `(x := 15; y := 15); if (x < y) then z := y else z := x`

**Execution Trace**:
1. `x := 15`: `σ → σ₁ = {x ↦ 15, y ↦ 0}`
2. `y := 15`: `σ₁ → σ₂ = {x ↦ 15, y ↦ 15}`
3. Evaluate `x < y`: `15 < 15` is `false`
4. Take else-branch: `z := x`
5. `z := 15`: `σ₂ → σ₃ = {x ↦ 15, y ↦ 15, z ↦ 15}`

### The Problem

The given final state is `sigma3 := sigma2[z := 15]`, but:
- `sigma2` doesn't have `z` yet
- We're setting `z := 15` (value of `x` in `σ₂`)

The code seems correct, but we need to help Dafny see the intermediate steps.

### Solution with Helper Assertions

```dafny
lemma ex6()
{
  var assign1 := Assign(x, Num(15));
  var assign2 := Assign(y, Num(15));
  var assign3 := Assign(z, Var(y));
  var assign4 := Assign(z, Var(x));
  var cond := Less(Var(x), Var(y));
  var iff := If(cond, assign3, assign4);
  var seq1 := Seq(assign1, assign2);
  var seq2 := Seq(seq1, iff);

  var sigma := map[x := 0, y := 0];
  var sigma1 := sigma[x := 15];
  var sigma2 := sigma1[y := 15];
  var sigma3 := sigma2[z := 15];

  // Helper assertions to guide Dafny
  
  // Step 1: First sequence (x := 15; y := 15) produces sigma2
  assert evalStmt(seq1, sigma, sigma2, 2);
  
  // Step 2: Condition evaluates to false (15 < 15 is false)
  assert !evalBExp(cond, sigma2);
  
  // Step 3: Else branch (assign4: z := x) executes
  // In sigma2, x is 15, so z becomes 15
  assert evalAExp(Var(x), sigma2) == 15;
  assert evalStmt(assign4, sigma2, sigma3, 1);
  
  // Step 4: The conditional statement produces sigma3
  assert evalStmt(iff, sigma2, sigma3, 2);
  
  // Main assertion should now verify
  assert evalStmt(seq2, sigma, sigma3, 3);
}
```

### Why Helper Assertions Help

1. **Break down complex proof**: Show intermediate results explicitly
2. **Guide SMT solver**: Provide stepping stones for reasoning
3. **Document execution**: Make trace visible for readers
4. **Debug failures**: Identify exactly where verification fails

### Key Points

- Condition `15 < 15` is false → else-branch taken
- Else-branch: `z := x` where `x` is `15`
- Gas calculation: `Seq(Seq(2), If(2))` needs `gas = 3`
- Helper assertions build proof incrementally

## Common Pitfalls and Solutions

### Pitfall 1: Insufficient Gas

**Problem**: `gas` too small for program complexity

**Symptom**: Dafny can't prove `evalStmt` holds

**Solution**: Calculate required gas:
- Simple statement (Skip, Assign): `gas = 1`
- Sequence of n statements: `gas = n`
- Loop with k iterations: `gas ≥ 2k + 1`
- Nested structures: add gas requirements

### Pitfall 2: Wrong Final State

**Problem**: Specified final state doesn't match execution

**Symptom**: Assertion fails even with correct gas

**Solution**: 
- Trace execution manually
- Check each variable's final value
- Verify arithmetic evaluation
- Use helper assertions to find discrepancy

### Pitfall 3: Missing Variables in State

**Problem**: State doesn't include all referenced variables

**Symptom**: Precondition failure in `evalAExp` or `evalBExp`

**Solution**: Ensure initial state includes all variables mentioned in program

### Pitfall 4: Incorrect Expression Encoding

**Problem**: Dafny expression doesn't match intended program

**Symptom**: Evaluation produces unexpected result

**Solution**: 
- Build expression systematically
- Test subexpressions separately
- Check operator precedence
- Verify variable names

## Testing Strategy

### Approach 1: Unit Testing Subexpressions

```dafny
lemma testSubexpression()
{
  var expr := Plus(Num(2), Num(3));
  var sigma := map[];
  assert evalAExp(expr, sigma) == 5;
}
```

### Approach 2: Incremental Program Building

```dafny
lemma testIncremental()
{
  var s1 := Assign(x, Num(10));
  var sigma0 := map[x := 0];
  var sigma1 := map[x := 10];
  
  // Test first statement alone
  assert evalStmt(s1, sigma0, sigma1, 1);
  
  var s2 := Assign(y, Var(x));
  var sigma2 := map[x := 10, y := 10];
  
  // Test second statement from sigma1
  assert evalStmt(s2, sigma1, sigma2, 1);
  
  // Test full sequence
  var prog := Seq(s1, s2);
  assert evalStmt(prog, sigma0, sigma2, 2);
}
```

### Approach 3: Boundary Conditions

Test edge cases:
- Empty state
- Zero values
- Negative numbers
- Loops with 0, 1, multiple iterations

## Grading Criteria

- **Exercise 1** (0.5 pts): Correct arithmetic evaluation
- **Exercise 2** (0.5 pts): Correct boolean evaluation
- **Exercise 3** (1 pt): Sequential composition with state updates
- **Exercise 4** (1 pt): Conditional with correct branch
- **Exercise 5** (1 pt): Loop termination proof
- **Exercise 6** (1 pt): Complex program with helper assertions

Full credit requires:
- Correct Dafny syntax
- Successful verification (no errors)
- Appropriate gas values
- Clear code structure

## Tips for Success

1. **Read lecture notes carefully**: Understand evaluation rules
2. **Start simple**: Test small parts before combining
3. **Calculate gas systematically**: Count execution steps
4. **Use helper assertions liberally**: Break complex proofs
5. **Trace execution manually**: Verify expected behavior
6. **Check error messages**: Dafny points to verification failures
7. **Ask questions**: Instructor can clarify semantic rules

## Advanced Topics (Optional)

If you finish early, explore:

1. **Program Equivalence**: Prove two programs produce same results
2. **Loop Invariants**: Express properties maintained by loops
3. **Termination Proofs**: Show loops always terminate
4. **Error Detection**: Prove programs fail under certain conditions
5. **Optimization Verification**: Show optimized code equivalent to original

## Conclusion

This lab solidifies your understanding of operational semantics by:
- Translating abstract rules to concrete Dafny code
- Proving program properties mechanically
- Building confidence in formal verification

These skills are foundational for:
- Hoare Logic (next week)
- Program verification tools
- Compiler correctness proofs
- Language design and implementation

**Remember**: Every assertion you prove is a theorem about program behavior!
