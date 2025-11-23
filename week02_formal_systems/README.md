# Week 02: Formal Systems and Propositional Logic

## 📚 Course Overview

This week establishes the mathematical foundation for formal verification by introducing **formal systems**, **propositional logic**, and **natural deduction**. You'll learn how to eliminate ambiguity through precise formal languages and implement these concepts in Dafny.

## 🎯 Key Learning Objectives

By the end of this week, you will be able to:
1. **Explain** why formal languages are necessary over natural languages
2. **Define** the components of a formal system (syntax, axioms, inference rules)
3. **Construct** proofs using natural deduction rules
4. **Encode** propositional logic in Dafny using algebraic data types
5. **Use** pattern matching and higher-order functions effectively
6. **Write** formal specifications with requires/ensures clauses

## 📖 Curriculum Key Points

### 1. Why Formal Languages?

**The Problem with Natural Languages**:
- Ambiguous: "There exists a number greater than two and there exists a number greater than three"
  - Are these the same number or different?
  - What kind of numbers (integers, reals)?
- Context-dependent and subjective
- No systematic verification possible

**Solution: Formal Languages**:
- Precise, unambiguous syntax and semantics
- Mechanical verification of reasoning
- Computer-processable

### 2. What is a Formal System?

**Definition**: A model of abstract reasoning consisting of three components:

1. **Formal Syntax**:
   - Finite set of symbols
   - Grammar rules to combine symbols into valid strings

2. **Axioms**:
   - Certain strings accepted as valid without proof
   - Starting points for reasoning

3. **Inference Rules**:
   - Rules to derive new valid formulas (theorems) from existing ones

