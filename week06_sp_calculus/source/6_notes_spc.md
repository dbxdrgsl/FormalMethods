                        Strongest Postcondition Calculus
                                        – lecture notes –


Contents
1 Introduction                                                                                      3

2 Review of Hoare Logic and Floyd’s Approach                                                        3
  2.1 Hoare’s Assignment Rule . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .         3
  2.2 Floyd’s Assignment Rule . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .       3
  2.3 Comparison with Hoare’s Rule . . . . . . . . . . . . . . . . . . . . . . . . . . . .          4

3 From Floyd’s Rule to Strongest Postconditions                                                     4
  3.1 Motivation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      4
  3.2 Relationship to Weakest Preconditions . . . . . . . . . . . . . . . . . . . . . . . .         4
  3.3 IMP Language - reminder . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .         5

4 Strongest Postcondition Calculus                                                                  5
  4.1 Assignment . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      5
  4.2 Sequential Composition . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .        6
  4.3 Skip . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    6
  4.4 Conditional Statement . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .       6
  4.5 While Loop . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      7

5 Summary of Strongest Postcondition Rules                                                          8

6 Properties of Strongest Postconditions                                                            8
  6.1 Main Theorems . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .       8
  6.2 Relationship to Weakest Preconditions . . . . . . . . . . . . . . . . . . . . . . . .         9
  6.3 Comparison: SP vs. WP . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .         9

7 Strongest Postconditions and Symbolic Execution                                               9
  7.1 Connection to Symbolic Execution . . . . . . . . . . . . . . . . . . . . . . . . . . 9
  7.2 Symbolic Execution Example . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 9
  7.3 Key Concepts in Symbolic Execution . . . . . . . . . . . . . . . . . . . . . . . . . 10
  7.4 Formal Connection . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 10
  7.5 Desired Properties . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 11

8 Practical Challenges and Applications                                                            11
  8.1 Challenges in Symbolic Execution . . . . . . . . . . . . . . . . . . . . . . . . . . .       11
  8.2 Mitigation Strategies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    11
  8.3 Applications . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   11

9 Tools Based on Symbolic Execution                                                                12

10 Summary and Conclusions                                                                        12
   10.1 Limitations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 13


                                                 1
11 Further Reading       13




                     2
    The content of this document is not claimed to be original or to be published as original
research. It is meant to serve as a learning resource for students.


1     Introduction
These notes provide an introduction to strongest postcondition calculus, a fundamental tech-
nique in program verification that complements the weakest precondition approach. While
weakest precondition calculus works backward from a desired postcondition, strongest postcon-
dition calculus works forward from a given precondition to compute what can be guaranteed
about the program state after execution.
    The concept of strongest postconditions is closely related to Robert W. Floyd’s 1967 work
on ”Assigning Meanings to Programs,” which precedes C. A. R. Hoare’s more widely known
formalization of program correctness in 1969. Floyd’s approach to the assignment rule naturally
leads to the notion of strongest postconditions.


2     Review of Hoare Logic and Floyd’s Approach
2.1    Hoare’s Assignment Rule
In standard Hoare logic, the assignment rule is:
                                               ·
                                    ⊢ {Q[e/x]} x := e {Q}
   This rule works backward : given a desired postcondition Q, we compute the precondition
by substituting the expression e for variable x in Q.

2.2    Floyd’s Assignment Rule
Floyd proposed an alternative formulation that works forward :
                                              ·
                           ⊢ {P } x := e {∃v.(x = e[v/x]) ∧ P [v/x]}
    In this rule:
    • v is a fresh variable representing the old value of x before the assignment

    • e[v/x] is the expression e with v substituted for x

    • P [v/x] is the precondition P with v substituted for x
    The existentially quantified postcondition captures both:
    1. The new value of x (namely, x = e[v/x])

    2. The fact that the precondition P held for the old value v
