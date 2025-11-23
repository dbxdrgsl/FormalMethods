# Week 02: Formal Systems - Lecture Notes

## Overview

This week introduces formal systems and their foundational role in mathematics and computer science. You'll learn how formal languages eliminate ambiguity, understand the structure of proofs, and see how these concepts are implemented in Dafny.

## Key Concepts

### 1. Why Formal Languages?

Natural languages like English are **ambiguous**:
- "There exists a number such that it's greater than two and there exists a number such that it's greater than three."
  - Are these the same number or different numbers?
  - Are we talking about positive numbers only?
  - Are negative numbers allowed?

**Computers require precision!** Formal languages provide:
- Unambiguous syntax and semantics
- Systematic verification of reasoning
- Mechanical checking of proofs

### 2. What is a Language?

A language consists of three components:
1. **Finite set of symbols**: {A, B, C, ...}
2. **Rules to combine symbols**: ABBA, CAB, etc.
3. **Grammar**: Defines valid string construction

**Examples**:
- English: "Hi, how are you?" (valid) vs. "hi, how" (invalid)
- Logic: ∀x. x ∈ ℕ ∧ x ≥ 0 (valid)

**Key Insight**: Different languages encode different ways of thinking
- English: "ninety-six" (90 + 6)
- French: "quatre-vingt-seize" (4 × 20 + 16)
- Different grammars = different construction rules

### 3. From Languages to Formal Systems

**Languages vs. Formal Systems**:
- Languages allow us to transfer messages
- Formal systems allow us to transfer abstract ideas

**Why formal systems?**
- Lie at the heart of mathematics
- Enable reasoning about **form** rather than **content**
- Focus on structure, not meaning
- Essential for proving software correctness

### 4. What is a Formal System?

**Definition**: A model of abstract reasoning consisting of:

1. **Formal Syntax**:
   - Finite set of symbols
   - Grammar to combine symbols into valid strings

2. **Axioms**:
   - Certain strings accepted as valid without proof
   - Starting point for reasoning

3. **Inference Rules**:
   - Used to construct new valid formulas (theorems)
   - Rules for deriving new truths from existing ones

**Key Idea**: 
- Grammar determines which strings are **syntactically valid**
- Inference rules determine which strings are **semantically valid** (theorems)

### 5. Example: Propositional Logic

#### Alphabet (Symbols):
- Propositional atoms: A = {p, q, r, ...}
- Logical connectives: ¬, ∧, ∨, →
- Parentheses: (, )

#### Grammar (BNF):
```
φ ::= a | ¬φ | (φ ∧ φ) | (φ ∨ φ) | (φ → φ)
```
where a ∈ A

#### Examples:
**Well-formed**:
- (p ∧ q)
- ((p → q) ∨ r)
- ¬(p ∧ ¬q)

**NOT well-formed**:
- p ∧ q (missing parentheses)
- p ∧ ∧q (syntax error)
- → p (incomplete expression)
- pq (missing operator)

### 6. Inference Rules

**Definition**: Rules that allow deriving new theorems from existing ones.

**General Form**:
```
Premise₁ ... Premiseₙ
────────────────────── RuleName
    Conclusion
```

**Notation**: We use ⊢ (turnstile) to denote "is provable"
- ⊢ φ means "φ is a theorem"
- Γ ⊢ φ means "φ is provable from assumptions Γ"

**Example - Modus Ponens**:
```
Γ ⊢ P    Γ ⊢ P → Q
───────────────────── MP
      Γ ⊢ Q
```
If we know P is provable and P → Q is provable, we can prove Q.

### 7. Sequents

In Propositional Logic, premises and conclusions have the form:
```
Γ ⊢ φ
```
where:
- Γ is a set of formulas (axioms/assumptions)
- φ is a formula (conclusion)

**Correctness**: Γ ⊢ φ is correct if whenever all formulas in Γ are true, then φ is also true.

**Examples**:
- If Γ = {p}, then Γ ⊢ p (trivial: from p we conclude p)
- ∅ ⊢ φ means "φ holds without assumptions"
- {p, r} ⊢ p ∧ r (intuitive: if both hold, conjunction holds)

### 8. Natural Deduction Rules

#### And Rules (∧):
```
Γ ⊢ A    Γ ⊢ B                Γ ⊢ A ∧ B              Γ ⊢ A ∧ B
────────────────── ∧-intro    ─────────── ∧-elim-L   ─────────── ∧-elim-R
   Γ ⊢ A ∧ B                     Γ ⊢ A                  Γ ⊢ B
```

