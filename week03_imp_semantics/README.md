# Week 03: Operational Semantics of IMP

## 📚 Course Overview

This week introduces **operational semantics**—a formal method for defining the precise meaning of programming language constructs through execution rules. You'll study the IMP imperative language and implement its semantics in Dafny.

## 🎯 Key Learning Objectives

1. **Define** operational semantics using inference rules
2. **Encode** IMP syntax in Dafny using ADTs
3. **Implement** evaluation functions for expressions and statements
4. **Use** the gas parameter correctly for termination
5. **Trace** program execution step-by-step
6. **Prove** properties about program behavior

## 📖 Curriculum Key Points

### 1. Semantic Approaches

**Three Main Approaches**:
- **Operational**: Defines meaning through execution steps (our focus)
- **Denotational**: Maps programs to mathematical objects
- **Axiomatic**: Captures behavior through logical assertions (Hoare Logic)

**Big-Step Semantics**: Evaluates programs directly to final results

### 2. The IMP Language

**Minimal imperative language with**:
- Arithmetic expressions: `n | x | a₁ + a₂ | a₁ × a₂`
- Boolean expressions: `true | false | a₁ < a₂ | ¬b | b₁ ∧ b₂`
- Statements: `skip | x := a | S₁; S₂ | if b then S₁ else S₂ | while b do S`

**Why IMP?**
- Simple enough for clear formal definitions
- Expressive enough for non-trivial programs
- Captures essential imperative features
- Techniques extend to complex languages

### 3. Program States

**State**: Partial function from variables to values
```
σ : Id ⇀ ℤ
```

**In Dafny**: `type State = map<Id, int>`

**Configuration**: `⟨program_component, state⟩`

### 4. Big-Step Evaluation Rules

**For Expressions**: `⟨a, σ⟩ ⇓ n` (expression a in state σ evaluates to n)

**For Statements**: `⟨S, σ⟩ ⇓ σ'` (statement S transforms state σ to σ')

**Assignment Rule**:
```
⟨a, σ⟩ ⇓ n
────────────────────
⟨x := a, σ⟩ ⇓ σ[x ↦ n]
```

**While Loop Rule**:
```
⟨b, σ⟩ ⇓ false
──────────────────    (exit immediately)
⟨while b do S, σ⟩ ⇓ σ

⟨b, σ⟩ ⇓ true    ⟨S, σ⟩ ⇓ σ''    ⟨while b do S, σ''⟩ ⇓ σ'
────────────────────────────────────────────────────────────  (iterate)
⟨while b do S, σ⟩ ⇓ σ'
```

### 5. The Gas Parameter

**Purpose**: Ensures termination in Dafny
- Dafny requires proof of termination
- Loops might not terminate
- Gas provides upper bound on recursion depth

**Usage**:
- `gas = 1`: One statement execution
- `gas = n`: Up to n nested executions
- For loops: `gas ≥ iterations + overhead`

### 6. Key Properties

**Determinism**: IMP semantics is deterministic—same initial state always produces same final state

**Equivalence**: Two programs are equivalent if they produce same final state from any initial state

## 🔬 Lab Requirements Analysis

### Lab 3: IMP Evaluation in Dafny

**Objective**: Practice operational semantics by proving properties about expression evaluation and program execution.

### Exercise Breakdown

#### Exercise 1: Arithmetic Evaluation (0.5 points)
**Task**: Assert result of `(x + 5) * (y + -3)` in state `{x ↦ 2, y ↦ 5}`

**Manual Calculation**:
- x + 5 = 2 + 5 = 7
- y + (-3) = 5 - 3 = 2
- 7 * 2 = 14

**Key Learning**: Build expressions using constructors, verify evaluation

#### Exercise 2: Boolean Evaluation (0.5 points)
**Task**: Assert result of `!(x < 4) && (y < (x + y))` where `{x ↦ 5, y ↦ 10}`

**Manual Calculation**:
- x < 4 = 5 < 4 = false
- !(false) = true
- x + y = 15
- y < 15 = 10 < 15 = true
- true && true = true

**Key Learning**: Compose boolean operations, understand evaluation order

#### Exercise 3: Sequential Assignment (1 point)
**Task**: Prove `x := 10; y := x * x` produces `{x ↦ 10, y ↦ 100}`

**Execution**:
1. x := 10 → σ₁ = {x ↦ 10, y ↦ 0}
2. y := x * x in σ₁ → σ₂ = {x ↦ 10, y ↦ 100}

**Gas**: Need gas = 2 for sequence

**Key Learning**: Sequential composition, intermediate states

#### Exercise 4: Conditional Execution (1 point)
**Task**: Prove `if (x < y) then x := y + 1 else skip` takes then-branch

**Analysis**:
- Condition: 5 < 8 = true
- Execute: x := 8 + 1 = 9
- Final: {x ↦ 9, y ↦ 8}

**Gas**: Need gas = 2 (1 for if, 1 for assignment)

**Key Learning**: Branch selection, gas for chosen path

#### Exercise 5: Loop Termination (1 point)
**Task**: Prove `while (0 < x) do x := x + 1` terminates immediately when x = 0

**Analysis**:
- Condition: 0 < 0 = false
- Exits without executing body
- State unchanged

**Gas**: Need gas = 1 (just check condition)

**Key Learning**: Zero-iteration loops, immediate termination

#### Exercise 6: Complex Program (1 point)
**Task**: Add helper assertions to guide Dafny verification

**Program**: `(x := 15; y := 15); if (x < y) then z := y else z := x`

**Helper Assertions**:
- After first sequence: intermediate state
- Condition evaluation: false (15 < 15)
- Else branch executes
- Final state reasoning

**Key Learning**: Breaking down complex proofs, guiding SMT solver

### Common Patterns

**Gas Calculation**:
- Simple statement: 1
- Sequence of n: n
- Loop with k iterations: ≥ 2k + 1
- Nested structures: sum of parts

**Debugging**:
- Add assertions inside loops
- Check intermediate states
- Verify gas is sufficient
- Test subexpressions separately

## 📂 Directory Structure

```
week03_imp_semantics/
├── README.md          # This file
├── notes/README.md    # Detailed semantics
├── lab/README.md      # Exercise guide
├── dafny/             # Examples
└── source/            # Original materials
    ├── 3_notes.md
    ├── 3_slides.md
    └── 3_lab.md
```

## 🔗 Key Takeaways

- **Operational semantics** gives precise meaning to programs
- **Big-step semantics** evaluates to final results
- **IMP** captures essential imperative features
- **Dafny encoding** enables mechanical verification
- **Gas parameter** ensures termination
- **Formal reasoning** about programs is now possible!

## ➡️ Next Week

Week 04 introduces **Hoare Logic**, the axiomatic semantics approach for program verification with preconditions, postconditions, and loop invariants.
