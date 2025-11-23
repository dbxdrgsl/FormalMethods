# Week 03: Operational Semantics of IMP - Lecture Notes

## Overview

This week introduces **operational semantics**—a formal way to define the meaning of programming language constructs through execution rules. We'll study IMP, a simple imperative language, and implement its semantics in Dafny to enable formal reasoning about program behavior.

## Key Concepts

### 1. What are Semantics?

**Semantics** specify the precise meaning of language constructs. Three main approaches exist:

1. **Operational Semantics** (our focus):
   - Defines meaning through execution steps or evaluation rules
   - Shows *how* programs execute step-by-step
   - Two styles: small-step (one step at a time) and big-step/natural (evaluate to final result)

2. **Denotational Semantics**:
   - Maps programs to mathematical objects in a semantic domain
   - Shows *what* programs compute as mathematical functions

3. **Axiomatic Semantics** (coming later):
   - Program behavior captured through logical assertions and proof rules
   - Includes Hoare Logic for program verification

### 2. The IMP Language

**IMP** is a minimal imperative programming language that captures essential features:
- Arithmetic and boolean expressions
- Variable assignment
- Sequential composition
- Conditional branching (if-then-else)
- Loops (while)

#### BNF Grammar:
```
n ∈ ℤ                    (integers)
x ∈ Id                   (identifiers)

a ::= n | x | a₁ + a₂ | a₁ × a₂                    (arithmetic expressions)
b ::= true | false | a₁ < a₂ | ¬b | b₁ ∧ b₂      (boolean expressions)
S ::= skip | x := a | S₁; S₂ | if b then S₁ else S₂ | while b do S  (statements)
```

#### Why IMP?
- ✓ Includes fundamental control flow constructs
- ✓ Simple enough for clear formal definitions
- ✓ Expressive enough for non-trivial programs
- ✓ Techniques extend naturally to complex languages

### 3. IMP Syntax in Dafny

#### Identifiers:
```dafny
datatype Id = x | y | z | s | t | u | v | n | m | i | j | g
```

#### Arithmetic Expressions:
```dafny
datatype AExp =
  | Num(int)              // Integer literal
  | Var(Id)               // Variable reference
  | Plus(AExp, AExp)      // Addition
  | Times(AExp, AExp)     // Multiplication
```

**Examples**:
- `5` → `Num(5)`
- `x + 3` → `Plus(Var(x), Num(3))`
- `(x + 5) * y` → `Times(Plus(Var(x), Num(5)), Var(y))`

#### Boolean Expressions:
```dafny
datatype BExp =
  | B(bool)               // Boolean literal
  | Less(AExp, AExp)      // Less than comparison
  | Not(BExp)             // Negation
  | And(BExp, BExp)       // Conjunction
```

**Examples**:
- `true` → `B(true)`
- `x < 5` → `Less(Var(x), Num(5))`
- `x < y && !(z < 0)` → `And(Less(Var(x), Var(y)), Not(Less(Var(z), Num(0))))`

#### Statements:
```dafny
datatype Stmt =
  | Skip                        // No operation
  | Assign(Id, AExp)            // Assignment: x := a
  | Seq(Stmt, Stmt)             // Sequential composition: S₁; S₂
  | If(BExp, Stmt, Stmt)        // Conditional: if b then S₁ else S₂
  | While(BExp, Stmt)           // Loop: while b do S
```

**Examples**:
- `skip` → `Skip`
- `x := 5` → `Assign(x, Num(5))`
- `x := x + 1` → `Assign(x, Plus(Var(x), Num(1)))`
- `x := 5; y := 10` → `Seq(Assign(x, Num(5)), Assign(y, Num(10)))`

### 4. Program States

A **state** is a partial function from variables to values:
```
σ : Id ⇀ ℤ
```

**In Dafny**, states are represented as maps:
```dafny
type State = map<Id, int>
```

**Examples**:
- Empty state: `map[]`
- `σ = {x ↦ 5, y ↦ 10}` → `map[x := 5, y := 10]`
- Update: `σ[x := 7]` creates new state with `x` mapped to `7`

### 5. Configurations

A **configuration** describes program execution state:
```
⟨⋆, σ⟩
```
where:
- `⋆` is the program component (expression or statement)
- `σ` is the current state

**For expressions**: `⟨a, σ⟩ ⇓ n` means "expression `a` in state `σ` evaluates to value `n`"

**For statements**: `⟨S, σ⟩ ⇓ σ'` means "statement `S` in state `σ` produces new state `σ'`"

### 6. Big-Step Semantics for Arithmetic Expressions

Evaluation rules define how expressions compute values:

```
────────────── [Num]        ────────────── [Var]
⟨n, σ⟩ ⇓ n                  ⟨x, σ⟩ ⇓ σ(x)

⟨a₁, σ⟩ ⇓ n₁    ⟨a₂, σ⟩ ⇓ n₂
──────────────────────────────── [Plus]
⟨a₁ + a₂, σ⟩ ⇓ n₁ + n₂

⟨a₁, σ⟩ ⇓ n₁    ⟨a₂, σ⟩ ⇓ n₂
──────────────────────────────── [Times]
⟨a₁ × a₂, σ⟩ ⇓ n₁ × n₂
```

#### In Dafny:
```dafny
function evalAExp(a: AExp, sigma: State): int
  requires forall v :: v in a.vars() ==> v in sigma
{
  match a
    case Num(n) => n
    case Var(x) => sigma[x]
    case Plus(a1, a2) => evalAExp(a1, sigma) + evalAExp(a2, sigma)
    case Times(a1, a2) => evalAExp(a1, sigma) * evalAExp(a2, sigma)
}
```

**Key Point**: The `requires` clause ensures all variables in the expression are defined in the state.

### 7. Big-Step Semantics for Boolean Expressions

```
────────────── [True]       ────────────── [False]
⟨true, σ⟩ ⇓ true            ⟨false, σ⟩ ⇓ false

⟨a₁, σ⟩ ⇓ n₁    ⟨a₂, σ⟩ ⇓ n₂
──────────────────────────────── [Less]
⟨a₁ < a₂, σ⟩ ⇓ (n₁ < n₂)

⟨b, σ⟩ ⇓ v
──────────────── [Not]
⟨¬b, σ⟩ ⇓ ¬v

⟨b₁, σ⟩ ⇓ v₁    ⟨b₂, σ⟩ ⇓ v₂
──────────────────────────────── [And]
⟨b₁ ∧ b₂, σ⟩ ⇓ (v₁ ∧ v₂)
```

#### In Dafny:
```dafny
function evalBExp(b: BExp, sigma: State): bool
  requires forall v :: v in b.vars() ==> v in sigma
{
  match b
    case B(v) => v
    case Less(a1, a2) => evalAExp(a1, sigma) < evalAExp(a2, sigma)
    case Not(b1) => !evalBExp(b1, sigma)
    case And(b1, b2) => evalBExp(b1, sigma) && evalBExp(b2, sigma)
}
```

### 8. Big-Step Semantics for Statements

**The Gas Parameter**: To ensure termination in Dafny, we use a "gas" parameter that limits recursion depth:

```dafny
predicate evalStmt(s: Stmt, sigma: State, sigma': State, gas: nat)
```

#### Skip Rule:
```
──────────────── [Skip]
⟨skip, σ⟩ ⇓ σ
```

```dafny
case Skip => sigma' == sigma && gas > 0
```

#### Assignment Rule:
```
⟨a, σ⟩ ⇓ n
────────────────────── [Assign]
⟨x := a, σ⟩ ⇓ σ[x ↦ n]
```

```dafny
case Assign(x, a) =>
  var v := evalAExp(a, sigma);
  sigma' == sigma[x := v] && gas > 0
```

#### Sequential Composition:
```
⟨S₁, σ⟩ ⇓ σ''    ⟨S₂, σ''⟩ ⇓ σ'
───────────────────────────────── [Seq]
⟨S₁; S₂, σ⟩ ⇓ σ'
```

```dafny
case Seq(s1, s2) =>
  exists sigma'' :: gas > 0 &&
    evalStmt(s1, sigma, sigma'', gas - 1) &&
    evalStmt(s2, sigma'', sigma', gas - 1)
```

#### Conditional (If):
```
⟨b, σ⟩ ⇓ true    ⟨S₁, σ⟩ ⇓ σ'           ⟨b, σ⟩ ⇓ false    ⟨S₂, σ⟩ ⇓ σ'
─────────────────────────────────       ─────────────────────────────────
⟨if b then S₁ else S₂, σ⟩ ⇓ σ'          ⟨if b then S₁ else S₂, σ⟩ ⇓ σ'
        [If-True]                                [If-False]
```

```dafny
case If(b, s1, s2) =>
  var v := evalBExp(b, sigma);
  gas > 0 &&
  if v then evalStmt(s1, sigma, sigma', gas - 1)
  else evalStmt(s2, sigma, sigma', gas - 1)
```

#### While Loop:
```
⟨b, σ⟩ ⇓ false                        ⟨b, σ⟩ ⇓ true    ⟨S, σ⟩ ⇓ σ''    ⟨while b do S, σ''⟩ ⇓ σ'
──────────────────                    ────────────────────────────────────────────────────────
⟨while b do S, σ⟩ ⇓ σ                 ⟨while b do S, σ⟩ ⇓ σ'
    [While-False]                              [While-True]
```

```dafny
case While(b, s) =>
  var v := evalBExp(b, sigma);
  gas > 0 &&
  if !v then sigma' == sigma
  else exists sigma'' ::
    evalStmt(s, sigma, sigma'', gas - 1) &&
    evalStmt(While(b, s), sigma'', sigma', gas - 1)
```