#### Or Rules (∨):
```
    Γ ⊢ A                          Γ ⊢ B
───────────── ∨-intro-L        ───────────── ∨-intro-R
  Γ ⊢ A ∨ B                      Γ ⊢ A ∨ B

Γ ⊢ A ∨ B    Γ ∪ {A} ⊢ C    Γ ∪ {B} ⊢ C
──────────────────────────────────────── ∨-elim
                 Γ ⊢ C
```

#### Implication Rules (→):
```
              ·                      Γ ⊢ A → B    Γ ⊢ A
─────────────────── Hyp              ───────────────────── →-elim (MP)
Γ ∪ {A} ⊢ A                                Γ ⊢ B

Γ ∪ {A} ⊢ B
────────────── →-intro (Deduction)
  Γ ⊢ A → B
```

#### Negation Rules (¬):
```
Γ ∪ {A} ⊢ ⊥                    Γ ⊢ A    Γ ⊢ ¬A
─────────────── ¬-intro        ────────────────── ¬-elim
   Γ ⊢ ¬A                            Γ ⊢ ⊥

  Γ ⊢ ¬¬A                        Γ ⊢ ⊥
─────────── ¬¬-elim            ──────── ⊥-elim
   Γ ⊢ A                         Γ ⊢ φ
```

### 9. Example Proof: ⊢ (p ∧ q) → (q ∧ p)

**Goal**: Prove that ⊢ (p ∧ q) → (q ∧ p)

**Proof (Sequential)**:
1. (p ∧ q) ⊢ (p ∧ q)           [Hyp]
2. (p ∧ q) ⊢ p                  [∧-elim-L, 1]
3. (p ∧ q) ⊢ q                  [∧-elim-R, 1]
4. (p ∧ q) ⊢ (q ∧ p)           [∧-intro, 3, 2]
5. ⊢ (p ∧ q) → (q ∧ p)         [→-intro, 1, 4]

**Proof Tree**:
```
        ·                              ·
─────────────── Hyp         ─────────────── Hyp
(p∧q) ⊢ (p∧q)               (p∧q) ⊢ (p∧q)
──────────────── ∧-elim-R   ──────────────── ∧-elim-L
  (p∧q) ⊢ q                   (p∧q) ⊢ p
──────────────────────────────────────────── ∧-intro
            (p∧q) ⊢ (q∧p)
         ────────────────────────── →-intro
           ⊢ ((p∧q) → (q∧p))
```

### 10. Dafny: Implementing Formal Systems

#### Encoding Propositional Logic:
```dafny
datatype Atom = P | Q | R

datatype Prop =
  | Var(Atom)          // Propositional variables
  | Not(Prop)          // Negation
  | And(Prop, Prop)    // Conjunction
  | Or(Prop, Prop)     // Disjunction
  | Imp(Prop, Prop)    // Implication
```

**Examples**:
- (p ∧ q) → `And(Var(P), Var(Q))`
- (¬p → q) → `Imp(Not(Var(P)), Var(Q))`
- ((p ∨ q) ∧ r) → `And(Or(Var(P), Var(Q)), Var(R))`

#### Valuations:
A **valuation** assigns truth values to atoms:
```
α : Atom → {true, false}
```

**Example in Dafny**:
```dafny
function alpha1(a: Atom): bool
{
  match a
    case P => true
    case Q => false
    case R => true
}
```

#### Semantics (Evaluation):
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

### 11. Important Logical Concepts in Dafny

#### Validity (Tautology):
A formula φ is **valid** if true under all valuations:
```
|= φ  iff  ∀α: JφKα = true
```

**Example**: p → p is valid
```dafny
lemma testValidity()
  ensures forall alpha ::
    eval(Imp(Var(P), Var(P)), alpha) == true
{}
```

#### Satisfiability:
A formula φ is **satisfiable** if true under at least one valuation:
```
φ is satisfiable  iff  ∃α: JφKα = true
```

**Example**: p ∧ q is satisfiable
```dafny
method testSat()
  ensures exists alpha ::
    eval(And(Var(P), Var(Q)), alpha) == true
{
  var alpha1 := (a: Atom) => true;
  assert eval(And(Var(P), Var(Q)), alpha1) == true;
}
```