**Key Insight**: 
- **Grammar** determines syntactic validity
- **Inference rules** determine semantic validity (what's provable)

### 3. Propositional Logic as Example

**Alphabet**:
- Propositional variables: p, q, r, ...
- Logical connectives: ¬ (not), ∧ (and), ∨ (or), → (implies)
- Parentheses: (, )

**Grammar (BNF)**:
```
φ ::= atom | ¬φ | (φ ∧ φ) | (φ ∨ φ) | (φ → φ)
```

**Well-formed examples**: `(p ∧ q)`, `((p → q) ∨ r)`, `¬(p ∧ ¬q)`

### 4. Natural Deduction Rules

**And Rules**:
```
Γ ⊢ A    Γ ⊢ B          Γ ⊢ A ∧ B          Γ ⊢ A ∧ B
──────────────── ∧-intro   ─────────── ∧-elim-L   ─────────── ∧-elim-R
   Γ ⊢ A ∧ B                  Γ ⊢ A                  Γ ⊢ B
```

**Implication Rules**:
```
Γ ∪ {A} ⊢ B              Γ ⊢ A → B    Γ ⊢ A
──────────── →-intro      ───────────────────── →-elim (Modus Ponens)
  Γ ⊢ A → B                      Γ ⊢ B
```

**Key Concept**: Proofs are systematic applications of these rules

### 5. Sequents and Proofs

**Sequent Form**: `Γ ⊢ φ`
- Γ: Set of assumptions (axioms)
- φ: Conclusion to prove
- Meaning: "From Γ, we can derive φ"

**Example Proof**: `⊢ (p ∧ q) → (q ∧ p)`
```
    Hyp                  Hyp
(p∧q) ⊢ (p∧q)      (p∧q) ⊢ (p∧q)
──────────────      ──────────────
  (p∧q) ⊢ q            (p∧q) ⊢ p
────────────────────────────────── ∧-intro
        (p∧q) ⊢ (q∧p)
    ─────────────────────── →-intro
      ⊢ ((p∧q) → (q∧p))
```

### 6. Dafny: Implementing Formal Systems

**Encoding Propositional Logic**:
```dafny
datatype Prop =
  | Var(Atom)          // Variables
  | Not(Prop)          // Negation
  | And(Prop, Prop)    // Conjunction
  | Or(Prop, Prop)     // Disjunction
  | Imp(Prop, Prop)    // Implication
```

**Valuations** (truth assignments):
```dafny
function eval(phi: Prop, alpha: Atom -> bool): bool
{
  match phi
    case Var(p) => alpha(p)
    case Not(p) => !eval(p, alpha)
    case And(p, q) => eval(p, alpha) && eval(q, alpha)
    case Or(p, q) => eval(p, alpha) || eval(q, alpha)
    case Imp(p, q) => !eval(p, alpha) || eval(q, alpha)
}
```

### 7. Important Logical Concepts

**Validity (Tautology)**: True under ALL valuations
- Example: `p → p` is valid

**Satisfiability**: True under AT LEAST ONE valuation
- Example: `p ∧ q` is satisfiable

**Equivalence**: Same truth value under ALL valuations
- Example: `p → q ≡ ¬p ∨ q`

### 8. Algebraic Data Types (ADTs)

**Key Features**:
- Define custom types with multiple variants (constructors)
- Natural for tree-like structures
- Perfect for representing expressions

**Examples**:
```dafny
datatype List<T> = Nil | Cons(head: T, tail: List<T>)
datatype Tree<T> = Leaf | Node(value: T, left: Tree<T>, right: Tree<T>)
datatype Option<T> = None | Some(value: T)
```

### 9. Pattern Matching

**Syntax**:
```dafny
function length<T>(xs: List<T>): nat
{
  match xs
    case Nil => 0
    case Cons(head, tail) => 1 + length(tail)
}
```

**Properties**:
- Examines structure of ADT
- Each case handles one constructor
- Must be exhaustive (all cases covered)
- Binds constructor fields to variables

### 10. Specifications in Dafny

**Key Keywords**:
- `requires`: Preconditions (assumptions about inputs)
- `ensures`: Postconditions (guarantees about outputs)
- `invariant`: Loop invariants (maintained throughout loop)
- `decreases`: Termination measure (proves recursion terminates)

**Example**:
```dafny
function factorial(n: nat): nat
  requires n >= 0
  ensures factorial(n) >= 1
  ensures n > 0 ==> factorial(n) >= n
{
  if n == 0 then 1 else n * factorial(n - 1)
}
```

## 🔬 Lab Requirements Analysis

### Lab 2: Digital Circuits in Dafny

**Objective**: Model hardware components using ADTs and verify circuit properties, demonstrating how formal methods apply to hardware design.

**Skills Developed**:
- Modeling compositional structures with ADTs
- Recursive evaluation functions
- Formal specification of hardware behavior
- Understanding correctness beyond software

### Exercise Breakdown

#### Exercise 1: Circuit Data Type (0.5 points)
**Requirements**:
- Define `Input` enumeration (I1, I2, I3, ...)
- Define `Circuit` ADT with:
  - `Input(Input)`: Input pins
  - `Not(Circuit)`: Inverter gate
  - `And(Circuit, Circuit)`: AND gate
  - `Or(Circuit, Circuit)`: OR gate

**Key Learning**: 
- Compositional design: Circuits built from smaller circuits
- Recursive structure enables complex designs
- Type safety ensures only valid circuits

#### Exercise 2: Evaluation Function (0.5 points)
**Requirements**:
```dafny
function eval(c: Circuit, inputs: Input -> bool): bool
```
- Takes circuit and input valuation
- Returns boolean output
- Recursively evaluates sub-circuits
- Applies appropriate gate logic

**Key Learning**: Pattern matching simplifies recursive evaluation

#### Exercise 3: Full Adder Circuit (0.5 points)
**Background**: Full adder adds two bits plus carry-in, producing sum and carry-out

**Given Helpers**:
- `sum_bit_fn(i1, i2)`: Computes XOR (a ⊕ b)
- `carry_bit_fn(i1, i2)`: Computes AND (a ∧ b)

**Task**: Implement full adder using these helpers
```dafny
function full_adder(a, b, cin): (Circuit, Circuit)
  // Returns (sum, carry_out)
```

**Formulas**:
- Sum = (a ⊕ b) ⊕ cin
- Carry = (a ∧ b) ∨ ((a ⊕ b) ∧ cin)

**Key Learning**: 
- Building complex circuits from simple components
- Understanding adder logic is foundational to computation
- Verification ensures correctness for ALL input combinations

### Why This Lab Matters

**Hardware Verification Applications**:
- Modern chip design uses formal methods extensively
- Intel, AMD use formal verification for processors
- Safety-critical systems require verified hardware

**Advantages Over Testing**:
- Testing 2³ = 8 cases for 3 inputs: feasible
- Testing 2³² cases: impossible
- **Formal verification**: Proves correctness for ALL 2³² cases at once!

**Real-World Impact**:
- CPU verification (floating-point units, caches)
- Memory controllers
- Cryptographic hardware
- Communication protocols

## 📂 Directory Structure

```
week02_formal_systems/
├── README.md          # This file - week overview
├── summary.md         # Quick summary
├── notes/
│   └── README.md      # Comprehensive lecture notes
├── lab/
│   └── README.md      # Detailed lab exercise guide
├── dafny/             # Dafny code examples
└── source/            # Original PDF copilot materials
    ├── 2_formal_systems.md
    └── 2_lab.md
```

## 🚀 Getting Started

1. **Study**: Read formal systems concepts in `notes/README.md`
2. **Practice**: Implement circuits in `lab/README.md`
3. **Verify**: Test your circuits with different input valuations
4. **Explore**: Try proving properties like De Morgan's laws

## 🔗 Key Takeaways

- **Formal languages** eliminate ambiguity in specifications
- **Formal systems** = Language + Axioms + Inference Rules
- **Proofs** are systematic applications of inference rules
- **Dafny** enables encoding of formal systems for verification
- **ADTs** naturally represent compositional structures
- **Pattern matching** simplifies recursive definitions
- **Formal methods** apply to hardware as well as software

## 📚 Resources

- [Z3 SMT Solver Guide](https://microsoft.github.io/z3guide/)
- Dafny documentation on algebraic data types
- Digital logic design tutorials

## ➡️ Next Week

Week 03 introduces **operational semantics** for the IMP imperative language. You'll learn how to formally define the meaning of programming language constructs and trace program execution step-by-step.