This is exactly the strongest postcondition that can hold after the execution of the assignment
because it is almost the same as the precondition, except that the variable x is different.
Example 2.1. Consider the Hoare triple:

                                   ⊢ {s = 0} s := s + i {?}

    Using Floyd’s rule, the postcondition is:

                               ∃v.(s = (s + i)[v/s]) ∧ (s = 0)[v/s]

                                                 3
    After applying the substitutions:

                                        ∃v.(s = v + i) ∧ (v = 0)

    This can be simplified by substituting 0 for v and eliminating the quantifier:

                                           s=0+i≡s=i

2.3    Comparison with Hoare’s Rule
Let us verify that both approaches yield consistent results.

Example 2.2 (Continued). Using Hoare’s rule with postcondition Q ≡ s = 0 + i:

                                Precondition = Q[s + i/s]
                                               = (s = 0 + i)[s + i/s]
                                               =s+i=0+i
                                               ≡s=0

   This matches our original precondition, confirming that s = i is indeed the strongest post-
condition we can derive.


3     From Floyd’s Rule to Strongest Postconditions
3.1    Motivation
While Floyd discussed related notions in his 1967 paper (specifically, ”strongest verifiable con-
sequents”), the concept of strongest postconditions provides a systematic way to reason about
programs in the forward direction.

Definition 3.1 (Strongest Postcondition Intuition). For a statement S and precondition P ,
the strongest postcondition sp(S, P ) is a logical formula such that:

    1. If P holds before executing S, then sp(S, P ) holds after execution

    2. sp(S, P ) is the strongest such formula: any other valid postcondition Q for {P }S{Q} is
       implied by sp(S, P )

Theorem 3.2. A Hoare triple {P }S{Q} is valid if and only if:

                                             sp(S, P ) → Q

   This property reduces the verification problem to checking a logical implication, similar to
how weakest precondition calculus works.

3.2    Relationship to Weakest Preconditions
Recall that for weakest preconditions:

                               {P }S{Q} is valid iff P → wp(S, Q)

    The two approaches are dual:

    • Weakest Precondition: Works backward from Q to find the weakest P

    • Strongest Postcondition: Works forward from P to find the strongest Q

                                                   4
3.3    IMP Language - reminder
We recall here the syntax of IMP:

Arithmetic Expressions:

                        AExp ::= Var | Int | AExp + AExp | AExp/AExp

Boolean Expressions:

             BExp ::= true | false | AExp < AExp | not BExp | BExp and BExp

Statements:

                           Stmt ::= Var := AExp
                                     | if BExp then Stmt else Stmt
                                     | while BExpφ do Stmt end
                                     | Stmt; Stmt
                                     | skip


4     Strongest Postcondition Calculus
We now present the complete strongest postcondition calculus for the IMP language.

4.1    Assignment
Definition 4.1 (SP for Assignment).

                             sp(x := e, P ) = ∃v.(x = e[v/x]) ∧ P [v/x]

    The fresh variable v represents the old value of x, and the postcondition states that:

    1. x has the new value obtained by evaluating e with the old value v

    2. The precondition P held when x had value v

Example 4.2. Consider verifying {s = 0} s := s + i{s ≥ i}.
  Step 1: Compute sp(s := s + i, s = 0):

                  sp(s := s + i, s = 0) = ∃v.(s = (s + i)[v/s]) ∧ (s = 0)[v/s]
                                           = ∃v.(s = v + i) ∧ (v = 0)
                                           ≡s=0+i
                                           ≡s=i

    Step 2: Check whether sp(s := s + i, s = 0) → s ≥ i:

                                           s=i→s≥i

    Since this implication is valid, the Hoare triple is valid.




                                                  5
4.2   Sequential Composition
Definition 4.3 (SP for Sequences).

                                 sp(S1 ; S2 , P ) = sp(S2 , sp(S1 , P ))

   This definition is natural: we first compute the strongest postcondition after S1 , then use
that as the precondition for computing the strongest postcondition of S2 .