#### Logical Equivalence:
Two formulas φ and ψ are **equivalent** if they have the same truth value under all valuations:
```
φ ≡ ψ  iff  ∀α: JφKα = JψKα
```

**Example**: p → q ≡ ¬p ∨ q
```dafny
method testEquiv()
  ensures forall alpha ::
    eval(Imp(Var(P), Var(Q)), alpha) ==
    eval(Or(Not(Var(P)), Var(Q)), alpha)
{}
```

### 12. Algebraic Data Types (ADTs)

ADTs define custom types with multiple variants (constructors).

**Basic Syntax**:
```dafny
datatype TypeName<T> =
  | Constructor1(field1: Type1)
  | Constructor2(field2: Type2, field3: Type3)
```

**Example: Lists**:
```dafny
datatype List<T> =
  | Nil
  | Cons(head: T, tail: List<T>)

// Creating lists
const emptyList: List<int> := Nil
const someList: List<int> := Cons(1, Cons(2, Cons(3, Nil)))
```

**Example: Binary Trees**:
```dafny
datatype Tree<T> =
  | Leaf
  | Node(value: T, left: Tree<T>, right: Tree<T>)

const myTree :=
  Node(5,
    Node(3, Leaf, Leaf),
    Node(7, Leaf, Leaf)
  )
```

### 13. Pattern Matching

Pattern matching deconstructs ADTs:
```dafny
function length<T>(xs: List<T>): nat
{
  match xs
    case Nil => 0
    case Cons(head, tail) => 1 + length(tail)
}
```

**Key Features**:
- `match` examines the structure
- Each `case` handles one constructor
- Binds constructor fields to variables
- Must be exhaustive (all cases covered)

### 14. Higher-Order Functions

Functions can take other functions as parameters:
```dafny
function mymap<A, B>(f: A -> B, xs: List<A>): List<B>
{
  match xs
    case Nil => Nil
    case Cons(head, tail) =>
      Cons(f(head), mymap(f, tail))
}

function increment(x: int): int { x + 1 }

method testMap() returns (res: List<int>)
  ensures res == Cons(2, Cons(3, Cons(4, Nil)))
{
  var list := Cons(1, Cons(2, Cons(3, Nil)));
  res := mymap(increment, list);
}
```

### 15. Specifications in Dafny

Dafny's superpower: formal specifications!

```dafny
function factorial(n: nat): nat
  requires n >= 0
  ensures factorial(n) >= 1
  ensures n > 0 ==> factorial(n) >= n
{
  if n == 0 then 1
  else n * factorial(n - 1)
}
```

**Key Keywords**:
- `requires`: Preconditions (assumptions about inputs)
- `ensures`: Postconditions (guarantees about outputs)
- `invariant`: Loop invariants (properties maintained by loops)
- `decreases`: Termination measure (proves recursion terminates)

### 16. Why This Matters

**Formal Languages Shape Software Development**:
- Enable precise specification of program behavior
- Allow mechanical verification of correctness
- Eliminate ambiguity in requirements
- Provide tools for automated reasoning

**Computers Can Operate on Formal Languages**:
- Tools like Dafny enable automated verification
- SMT solvers (like Z3) can prove complex properties
- Formal systems provide the mathematical foundation

## Learning Objectives

By the end of this week, you should be able to:
1. ✓ Explain the need for formal languages over natural languages
2. ✓ Define the components of a formal system
3. ✓ Construct proofs using natural deduction rules
4. ✓ Encode propositional logic in Dafny
5. ✓ Use pattern matching and ADTs effectively
6. ✓ Write specifications with requires/ensures
7. ✓ Understand validity, satisfiability, and equivalence

## Summary

- **Formal languages** eliminate ambiguity
- **Formal systems** = Language + Axioms + Inference Rules
- **Proofs** are systematic applications of inference rules
- **Dafny** enables formal systems for verification
- **Automated verification** uses SMT solving under the hood
- Sometimes we help the prover (e.g., providing witnesses for existential statements)

## Further Reading

- [Z3 Propositional Logic Guide](https://microsoft.github.io/z3guide/docs/logic/propositional-logic)
- Dafny documentation on algebraic data types
- Natural deduction tutorial resources

## Next Steps

1. Review the lab exercises on digital circuits
2. Practice encoding formal systems in Dafny
3. Experiment with pattern matching and ADTs
4. Write specifications for simple functions
