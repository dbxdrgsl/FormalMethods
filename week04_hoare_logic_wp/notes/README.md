# Week 04: Hoare Logic and Weakest Preconditions - Lecture Notes

## Overview

This week introduces **Hoare Logic**, a formal system for reasoning about program correctness through logical assertions. You'll learn how to specify program behavior using preconditions and postconditions, and master the **Weakest Precondition (WP)** calculus for systematic program verification.

## Key Concepts

### 1. What is Deductive Program Verification?

**Deductive Program Verification** uses mathematical logic to prove program correctness for ALL possible inputs, not just specific test cases.

**Three Essential Components**:
1. **Formal Specifications**: Express what a program should do using logical formulas
2. **Formal Semantics**: Precise mathematical model of program execution  
3. **Proof System**: Logical rules to prove programs satisfy specifications

**Advantages over Testing**:
- ✅ **Correctness Guarantees**: Mathematical proof for all inputs
- ✅ **Safety-Critical Systems**: Essential where failures are catastrophic
- ✅ **Early Bug Detection**: Find errors before deployment
- ✅ **Documentation**: Specifications serve as formal documentation

### 2. Historical Background: Floyd-Hoare Logic

**Developed by**:
- Robert W. Floyd (1967): Flowchart verification
- C.A.R. Hoare (1969): Axiomatic basis for computer programming

**Impact**: Foundation for modern program verification tools including Dafny, Why3, and VeriFast.

### 3. Hoare Triples

The fundamental unit of Hoare Logic:

```
{P} S {Q}
```

**Meaning**: "If precondition P holds before executing statement S, then postcondition Q will hold after execution (if S terminates)."

**Components**:
- **P**: Precondition (assertion about initial state)
- **S**: Statement or program
- **Q**: Postcondition (assertion about final state)

**Example**:
```
{x = 5} x := x + 1 {x = 6}
```
"If x equals 5 before the assignment, then x will equal 6 after."

### 4. Partial vs. Total Correctness

#### Partial Correctness: {P} S {Q}
- **IF** S terminates **AND** P holds before execution
- **THEN** Q holds after execution
- Does NOT guarantee termination

#### Total Correctness: [P] S [Q]
- P holds before execution **IMPLIES** S terminates **AND** Q holds after
- Guarantees both correctness and termination

**Example**:
```
{x ≥ 0} while (x > 0) do x := x - 1 {x = 0}  // Partial correctness
[x ≥ 0] while (x > 0) do x := x - 1 [x = 0]  // Total correctness
```

### 5. Understanding Hoare Triples: Special Cases

**Always True Postcondition**:
```
{true} S {true}
```
Says nothing useful—true before and after any statement.

**Never Satisfiable Precondition**:
```
{false} S {Q}
```
Vacuously true (never executes with false precondition).

**Tautological Triple**:
```
{x > 0} skip {x > 0}
```
Trivially true—skip doesn't change state.

### 6. Hoare Logic Proof Rules

#### Assignment Rule (Most Important!)
```
─────────────────────── [Assign]
{P[E/x]} x := E {P}
```

**Meaning**: To establish P after assigning E to x, we need P with x replaced by E beforehand.

**Example**:
```
Goal: {?} x := x + 1 {x > 5}
Apply rule: {(x + 1) > 5} x := x + 1 {x > 5}
Simplify: {x > 4} x := x + 1 {x > 5}
```

**Key Insight**: Work **backwards** from postcondition to find precondition!

#### Skip Rule
```
──────────────── [Skip]
{P} skip {P}
```
Skip doesn't change state, so precondition equals postcondition.

#### Sequence Rule
```
{P} S₁ {Q}    {Q} S₂ {R}
────────────────────────── [Seq]
{P} S₁; S₂ {R}
```

**Strategy**: Find intermediate assertion Q that:
- Is guaranteed by S₁ starting from P
- Is sufficient for S₂ to establish R

#### Conditional Rule
```
{P ∧ b} S₁ {Q}    {P ∧ ¬b} S₂ {Q}
──────────────────────────────────── [If]
{P} if b then S₁ else S₂ {Q}
```

**Strategy**: Prove both branches lead to Q:
- Then-branch: Assume P and condition b
- Else-branch: Assume P and negation ¬b

#### While Loop Rule
```
{I ∧ b} S {I}
───────────────────────────── [While]
{I} while b do S {I ∧ ¬b}
```

**Components**:
- **I**: Loop invariant (true before, during, and after loop)
- **b**: Loop condition
- **S**: Loop body

**Strategy**:
1. Find invariant I that:
   - Holds before loop starts
   - Is maintained by loop body
   - Combined with ¬b, implies postcondition

#### Rule of Consequence (Strengthening/Weakening)
```
P' → P    {P} S {Q}    Q → Q'
───────────────────────────────── [Consequence]
{P'} S {Q'}
```

**Use Cases**:
- **Strengthen precondition**: P' is stronger (more restrictive) than P
- **Weaken postcondition**: Q' is weaker (less restrictive) than Q

**Example**:
```
{x > 10} → {x > 5}    {x > 5} x := x + 1 {x > 6}    {x > 6} → {x > 0}
─────────────────────────────────────────────────────────────────────
{x > 10} x := x + 1 {x > 0}
```

### 7. Weakest Precondition (WP) Calculus

**Definition**: WP(S, Q) is the **weakest** (most general) condition that, if true before S executes, guarantees Q holds after (assuming termination).

**Properties**:
1. **Necessity**: If {P} S {Q}, then P → WP(S, Q)
2. **Sufficiency**: {WP(S, Q)} S {Q}
3. **Weakest**: For any P where {P} S {Q}, we have P → WP(S, Q)