### 9. Working with the Gas Parameter

**Why Gas?**
- Dafny requires proof of termination
- Loops might not terminate
- Gas provides an upper bound on recursion depth

**Choosing Gas Values**:
- `gas = 1`: One statement execution
- `gas = n`: Up to `n` nested executions
- For loops: `gas ≥ number_of_iterations + other_statements`

**Example**: Loop that runs 5 times needs `gas ≥ 10` (5 iterations × 2 recursive calls per iteration)

### 10. Example Program Execution

**Program**: `x := 10; y := x * x`

**Initial State**: `σ = {x ↦ 0, y ↦ 0}`

**Execution Trace**:
```
1. Evaluate Seq(Assign(x, Num(10)), Assign(y, Times(Var(x), Var(x))))
2. First statement: Assign(x, Num(10))
   - Evaluate Num(10) → 10
   - Update state: σ₁ = {x ↦ 10, y ↦ 0}
3. Second statement: Assign(y, Times(Var(x), Var(x)))
   - Evaluate Times(Var(x), Var(x)) in σ₁
   - Var(x) → 10
   - Times(10, 10) → 100
   - Update state: σ₂ = {x ↦ 10, y ↦ 100}
4. Final state: σ' = {x ↦ 10, y ↦ 100}
```

**In Dafny**:
```dafny
lemma executeProgram()
{
  var s1 := Assign(x, Num(10));
  var s2 := Assign(y, Times(Var(x), Var(x)));
  var prog := Seq(s1, s2);
  
  var sigma := map[x := 0, y := 0];
  var sigma' := map[x := 10, y := 100];
  
  assert evalStmt(prog, sigma, sigma', 2);
}
```

### 11. Reasoning About Programs

With operational semantics, we can:
- **Trace execution**: Follow step-by-step evaluation
- **Prove properties**: Show programs produce expected results
- **Find bugs**: Demonstrate incorrect behavior
- **Verify correctness**: Prove program meets specification

**Example Property**: "After `x := x + 1`, the value of `x` increases by 1"
```dafny
lemma incrementCorrect(sigma: State, x: Id)
  requires x in sigma
{
  var s := Assign(x, Plus(Var(x), Num(1)));
  var sigma' := sigma[x := sigma[x] + 1];
  assert evalStmt(s, sigma, sigma', 1);
}
```

### 12. Determinism of IMP

**Theorem**: IMP's operational semantics is **deterministic**—given the same initial state, a program always produces the same final state.

**Proof Sketch**:
- Each evaluation rule is uniquely determined by syntax
- No ambiguity in rule application
- Recursive evaluation follows deterministic rules

This property is crucial for:
- Predictable program behavior
- Reproducible testing
- Formal reasoning

### 13. Equivalence of Programs

Two programs are **semantically equivalent** if they produce the same final state from any initial state:

```
S₁ ≡ S₂  iff  ∀σ, σ'. (⟨S₁, σ⟩ ⇓ σ') ↔ (⟨S₂, σ⟩ ⇓ σ')
```

**Examples**:
- `skip; S ≡ S` (skip is identity for sequencing)
- `if true then S₁ else S₂ ≡ S₁`
- `if false then S₁ else S₂ ≡ S₂`
- `while false do S ≡ skip`

## Learning Objectives

By the end of this week, you should be able to:
1. ✓ Define operational semantics using inference rules
2. ✓ Encode IMP syntax in Dafny using ADTs
3. ✓ Implement evaluation functions for expressions
4. ✓ Implement evaluation predicates for statements
5. ✓ Use the gas parameter correctly
6. ✓ Trace program execution step-by-step
7. ✓ Prove properties about program behavior
8. ✓ Understand determinism and program equivalence

## Key Takeaways

- **Operational semantics** gives precise meaning to programs
- **Big-step semantics** evaluates programs to final results
- **IMP** is simple but captures essential imperative features
- **Dafny encoding** enables mechanical verification
- **Gas parameter** ensures termination in Dafny
- **Formal reasoning** about programs is now possible!

## Why This Matters

Understanding operational semantics is foundational for:
- **Compiler correctness**: Prove compiler preserves semantics
- **Program verification**: Reason about program behavior
- **Language design**: Design languages with clear semantics
- **Debugging**: Understand precise execution model
- **Optimization**: Prove transformations preserve meaning

## Next Steps

1. Complete the lab exercises on IMP evaluation
2. Practice writing lemmas about program properties
3. Experiment with different gas values
4. Try proving program equivalences
5. Prepare for Hoare Logic (axiomatic semantics)

## Further Reading

- Big-step vs. small-step operational semantics
- Denotational semantics of IMP
- Non-deterministic extensions of IMP
- Semantics of real programming languages