Remark 4.4. Compare this with the weakest precondition for sequences:

                                wp(S1 ; S2 , Q) = wp(S1 , wp(S2 , Q))

   The order of composition is reversed: wp works backward (first S2 , then S1 ), while sp works
forward (first S1 , then S2 ).

Example 4.5. Compute sp(i := i + 1; s := s + i, i = 0 ∧ s = 0).
  Step 1: Compute sp(i := i + 1, i = 0 ∧ s = 0):

                          sp(i := i + 1, i = 0 ∧ s = 0)
                           = ∃v.(i = (i + 1)[v/i]) ∧ (i = 0 ∧ s = 0)[v/i]
                           = ∃v.(i = v + 1) ∧ (v = 0 ∧ s = 0)

   Step 2: Compute sp(s := s + i, ∃v.(i = v + 1) ∧ (v = 0 ∧ s = 0)):

               sp(s := s + i, ∃v.(i = v + 1) ∧ (v = 0 ∧ s = 0))
               = ∃v ′ .(s = (s + i)[v ′ /s]) ∧ (∃v.(i = v + 1) ∧ (v = 0 ∧ s = 0))[v ′ /s]
               = ∃v ′ .(s = v ′ + i) ∧ (∃v.(i = v + 1) ∧ (v = 0 ∧ v ′ = 0))
               ≡ ∃v.∃v ′ .(s = v ′ + i) ∧ (i = v + 1) ∧ (v = 0 ∧ v ′ = 0)
               ≡ ∃v.∃v ′ .(s = 0 + i) ∧ (i = 0 + 1) ∧ (v = 0 ∧ v ′ = 0)
               ≡s=i∧i=1
               ≡s=1∧i=1

4.3   Skip
Definition 4.6 (SP for Skip).
                                          sp(skip, P ) = P

    Since the skip statement does nothing, the strongest postcondition is simply the precondition
itself.

Remark 4.7. This is identical to the weakest precondition: wp(skip, Q) = Q.

4.4   Conditional Statement
Definition 4.8 (SP for If-Then-Else).

               sp(if C then S1 else S2 , P ) = sp(S1 , P ∧ C) ∨ sp(S2 , P ∧ ¬C)

   The postcondition is a disjunction:

   • If the condition C was true, we execute S1 starting from P ∧ C

   • If the condition C was false, we execute S2 starting from P ∧ ¬C


                                                   6
Remark 4.9. Compare with weakest precondition:

         wlp(if C then S1 else S2 , Q) = (C → wlp(S1 , Q)) ∧ (¬C → wlp(S2 , Q))

   The sp rule uses disjunction (∨) because we don’t know which branch was taken, while the
wlp rule uses conjunction (∧) because we must satisfy Q regardless of which branch is taken.

Example 4.10. Compute sp(if x < 0 then m := −x else m := x, true).

   Then branch: Compute sp(m := −x, true ∧ (x < 0)):

                       sp(m := −x, true ∧ (x < 0))
                        = ∃v.(m = (−x)[v/m]) ∧ (true ∧ (x < 0))[v/m]
                        = ∃v.(m = −x) ∧ (true ∧ (x < 0))
                        ≡ m = −x ∧ x < 0

   Else branch: Compute sp(m := x, true ∧ ¬(x < 0)):

                        sp(m := x, true ∧ ¬(x < 0))
                         = ∃v.(m = x[v/m]) ∧ (true ∧ ¬(x < 0))[v/m]
                         = ∃v.(m = x) ∧ (true ∧ (x ≥ 0))
                         ≡m=x∧x≥0

   Combined:

                      sp(if x < 0 then m := −x else m := x, true)
                       = (m = −x ∧ x < 0) ∨ (m = x ∧ x ≥ 0)

   This postcondition states that m contains the absolute value of x.

