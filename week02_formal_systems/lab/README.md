# Lab 2: Digital Circuits in Dafny

## Overview

In this lab, you'll use Dafny to model and verify properties of digital circuits. This exercise demonstrates how formal methods apply to hardware design, using algebraic data types to represent circuits and formal verification to prove their correctness.

Digital circuits are the foundation of all computing systems. They're built from simple logic gates that perform basic operations on binary signals (0 or 1, or equivalently, false or true). By combining these gates, we can build complex computational systems.

## Learning Objectives

By completing this lab, you will:
- ✓ Model hardware components using algebraic data types
- ✓ Define evaluation functions for compositional structures
- ✓ Verify circuit properties using Dafny specifications
- ✓ Understand how formal methods apply to hardware design
- ✓ Practice working with recursive data structures

## Background: Digital Logic

### Basic Logic Gates

**NOT Gate** (Inverter):
```
Input  │ Output
───────┼────────
  0    │   1
  1    │   0
```

**AND Gate**:
```
A  B  │ Output
──────┼────────
0  0  │   0
0  1  │   0
1  0  │   0
1  1  │   1
```

**OR Gate**:
```
A  B  │ Output
──────┼────────
0  0  │   0
0  1  │   1
1  0  │   1
1  1  │   1
```

### Example Circuit

A simple circuit that computes `(A AND B) OR (NOT C)`:
```
A ──┐
    ├─ AND ──┐
B ──┘        │
             ├─ OR ── Output
C ── NOT ────┘
```

## Exercise 1: Define Circuit Data Type (0.5 points)

**Task**: Define an algebraic datatype `Circuit` in Dafny that represents digital circuits.

### Requirements

Your datatype should include:
1. **Input pins** - A separate enumeration type for input identifiers
2. **NOT gate** - Single input, inverts the signal
3. **AND gate** - Two inputs, outputs true only if both are true
4. **OR gate** - Two inputs, outputs true if at least one is true

### Suggested Structure

```dafny
// Define input pins as an enumeration
datatype Input = I1 | I2 | I3 | I4 | I5
// Add more inputs as needed

// Define the Circuit algebraic data type
datatype Circuit =
  | Input(Input)              // Input pin
  | Not(Circuit)              // NOT gate
  | And(Circuit, Circuit)     // AND gate
  | Or(Circuit, Circuit)      // OR gate
```

### Key Insights

- **Compositional Design**: Circuits are built by composing smaller circuits
- **Recursive Structure**: A circuit can contain other circuits as components
- **Type Safety**: The type system ensures only valid circuits can be constructed
- **Algebraic Data Types**: Perfect for representing tree-like structures

### Examples

Once defined, you can construct circuits:
```dafny
// Simple NOT gate on input I1
const notCircuit := Not(Input(I1))

// AND gate combining two inputs
const andCircuit := And(Input(I1), Input(I2))

// Complex: (A AND B) OR (NOT C)
const complexCircuit :=
  Or(
    And(Input(I1), Input(I2)),
    Not(Input(I3))
  )
```

## Exercise 2: Implement Evaluation Function (0.5 points)

**Task**: Define a function `eval` that evaluates a circuit given specific input values.

### Function Signature

```dafny
function eval(c: Circuit, inputs: Input -> bool): bool
{
  // Your implementation here
}
```

### Requirements

The function should:
- Take a circuit `c` and an input valuation function `inputs`
- Return the boolean output of the circuit
- Recursively evaluate sub-circuits
- Apply the appropriate logic gate operation at each level

### Implementation Hints

Use pattern matching to handle each circuit variant:
```dafny
function eval(c: Circuit, inputs: Input -> bool): bool
{
  match c
    case Input(pin) => inputs(pin)
    case Not(subcircuit) => !eval(subcircuit, inputs)
    case And(c1, c2) => eval(c1, inputs) && eval(c2, inputs)
    case Or(c1, c2) => eval(c1, inputs) || eval(c2, inputs)
}
```