#### WP Rules for Each Statement

**Assignment**:
```
WP(x := E, Q) = Q[E/x]
```
Replace x with E in Q.

**Skip**:
```
WP(skip, Q) = Q
```

**Sequence**:
```
WP(S₁; S₂, Q) = WP(S₁, WP(S₂, Q))
```
Work backwards: WP of S₂ first, then WP of S₁.

**Conditional**:
```
WP(if b then S₁ else S₂, Q) = (b → WP(S₁, Q)) ∧ (¬b → WP(S₂, Q))
```
Or equivalently:
```
= (b ∧ WP(S₁, Q)) ∨ (¬b ∧ WP(S₂, Q))
```

**While Loop**:
```
WP(while b do S, Q) = I
```
where I is a loop invariant such that:
- I ∧ ¬b → Q (when loop exits, invariant + negated condition implies postcondition)
- I ∧ b → WP(S, I) (loop body preserves invariant)

### 8. Example: Array Maximum

**Problem**: Find maximum value in array.

**Specification**:
```dafny
method FindMax(a: array<int>) returns (max: int)
  requires a.Length > 0
  ensures forall i :: 0 <= i < a.Length ==> max >= a[i]
  ensures exists i :: 0 <= i < a.Length && max == a[i]
```

**Precondition**: Array is non-empty
**Postconditions**:
1. max is greater than or equal to all elements
2. max actually appears in the array

**Implementation with Invariants**:
```dafny
{
  max := a[0];
  var i := 1;
  
  while i < a.Length
    invariant 1 <= i <= a.Length
    invariant forall j :: 0 <= j < i ==> max >= a[j]
    invariant exists j :: 0 <= j < i && max == a[j]
  {
    if a[i] > max {
      max := a[i];
    }
    i := i + 1;
  }
}
```

**Loop Invariants Explained**:
1. **i bounds**: i is always between 1 and array length
2. **max property**: max is ≥ all elements seen so far [0..i)
3. **max existence**: max equals some element in [0..i)

### 9. Finding Loop Invariants

**Strategies**:

1. **Start with Postcondition**: What must be true when loop exits?
2. **Generalize**: Replace constants with loop variable
3. **Add Loop Bounds**: Ensure loop variable stays in valid range
4. **Check Preservation**: Verify invariant maintained by loop body
5. **Verify Postcondition**: Invariant + ¬condition → postcondition

**Example Template**:
```
Postcondition: sum = a[0] + ... + a[n-1]
Generalize: sum = a[0] + ... + a[i-1]
Add bounds: 0 <= i <= n
Invariant: 0 <= i <= n ∧ sum = Σ(a[j] for j in 0..i-1)
```

### 10. Verification Workflow

**Steps**:
1. **Specify**: Write preconditions and postconditions
2. **Implement**: Write the program
3. **Annotate**: Add loop invariants
4. **Verify**: Use tool (Dafny) to check correctness
5. **Debug**: If verification fails:
   - Check invariant is strong enough
   - Check invariant is actually maintained
   - Check postcondition follows from invariant

### 11. Common Pitfalls

**Invariant Too Weak**:
- Doesn't imply postcondition
- Solution: Strengthen by adding conjuncts

**Invariant Too Strong**:
- Not maintained by loop body
- Solution: Weaken by removing restrictive conditions

**Missing Bounds**:
- Invariant doesn't constrain loop variable
- Solution: Add bounds like `0 <= i <= n`

**Off-by-One Errors**:
- Invariant uses wrong range
- Solution: Carefully check loop bounds

### 12. Dafny and Hoare Logic

**How Dafny Uses Hoare Logic**:
1. Translates Dafny code to logical formulas (verification conditions)
2. Uses WP calculus internally to generate conditions
3. Passes formulas to Z3 SMT solver
4. Reports verification success or counterexamples

**Advantages of Tool-Assisted Verification**:
- ✅ Automated proof search
- ✅ Counterexample generation
- ✅ Integration with IDEs
- ✅ Real-time feedback

**Dafny Syntax**:
```dafny
method MethodName(params) returns (results)
  requires precondition
  ensures postcondition
{
  // body
  while condition
    invariant loop_invariant
  {
    // loop body
  }
}
```

## Learning Objectives

By the end of this week, you should be able to:
1. ✓ Understand and use Hoare triples
2. ✓ Apply Hoare Logic proof rules
3. ✓ Calculate weakest preconditions
4. ✓ Find and verify loop invariants
5. ✓ Write formal specifications in Dafny
6. ✓ Verify programs using Dafny
7. ✓ Debug verification failures

## Summary

- **Hoare Logic** provides formal system for program correctness
- **Hoare Triples** {P} S {Q} express specifications
- **Proof Rules** allow systematic verification
- **WP Calculus** automates precondition calculation
- **Loop Invariants** are key to verifying loops
- **Dafny** automates verification using these principles

## Why This Matters

**Real-World Applications**:
- Safety-critical systems (aerospace, medical, automotive)
- Security-sensitive code (cryptography, authentication)
- Compiler correctness
- Operating system kernels
- Smart contracts

**Advantages**:
- Prove correctness for ALL inputs
- Find bugs before deployment
- Document intended behavior formally
- Enable safe refactoring

## Next Steps

1. Study the lab exercises on Dafny verification
2. Practice finding loop invariants
3. Experiment with Dafny's verification feedback
4. Explore weakest precondition calculation
5. Prepare for more advanced topics (arrays, loops)

## Further Reading

- Original papers by Floyd and Hoare
- Dafny tutorial and documentation
- "The Science of Programming" by David Gries
- Modern verification tool documentation (Why3, VeriFast)