4.5   While Loop
Definition 4.11 (SP for While Loop).

            sp(while C do S, P ) = sp(while C do S, sp(S, P ∧ C)) ∨ (P ∧ ¬C)

   This recursive definition captures the unrolling of the loop:

   • (P ∧ ¬C) represents the case where the loop never executes

   • sp(while C do S, sp(S, P ∧ C)) represents executing the loop body once and then recur-
     sively processing the remaining iterations

Remark 4.12. The strongest postcondition calculus is only meaningful for partial correctness,
as it captures the changes made to the program state after executing a statement, but does not
reason about termination.

Example 4.13. Compute sp(while (i ≤ n) do i := i + 1, i = 0 ∧ n = 2).

   We unroll the loop execution:

   Iteration 0: The loop exits immediately if i > n:

                                i = 0 ∧ n = 2 ∧ i > n ≡ false


                                               7
    Iteration 1: Execute the body once from i = 0 ∧ n = 2 ∧ (i ≤ n):

                           sp(i := i + 1, i = 0 ∧ n = 2 ∧ (i ≤ n))
                           = ∃v.(i = v + 1) ∧ (v = 0 ∧ n = 2 ∧ (v ≤ n))
                           ≡i=1∧n=2

    Then check if the loop exits: i = 1 ∧ n = 2 ∧ i > n ≡ false

    Iteration 2: Execute the body from i = 1 ∧ n = 2 ∧ (i ≤ n):

                               sp(i := i + 1, i = 1 ∧ n = 2 ∧ (i ≤ n))
                               ≡i=2∧n=2

    Then check if the loop exits: i = 2 ∧ n = 2 ∧ i > n ≡ false

    Iteration 3: Execute the body from i = 2 ∧ n = 2 ∧ (i ≤ n):

                               sp(i := i + 1, i = 2 ∧ n = 2 ∧ (i ≤ n))
                               ≡i=3∧n=2

    Now check if the loop exits: i = 3 ∧ n = 2 ∧ i > n ≡ true

    Final result:

            sp(while (i ≤ n) do i := i + 1, i = 0 ∧ n = 2) = i = 3 ∧ n = 2 ∧ i > n

    This can be simplified to: i = 3 ∧ n = 2 (since 3 > 2 is already implied).
Remark 4.14. Each disjunct in the full expansion corresponds to a particular program execution
path. In the example above, the conjuncts representing iterations 0, 1, and 2 are false, indicating
impossible executions (the loop continues in those cases). Only the path corresponding to three
iterations yields a satisfiable postcondition.


5     Summary of Strongest Postcondition Rules

                Statement       Strongest Postcondition
                Assignment      sp(x := e, P ) = ∃v.(x = e[v/x]) ∧ P [v/x]
                Sequence        sp(S1 ; S2 , P ) = sp(S2 , sp(S1 , P ))
                Skip            sp(skip, P ) = P
                Conditional     sp(if C then S1 else S2 , P )
                                  = sp(S1 , P ∧ C) ∨ sp(S2 , P ∧ ¬C)
                While Loop      sp(while C do S, P )
                                  = sp(while C do S, sp(S, P ∧ C)) ∨ (P ∧ ¬C)



6     Properties of Strongest Postconditions
6.1   Main Theorems
Theorem 6.1 (Soundness and Completeness of SP). A Hoare triple {P }S{Q} is valid if and
only if:
                                 |= sp(S, P ) → Q

                                                    8
Proof Sketch. (⇒) If {P }S{Q} is valid, then by definition of strongest postcondition, any valid
postcondition must be implied by sp(S, P ), hence sp(S, P ) → Q.
   (⇐) If sp(S, P ) → Q, then by the soundness of sp, we have {P }S{sp(S, P )}, and by the
consequence rule, {P }S{Q}.

6.2    Relationship to Weakest Preconditions
Theorem 6.2 (Duality of WP and SP). For any statement S, precondition P , and postcondition
Q:
                         |= sp(S, P ) → Q iff |= P → wp(S, Q)

   This theorem establishes that sp and wp are dual approaches to the same verification prob-