### Testing Your Evaluation Function

Create test cases to verify correctness:
```dafny
method testEval()
{
  // Define input values
  var inputs := (i: Input) =>
    match i
      case I1 => true
      case I2 => false
      case I3 => true
      case _ => false;
  
  // Test NOT gate: NOT(true) = false
  var notCircuit := Not(Input(I1));
  assert eval(notCircuit, inputs) == false;
  
  // Test AND gate: true AND false = false
  var andCircuit := And(Input(I1), Input(I2));
  assert eval(andCircuit, inputs) == false;
  
  // Test OR gate: true OR false = true
  var orCircuit := Or(Input(I1), Input(I2));
  assert eval(orCircuit, inputs) == true;
}
```

## Exercise 3: Full Adder Circuit (0.5 points)

**Task**: Implement a full adder using the provided helper functions.

### Background: Binary Addition

A **full adder** adds two bits plus a carry-in, producing a sum bit and a carry-out:

```
Inputs: A, B, Carry-in
Outputs: Sum, Carry-out

Example: 1 + 1 + 1 = 11₂ (sum=1, carry=1)
```

**Truth Table**:
```
A  B  Cin │ Sum  Cout
──────────┼───────────
0  0   0  │  0    0
0  0   1  │  1    0
0  1   0  │  1    0
0  1   1  │  0    1
1  0   0  │  1    0
1  0   1  │  0    1
1  1   0  │  0    1
1  1   1  │  1    1
```

### Given Helper Functions

```dafny
// Computes sum bit: A XOR B = (A OR B) AND NOT(A AND B)
function sum_bit_fn(i1: Input, i2: Input): Circuit
{
  And(
    Or(Input(i1), Input(i2)),
    Not(And(Input(i1), Input(i2)))
  )
}

// Computes carry bit: A AND B
function carry_bit_fn(i1: Input, i2: Input): Circuit
{
  And(Input(i1), Input(i2))
}
```

### Your Task

Complete the full adder function:
```dafny
function full_adder(a: Input, b: Input, cin: Input): (Circuit, Circuit)
{
  // Returns (sum, carry_out)
  // 
  // Hint: 
  // 1. sum = (a XOR b) XOR cin
  // 2. carry_out = (a AND b) OR ((a XOR b) AND cin)
  //
  // You need to construct these using the provided helper functions
  // and the basic circuit constructors (And, Or, Not, Input)
  
  var sum := ???;  // Implement sum bit
  var carry := ???;  // Implement carry bit
  
  (sum, carry)
}
```

### Solution Approach

**Sum bit**: `sum = (a XOR b) XOR cin`
- First XOR: Use `sum_bit_fn(a, b)` to get `a XOR b`
- Second XOR: You need to XOR the result with `cin`
- Since we don't have a direct XOR constructor, use the pattern from `sum_bit_fn`

**Carry bit**: `carry = (a AND b) OR ((a XOR b) AND cin)`
- First part: Use `carry_bit_fn(a, b)` to get `a AND b`
- Second part: Get `(a XOR b)` using `sum_bit_fn(a, b)`, then AND with `cin`
- Combine with OR

### Testing Your Full Adder

```dafny
method testFullAdder()
{
  // Test case: 1 + 1 + 1 = 11₂ (sum=1, carry=1)
  var inputs := (i: Input) =>
    match i
      case I1 => true   // A = 1
      case I2 => true   // B = 1
      case I3 => true   // Cin = 1
      case _ => false;
  
  var (sum, carry) := full_adder(I1, I2, I3);
  
  assert eval(sum, inputs) == true;   // Sum bit = 1
  assert eval(carry, inputs) == true; // Carry bit = 1
}
```

## Exercise 4: Circuit Properties and Verification (Bonus)

**Task**: Prove properties about your circuits using Dafny specifications.

### Example Properties

**Commutativity of AND**:
```dafny
lemma andCommutative(a: Input, b: Input)
  ensures forall inputs ::
    eval(And(Input(a), Input(b)), inputs) ==
    eval(And(Input(b), Input(a)), inputs)
{}
```

**De Morgan's Law**:
```dafny
lemma deMorgansAnd(a: Input, b: Input)
  ensures forall inputs ::
    eval(Not(And(Input(a), Input(b))), inputs) ==
    eval(Or(Not(Input(a)), Not(Input(b))), inputs)
{}
```

**Identity Property**:
```dafny
lemma andIdentity(a: Input)
  ensures forall inputs ::
    eval(And(Input(a), Input(a)), inputs) ==
    eval(Input(a), inputs)
{}
```

Try proving these properties! Dafny should verify them automatically.

## Common Patterns and Tips

### 1. XOR Implementation
Since XOR isn't a basic gate, implement it as:
```
A XOR B = (A OR B) AND NOT(A AND B)
```

### 2. Building Complex Circuits
Break down complex circuits into smaller, testable components:
```dafny
// Build incrementally
const xor_ab := sum_bit_fn(I1, I2);
const xor_result_cin := ...;  // XOR with carry-in
const sum := xor_result_cin;
```

### 3. Debugging Circuits
Create specific test cases:
```dafny
method debugCircuit()
{
  var allFalse := (i: Input) => false;
  var allTrue := (i: Input) => true;
  
  // Test with extreme cases first
  assert eval(myCircuit, allFalse) == ...;
  assert eval(myCircuit, allTrue) == ...;
}
```

## Why This Matters

### Hardware Verification

Modern hardware design uses formal methods extensively:
- **Chip Design**: Intel, AMD use formal verification for processors
- **Safety-Critical Systems**: Aircraft, medical devices, automotive
- **Correctness Guarantees**: Prove circuits work for ALL input combinations

### Advantages Over Testing

- **Exhaustive Coverage**: Testing 2³ = 8 cases for 3 inputs is easy
- **Scaling Issues**: Testing 2³² cases is impossible
- **Formal Verification**: Proves correctness for ALL 2³² cases at once

### Real-World Applications

- CPU verification (floating-point units, caches)
- Memory controllers
- Cryptographic hardware
- Communication protocols

## Grading Criteria

- **Exercise 1** (0.5 points): Correct Circuit data type definition
- **Exercise 2** (0.5 points): Working eval function
- **Exercise 3** (0.5 points): Correct full adder implementation
- **Bonus**: Additional circuit properties and proofs

Full credit requires:
- Syntactically correct Dafny code
- Code that verifies without errors
- Correct logical implementation
- Appropriate test cases

## Resources

- Week 2 lecture notes on formal systems and ADTs
- Dafny documentation on algebraic data types
- Pattern matching examples from propositional logic encoding
- Digital logic tutorials online

## Tips for Success

1. **Start Simple**: Get the basic types working first
2. **Test Incrementally**: Verify each gate type separately
3. **Use Assertions**: Add assertions to document expected behavior
4. **Think Recursively**: Circuit evaluation is naturally recursive
5. **Visualize**: Draw your circuits on paper first
6. **Read Error Messages**: Dafny's error messages are informative

## Extension Ideas

If you finish early, try:
- Implement NAND and NOR gates (universal gates)
- Build a 4-bit ripple carry adder
- Implement a multiplexer (MUX)
- Create a half adder (simpler than full adder)
- Prove equivalence of different circuit implementations

## Conclusion

This lab demonstrates how formal methods apply beyond software:
- **Hardware design** benefits from verification
- **Algebraic data types** model compositional structures naturally
- **Pattern matching** simplifies recursive evaluation
- **Formal proofs** provide absolute correctness guarantees

The techniques you learn here apply to:
- Compiler design (AST manipulation)
- Network protocols (message composition)
- Configuration management
- Any domain with compositional structures!