lem.

6.3    Comparison: SP vs. WP

         Strongest Postcondition                        Weakest Precondition
         Works forward from precondition                Works backward from postcondition
         Computes what is guaranteed after ex-          Computes what is required before
         ecution                                        execution
         Aligned with symbolic execution                Aligned with automated verification
         Natural for testing and analysis               Natural for verification and proof
         Handles loops less elegantly (no invari-       Handles loops with invariants and
         ants)                                          variants
         Better for exploring program behavior          Better for verifying specifications



7     Strongest Postconditions and Symbolic Execution
7.1    Connection to Symbolic Execution
Definition 7.1 (Symbolic Execution). Symbolic execution is a program analysis technique
that executes a program with symbolic inputs (representing sets of possible values) rather than
concrete inputs. The execution maintains:

    1. A symbolic state that maps variables to symbolic expressions

    2. A path condition that constrains the symbolic values along the current execution path

Remark 7.2. Strongest postconditions provide a formal foundation for symbolic execution:

    • The symbolic state after executing S from precondition P is captured by sp(S, P )

    • Path conditions correspond to the conjuncts in the sp formula

    • Each disjunct in an sp formula represents a different execution path

7.2    Symbolic Execution Example
Consider the following program:
  read n
  s := 0


                                                    9
 while n > 0 do
     s := s + n
     n := n − 1
 end while
   Symbolic execution with symbolic input x (representing the initial value of n) produces
multiple execution paths:

  1. Path 1: x ≤ 0

        • Loop never executes
        • Final state: s = 0, n = x

  2. Path 2: x > 0 ∧ (x − 1) ≤ 0

        • Loop executes once
        • Final state: s = x, n = x − 1

  3. Path 3: x > 0 ∧ (x − 1) > 0 ∧ (x − 2) ≤ 0

        • Loop executes twice
        • Final state: s = x + (x − 1), n = x − 2

  4. Path k: x > k − 1 ∧ (x − k) ≤ 0

        • Loop executes k times
        • Final state: s = x + (x − 1) + · · · + (x − k + 1), n = x − k

7.3   Key Concepts in Symbolic Execution
Symbolic Values:      Variables like x that represent arbitrary (unknown) concrete values.

Path Conditions: Logical formulas like x > 0 ∧ (x − 1) ≤ 0 that constrain the symbolic
values along a specific execution path.

Symbolic Execution Tree:        A tree structure where:

   • Each node represents a program point

   • Each edge represents a transition (either sequential or conditional)

   • Each path from root to leaf represents a possible execution

7.4   Formal Connection
Property 7.3. The final symbolic state and path condition after symbolically executing state-
ment S from an initial symbolic state satisfying P exactly corresponds to sp(S, P ).

   More precisely:

   • Each disjunct in sp(S, P ) represents a feasible execution path

   • The path condition for each path appears as conjuncts within that disjunct

   • The symbolic state is captured by the equalities in the formula



                                               10
7.5    Desired Properties
For sound and complete symbolic execution, we require:
    1. Coverage (Soundness): Every concrete execution is covered by at least one symbolic
       execution path
    2. Precision (Completeness): Every symbolic execution path corresponds to at least one
       concrete execution


8     Practical Challenges and Applications
8.1    Challenges in Symbolic Execution
Path Explosion: The number of execution paths grows exponentially with program size,
particularly for programs with many conditional branches.

Loop Handling: Loops create infinitely many paths (or very many paths for bounded loops).
Strategies include:
    • Loop unrolling (bounded depth)
    • Abstraction and summarization
    • Integration with abstract interpretation

Constraint Solving: Path conditions can become very complex, requiring powerful SMT
solvers and constraint simplification techniques.

Scalability: Real-world programs often exceed the capabilities of pure symbolic execution,
necessitating selective or compositional approaches.

8.2    Mitigation Strategies
    1. Concolic Testing: Combine concrete and symbolic execution (e.g., start with concrete
       values, switch to symbolic when needed)
    2. Path Pruning: Use heuristics to eliminate unlikely or redundant paths
    3. State Merging: Combine similar symbolic states to reduce path explosion
    4. Abstract Interpretation: Use abstract domains to approximate program behavior
    5. Compositional Analysis: Analyze program components separately and compose results

8.3    Applications
Strongest postconditions and symbolic execution are used in:
    • Automated Test Generation: Generate test inputs by solving path conditions
    • Bug Finding: Explore execution paths to find crashes, assertion violations, and unde-
      fined behavior
    • Vulnerability Detection: Identify security vulnerabilities like buffer overflows
    • Program Understanding: Analyze program behavior and document possible states
    • Verification: Prove properties about program behavior

                                                 11
9     Tools Based on Symbolic Execution
Several mature tools implement symbolic execution:

     • KLEE: A symbolic execution engine built on top of LLVM, primarily for C programs

         – URL: https://klee.github.io/
         – Focus: Automated test generation and bug finding

     • S2E (Selective Symbolic Execution): A platform for analyzing entire system stacks

         – URL: https://s2e.systems/
         – Focus: Whole-system analysis combining concrete and symbolic execution

     • Angr: A Python framework for binary analysis with symbolic execution

         – URL: https://angr.io/
         – Focus: Reverse engineering and vulnerability analysis

     • SymCC: A compiler-based symbolic execution tool

         – URL: https://github.com/eurecom-s3/symcc
         – Focus: Fast symbolic execution through compilation

     • Manticore: A symbolic execution tool for analyzing binaries and smart contracts

         – URL: https://github.com/trailofbits/manticore
         – Focus: Security analysis of native code and Ethereum smart contracts

     • Driller: A tool combining fuzzing with symbolic execution

         – URL: https://github.com/shellphish/driller
         – Focus: Augmenting fuzzing to overcome complex branch conditions


10      Summary and Conclusions
    1. Forward Reasoning: Strongest postcondition calculus provides a systematic way to
       reason about programs in the forward direction, starting from a precondition.

    2. Duality with WP: Strongest postconditions are dual to weakest preconditions: both
       can be used to verify program correctness, but they work in opposite directions.

    3. Connection to Symbolic Execution: The sp calculus provides the formal foundation
       for symbolic execution, with each disjunct representing an execution path.

    4. Practical Challenges: Path explosion, loop handling, and constraint complexity remain
       significant challenges in practice.

    5. Complementary Approaches: While wp is preferred for verification (due to invari-
       ants), sp is natural for program exploration and testing.




                                              12
10.1     Limitations
Both strongest postconditions and weakest preconditions have limitations:

     • Loop invariants (for wp) or path explosion (for sp) remain challenges

     • Expressiveness is limited by the underlying logic

     • Automation is incomplete: some verification tasks require human insight

     • Scalability to large real-world programs remains difficult


11      Further Reading
     • Robert W. Floyd, ”Assigning Meanings to Programs,” Proceedings of Symposia in Applied
       Mathematics, Vol. 19, 1967

         – URL: https://people.eecs.berkeley.edu/~necula/Papers/FloydMeaning.pdf

     • C. A. R. Hoare, ”An Axiomatic Basis for Computer Programming,” Communications of
       the ACM, 1969

         – URL: https://dl.acm.org/doi/pdf/10.1145/363235.363259

     • James C. King, ”Symbolic Execution and Program Testing,” Communications of the
       ACM, Vol. 19, No. 7, 1976

     • Patrice Godefroid, Michael Y. Levin, and David Molnar, ”Automated Whitebox Fuzz
       Testing,” NDSS, 2008

     • Cristian Cadar and Koushik Sen, ”Symbolic Execution for Software Testing: Three Decades
       Later,” Communications of the ACM, Vol. 56, No. 2, 2013




                                                13
