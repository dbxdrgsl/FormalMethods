Deductive Program Verification using Hoare
                 Logic

               Andrei Arusoaie
What is Deductive Program Verification?



    ▶ Deductive program verification is a method to prove the
      correctness of programs using formal logic
    ▶ We need to specify what a program is supposed to do using
      logical formulas
    ▶ Examples: safety (no crashes), no arithmetic over/underflows,
      behavioral properties
    ▶ The program is verified by proving that these specifications
      (logical formulas) hold throughout the execution of the
      program
Why Deductive Program Verification is Useful?



    ▶ Correctness: Helps ensure that a program behaves as
      intended
    ▶ Bug detection: Formal methods can detect edge cases and
      bugs missed by testing
    ▶ Especially important for safety-critical systems (e.g., aviation,
      medical devices)
    ▶ Drawback: Requires higher expertise
(Floyd-)Hoare Logic



    ▶ Robert Floyd, 1967:
      https://people.eecs.berkeley.edu/~necula/Papers/
      FloydMeaning.pdf
(Floyd-)Hoare Logic



    ▶ Robert Floyd, 1967:
      https://people.eecs.berkeley.edu/~necula/Papers/
      FloydMeaning.pdf
    ▶ Set the foundation of axiomatic semantics of classical
      programs
(Floyd-)Hoare Logic



    ▶ Robert Floyd, 1967:
      https://people.eecs.berkeley.edu/~necula/Papers/
      FloydMeaning.pdf
    ▶ Set the foundation of axiomatic semantics of classical
      programs
    ▶ C. A. R. Hoare, 1969:
      https://dl.acm.org/doi/pdf/10.1145/363235.363259
    ▶ Hoare is the inventor of quick sort, father of formal
      verification, Turing award winner 1980
Imperative Programming Language (IMP)
  Arithmetic Expressions:

          AExp ::= Var | Int | AExp + AExp | AExp / AExp

  Boolean Expressions:

                BExp ::= true | false | AExp < AExp
                         | not BExp | BExp and BExp

  Statements:

                Stmt ::= Var := AExp
                         | if BExp then Stmt else Stmt
                         | while BExp do Stmt end
                         | Stmt ; Stmt | skip
Deductive Program Verification Workflow



    ▶ Step 1: Write specifications for the program
    ▶ Step 2: Use Hoare logic to write the specs (e.g.,
      preconditions and postconditions)
    ▶ Step 3: Generate verification conditions that prove the
      program’s correctness
    ▶ Step 4: Use theorem provers to check if verification
      conditions hold
The sumPgm Program


  Program:

  sum := 0;
  i := 1;
  while (i < n + 1) do
      sum := sum + i;
      i := i + 1
  end


  Input constraint: n ≥ 0
The sumPgm Program


  Program:

  sum := 0;
  i := 1;
  while (i < n + 1) do
      sum := sum + i;
      i := i + 1
  end


  Input constraint: n ≥ 0 ← called precondition
The sumPgm Program


  Program:

  sum := 0;
  i := 1;
  while (i < n + 1) do
      sum := sum + i;
      i := i + 1
  end


  Input constraint: n ≥ 0 ← called precondition

  Desired output property: sum = n(n+1)
                                    2
The sumPgm Program


  Program:

  sum := 0;
  i := 1;
  while (i < n + 1) do
      sum := sum + i;
      i := i + 1
  end


  Input constraint: n ≥ 0 ← called precondition

  Desired output property: sum = n(n+1)
                                    2   ← called postcondition
Hoare Triples


    ▶ We can write specifications using Hoare triples:

                                {P} S {Q}
Hoare Triples


    ▶ We can write specifications using Hoare triples:

                                {P} S {Q}

    ▶ P is the precondition
    ▶ S is the program
    ▶ Q is the postcondition
Hoare Triples


    ▶ We can write specifications using Hoare triples:

                                {P} S {Q}

    ▶ P is the precondition
    ▶ S is the program
    ▶ Q is the postcondition

   Hoare Triple for our program:

                   {n ≥ 0} sumPgm {sum = n(n+1)
                                            2   }
Hoare Triples: Semantics
    ▶ How to establish the validity of a Hoare triple {P} S {Q}?
Hoare Triples: Semantics
    ▶ How to establish the validity of a Hoare triple {P} S {Q}?
    ▶ Partial correctness: If S is executed in a state satisfying P
      and the execution of S terminates, then the resulting program
      state satisfies Q
      Valid (in the sense of partial correctness) triples are denoted:

                               |= {P} S {Q}
Hoare Triples: Semantics
    ▶ How to establish the validity of a Hoare triple {P} S {Q}?
    ▶ Partial correctness: If S is executed in a state satisfying P
      and the execution of S terminates, then the resulting program
      state satisfies Q
      Valid (in the sense of partial correctness) triples are denoted:

                               |= {P} S {Q}

    ▶ Total correctness: If S is executed in a state satisfying P,
      then the execution of S terminates and the resulting program
      state satisfies Q (usually denoted by [P] S [Q])
      Valid (in the sense of total correctness) triples are denoted:

                                |= [P] S [Q]
Hoare Triples: Semantics
    ▶ How to establish the validity of a Hoare triple {P} S {Q}?
    ▶ Partial correctness: If S is executed in a state satisfying P
      and the execution of S terminates, then the resulting program
      state satisfies Q
      Valid (in the sense of partial correctness) triples are denoted:

                               |= {P} S {Q}

    ▶ Total correctness: If S is executed in a state satisfying P,
      then the execution of S terminates and the resulting program
      state satisfies Q (usually denoted by [P] S [Q])
      Valid (in the sense of total correctness) triples are denoted:

                                |= [P] S [Q]

    ▶ We only discuss partial correctness (safety) in this material
      Total correctness = Partial correctness + termination
A Few Interesting Examples




    ▶ {true} S {Q}
A Few Interesting Examples




    ▶ {true} S {Q}
    ▶ {P} S {true}
A Few Interesting Examples




    ▶ {true} S {Q}
    ▶ {P} S {true}
    ▶ [P] S [true]
A Few Interesting Examples




    ▶ {true} S {Q}
    ▶ {P} S {true}
    ▶ [P] S [true]
    ▶ {true} S {false}
A Few Interesting Examples




    ▶ {true} S {Q}
    ▶ {P} S {true}
    ▶ [P] S [true]
    ▶ {true} S {false}
    ▶ {false} S {Q}
Which of the Following Triples are Valid?



    ▶ {i = 0} while i < n do i := i + 1 end {i = n}
Which of the Following Triples are Valid?



    ▶ {i = 0} while i < n do i := i + 1 end {i = n}
    ▶ {i = 0} while i < n do i := i + 1 end {i ≥ n}
Which of the Following Triples are Valid?



    ▶ {i = 0} while i < n do i := i + 1 end {i = n}
    ▶ {i = 0} while i < n do i := i + 1 end {i ≥ n}
    ▶ {i = 0 ∧ s = 0}
       while i < n do
           i := i + 1;
           s := s + i
       end

       {2 · s = n(n + 1)}
Proofs




    ▶ Challenge: how do we prove the validity of triples?
Proofs




    ▶ Challenge: how do we prove the validity of triples? We need a
      proof system!
Proofs




    ▶ Challenge: how do we prove the validity of triples? We need a
      proof system!
    ▶ We want a proof system to help with proving |= {P} S {Q}
Proofs




    ▶ Challenge: how do we prove the validity of triples? We need a
      proof system!
    ▶ We want a proof system to help with proving |= {P} S {Q}
    ▶ We use ⊢ {P} S {Q} to denote a sequent
Proofs




    ▶ Challenge: how do we prove the validity of triples? We need a
      proof system!
    ▶ We want a proof system to help with proving |= {P} S {Q}
    ▶ We use ⊢ {P} S {Q} to denote a sequent
    ▶ ⊢ denotes syntactical calculus
    ▶ |= indicates semantic validity
Proof System Properties



    ▶ The proof system of Hoare Logic includes several proof rules
      which depend on the language constructs
    ▶ Hoare proved that his proof system is correct and
      (relatively-)complete
    ▶ Hoare also gave a sound and (relatively-)complete proof
      system that allows semi-mechanizing correctness proofs
    ▶ Soundness: If ⊢ {P} S {Q}, then |= {P} S {Q}
    ▶ Unfortunately, completeness does not hold:
      If |= {P} S {Q}, then ⊢ {P} S {Q}
Inference Rules
    ▶ Proof rules in Hoare logic are written as inference rules:

                  ⊢ {P1 } S1 {Q1 } . . . ⊢ {Pn } Sn {Qn }
                               ⊢ {P} S {Q}
    ▶ The sequents above the horizontal line are premises, while the
      sequent under the line is the conclusion
    ▶ The above rule says: if the sequents

                    ⊢ {P1 } S1 {Q1 }, . . . , ⊢ {Pn } Sn {Qn }

       are provable in our proof system, then

                                 ⊢ {P} S {Q}

       is also provable
    ▶ Rules with no hypotheses are called axioms
Understanding Proof Rule for Assignment



    ▶ There is one inference rule for every statement in the IMP
      language
    ▶ Assignments change the value of a variable in the state
    ▶ When x := e is executed, what must be true before the
      assignment for a postcondition {Q} to hold?
    ▶ Remark: {Q} holds after the assignment!
Understanding Proof Rule for Assignment



    ▶ There is one inference rule for every statement in the IMP
      language
    ▶ Assignments change the value of a variable in the state
    ▶ When x := e is executed, what must be true before the
      assignment for a postcondition {Q} to hold?
    ▶ Remark: {Q} holds after the assignment!
    ▶ So, e must be substituted for x in {Q} before the assignment
Proof Rule for Assignment




                                 ·
                      ⊢ {Q[e/x]} x := e {Q}
    ▶ This means: if {Q[e/x]} holds before the assignment, then
      after the assignment x := e, the postcondition {Q} will hold
    ▶ Recall that Q[e/x] is the notation for substitution: the
      postcondition Q with every occurrence of x replaced by the
      expression e
Example 1
  Is this sequent valid: ⊢ {true} i := 2 {i = 2}?
Example 1
  Is this sequent valid: ⊢ {true} i := 2 {i = 2}?
  We use the assignment rule:
                                   ·
                   ⊢ { Q [ e / x ]} x := e { Q }
Example 1
  Is this sequent valid: ⊢ {true} i := 2 {i = 2}?
  We use the assignment rule:
                                   ·
                   ⊢ { Q [ e / x ]} x := e { Q }

  to obtain:
                                   ·
                ⊢ { i = 2 [ 2 / i ]} i := 2 { i = 2 }
Example 1
  Is this sequent valid: ⊢ {true} i := 2 {i = 2}?
  We use the assignment rule:
                                   ·
                   ⊢ { Q [ e / x ]} x := e { Q }

  to obtain:
                                   ·
                ⊢ { i = 2 [ 2 / i ]} i := 2 { i = 2 }

  We compute the substitution, and we get:
                                ·
                    ⊢ {2 = 2} i := 2 {i = 2}
Example 1
  Is this sequent valid: ⊢ {true} i := 2 {i = 2}?
  We use the assignment rule:
                                   ·
                     ⊢ { Q [ e / x ]} x := e { Q }

  to obtain:
                                   ·
                 ⊢ { i = 2 [ 2 / i ]} i := 2 { i = 2 }

  We compute the substitution, and we get:
                                  ·
                      ⊢ {2 = 2} i := 2 {i = 2}

  This results in:
                                 ·
                      ⊢ {true} i := 2 {i = 2}
Example 2
  Is this sequent valid: ⊢ {i = k} i := i + 1 {i = k + 1}?
Example 2
  Is this sequent valid: ⊢ {i = k} i := i + 1 {i = k + 1}?
  We use the assignment rule:
                                   ·
                   ⊢ { Q [ e / x ]} x := e { Q }
Example 2
  Is this sequent valid: ⊢ {i = k} i := i + 1 {i = k + 1}?
  We use the assignment rule:
                                   ·
                   ⊢ { Q [ e / x ]} x := e { Q }

  to obtain:
                                   ·
       ⊢ { i = k + 1 [ i + 1 / i ]} i := i + 1 { i = k + 1 }
Example 2
  Is this sequent valid: ⊢ {i = k} i := i + 1 {i = k + 1}?
  We use the assignment rule:
                                   ·
                    ⊢ { Q [ e / x ]} x := e { Q }

  to obtain:
                                   ·
       ⊢ { i = k + 1 [ i + 1 / i ]} i := i + 1 { i = k + 1 }

  We compute the substitution, and we get:
                                   ·
               ⊢ {i + 1 = k + 1} i := i + 1 {i = k + 1}
Example 2
  Is this sequent valid: ⊢ {i = k} i := i + 1 {i = k + 1}?
  We use the assignment rule:
                                   ·
                    ⊢ { Q [ e / x ]} x := e { Q }

  to obtain:
                                   ·
        ⊢ { i = k + 1 [ i + 1 / i ]} i := i + 1 { i = k + 1 }

  We compute the substitution, and we get:
                                   ·
               ⊢ {i + 1 = k + 1} i := i + 1 {i = k + 1}

  that is:
                                 ·
                  ⊢ {i = k} i := i + 1 {i = k + 1}
Example 3
  Is this sequent valid: ⊢ {s = k} s := s + i {s = k + i}?
Example 3
  Is this sequent valid: ⊢ {s = k} s := s + i {s = k + i}?
  We use the assignment rule:
                                   ·
                   ⊢ { Q [ e / x ]} x := e { Q }
Example 3
  Is this sequent valid: ⊢ {s = k} s := s + i {s = k + i}?
  We use the assignment rule:
                                   ·
                   ⊢ { Q [ e / x ]} x := e { Q }

  to obtain:
                                   ·
       ⊢ { s = k + i [ s + i / s ]} s := s + i { s = k + i }
Example 3
  Is this sequent valid: ⊢ {s = k} s := s + i {s = k + i}?
  We use the assignment rule:
                                   ·
                    ⊢ { Q [ e / x ]} x := e { Q }

  to obtain:
                                   ·
       ⊢ { s = k + i [ s + i / s ]} s := s + i { s = k + i }

  We compute the substitution, and we get:
                                   ·
               ⊢ {s + i = k + i} s := s + i {s = k + i}
Example 3
  Is this sequent valid: ⊢ {s = k} s := s + i {s = k + i}?
  We use the assignment rule:
                                   ·
                    ⊢ { Q [ e / x ]} x := e { Q }

  to obtain:
                                   ·
       ⊢ { s = k + i [ s + i / s ]} s := s + i { s = k + i }

  We compute the substitution, and we get:
                                   ·
               ⊢ {s + i = k + i} s := s + i {s = k + i}

  Simplifying the equation, we obtain:
                                 ·
                  ⊢ {s = k} s := s + i {s = k + i}
Example 4
  Is this sequent valid: ⊢ {i ≥ 0} i := i + 1 {i ≥ 1}?
Example 4
  Is this sequent valid: ⊢ {i ≥ 0} i := i + 1 {i ≥ 1}?
  We use the assignment rule:
                                   ·
                   ⊢ { Q [ e / x ]} x := e { Q }
Example 4
  Is this sequent valid: ⊢ {i ≥ 0} i := i + 1 {i ≥ 1}?
  We use the assignment rule:
                                     ·
                     ⊢ { Q [ e / x ]} x := e { Q }

  to obtain:
                                     ·
               ⊢ { i ≥ 1 [ i + 1 / i ]} i := i + 1 { i ≥ 1 }
Example 4
  Is this sequent valid: ⊢ {i ≥ 0} i := i + 1 {i ≥ 1}?
  We use the assignment rule:
                                     ·
                     ⊢ { Q [ e / x ]} x := e { Q }

  to obtain:
                                     ·
               ⊢ { i ≥ 1 [ i + 1 / i ]} i := i + 1 { i ≥ 1 }

  We compute the substitution, and we get:
                                   ·
                   ⊢ {i + 1 ≥ 1} i := i + 1 {i ≥ 1}
Example 4
  Is this sequent valid: ⊢ {i ≥ 0} i := i + 1 {i ≥ 1}?
  We use the assignment rule:
                                     ·
                     ⊢ { Q [ e / x ]} x := e { Q }

  to obtain:
                                     ·
               ⊢ { i ≥ 1 [ i + 1 / i ]} i := i + 1 { i ≥ 1 }

  We compute the substitution, and we get:
                                   ·
                   ⊢ {i + 1 ≥ 1} i := i + 1 {i ≥ 1}

  which simplifies to:
                                   ·
                     ⊢ {i ≥ 0} i := i + 1 {i ≥ 1}
Precondition Strengthening Rule




                  ⊢ {P ′ } S {Q}    P → P′
                          ⊢ {P} S {Q}
Precondition Strengthening Rule




                      ⊢ {P ′ } S {Q}    P → P′
                              ⊢ {P} S {Q}

    ▶ If ⊢ {P ′ } S {Q} and P implies P ′ , then ⊢ {P} S {Q} holds
      as well
    ▶ This rule is used to strengthen the precondition by making it
      less strict while maintaining the validity of the Hoare triple
Example: Precondition Strengthening

   Is this sequent valid: ⊢ {n > 0} n := n + 1 {n ≥ 1}?
   The precondition strengthening rule is:

                     ⊢ { P ′ } S {Q}         P → P′
                             ⊢ { P } S {Q}

   Here is the proof (which uses the assignment rule — see Example
   4):
                        ·
         ⊢ { n ≥ 0 } n := n + 1 {n ≥ 1}        n>0 → n≥0
                     ⊢ { n > 0 } n := n + 1 {n ≥ 1}
Proof Rule for Postcondition Weakening




    ▶ A dual rule for postconditions called postcondition weakening:

                         ⊢ {P} S {Q ′ }  Q′ → Q
                               ⊢ {P} S {Q}

    ▶ If we can prove postcondition Q ′ , we can always relax it to
      something weaker Q
Example: Postcondition Weakening


   Is this sequent valid: ⊢ {n > 0} n := n + 1 {n > 0}?
   The postcondition weakening rule is:

                    ⊢ {P} S { Q ′ }       Q′ → Q
                             ⊢ {P} S { Q }

   Here is the proof (which uses again the assignment rule):
                       ·
         ⊢ {n > 0} n := n + 1 { n ≥ 1 }       n≥1 → n>0
                    ⊢ {n > 0} n := n + 1 { n > 0 }
Proof Rule for Composition



                  ⊢ {P} S1 {Q}       ⊢ {Q} S2 {R}
                         ⊢ {P} S1 ; S2 {R}

    ▶ Remark: the postcondition of ⊢ {P} S1 {Q} is the same as
      the precondition of ⊢ {Q} S2 {R}, which could be an issue in
      practice because they don’t always match
    ▶ This could be a little restrictive, but precondition
      strengthening or postcondition weakening could be used to
      overcome this issue
Example: Composition Rule

   Is this sequent valid: ⊢ {true} x := 2 ; y := x {y = 2 ∧ x = 2}?
   We use the composition rule:

               ⊢ { P } S1 { Q }        ⊢ { Q } S2 { R }
                        ⊢ { P } S1 ; S2 { R }

   Here is the proof (which uses the assignment rule for both
   statements, individually):
                ·                                     ·
   ⊢ { true } x := 2 { x = 2 }      ⊢ { x = 2 } y := x { y = 2 ∧ x = 2 }
               ⊢ { true } x := 2 ; y := x { y = 2 ∧ x = 2 }
Proof Rule for If Statements




            ⊢ {P ∧ C } S1 {Q}  ⊢ {P ∧ ¬C } S2 {Q}
               ⊢ {P} if C then S1 else S2 {Q}

    ▶ Suppose we know P holds before the if statement and want to
      show Q holds afterwards
    ▶ In the then branch, we want to show {P ∧ C } S1 {Q}
    ▶ In the else branch, we want to show {P ∧ ¬C } S2 {Q}
Example: Proof for If Statement

   Is this sequent valid:

      ⊢ {true} if x < 0 then m := −x else m := x {m ≥ 0}?

   We use the rule for if-statements:

          ⊢ { P ∧ C } S1 { Q }          ⊢ { P ∧ ¬ C } S2 { Q }
                ⊢ { P } if C then S1 else S2 { Q }
Example: Proof for If Statement

   Is this sequent valid:

      ⊢ {true} if x < 0 then m := −x else m := x {m ≥ 0}?

   We use the rule for if-statements:

           ⊢ { P ∧ C } S1 { Q }             ⊢ { P ∧ ¬ C } S2 { Q }
                  ⊢ { P } if C then S1 else S2 { Q }

   We show two branches:
                    ...                                      ...
    ⊢ { true ∧ x < 0 } m := −x { m ≥ 0 }   ⊢ { true ∧ ¬ (x < 0) } m := x { m ≥ 0 }

               ⊢ { true } if x < 0 then m := −x else m := x { m ≥ 0 }
  Example: Proof for If Statement (Complete)




        The proof of
        ⊢ {true} if x < 0 then m := −x else m := x {m ≥ 0}:

            ·                                                                ·

{ −x ≥ 0 } m := −x { m ≥ 0 }   t ∧ (x < 0)    →     −x ≥ 0     ⊢ { x ≥ 0 } m := x { m ≥ 0 }    t ∧ ¬ (x < 0)     →   x ≥ 0


          ⊢ { t ∧ x < 0 } m := −x { m ≥ 0 }                               ⊢ { t ∧ ¬ (x < 0) } m := x { m ≥ 0 }


                               ⊢ { t } if   x < 0   then m := −x else m := x { m ≥ 0 }
Proof Rule for While and Loop Invariants


   Proof Rule for While:
                            ⊢ {I ∧ C } S {I }
                  ⊢ {I } while C do S end {I ∧ ¬C }


    ▶ To understand the proof rule for while loops, we first need the
      concept of a loop invariant

    ▶ A loop invariant I . . .
         1. . . . holds before the loop starts and after the loop ends
         2. . . . holds after every iteration of the loop
Example: Proof for While Statement
   Is this sequent valid:
            ⊢ {i = 0} while (i < n) do i := i + 1 end {i = n}?

   Note: n is a natural number


                      ⊢ { I ∧ i < n } i := i + 1 { I }
      ⊢ { I } while (i < n) do i := i + 1 end { I ∧ ¬ (i < n) }

   In this case, the loop invariant is I = (i ≤ n) :
Example: Proof for While Statement
   Is this sequent valid:
                ⊢ {i = 0} while (i < n) do i := i + 1 end {i = n}?

   Note: n is a natural number


                              ⊢ { I ∧ i < n } i := i + 1 { I }
       ⊢ { I } while (i < n) do i := i + 1 end { I ∧ ¬ (i < n) }

   In this case, the loop invariant is I = (i ≤ n) :
                    ·
   ⊢ { i + 1 ≤ n } i := i + 1 { i ≤ n }     i≤n ∧ i<n → i+1≤n

                  ⊢ { i ≤ n ∧ i < n } i := i + 1 { i ≤ n }

      ⊢ { i ≤ n } while (i < n) do i := i + 1 end{ i ≤ n ∧ ¬ (i < n) }             i≤n ∧¬ i<n →i =n

                              ⊢ { i ≤ n } while (i < n) do i := i + 1 end{i = n}        i =0→ i≤n

                              ⊢ {i = 0} while (i < n) do i := i + 1 end{i = n}
Proof of Invariant for While Loop — Part I
   We prove that i ≤ n is the invariant for:

                   while (i < n) do i := i + 1 end

   Remark: I = (i ≤ n) must be true before and after each iteration.

   The sequent we proved:

          ⊢ {i = 0} while (i < n) do i := i + 1 end {i = n}


   The invariant holds before the loop: The precondition i = 0
   implies i ≤ n

   The invariant is preserved by the loop body:
   We need to prove the sequent:

                  ⊢ {i ≤ n ∧ i < n} i := i + 1 {i ≤ n}
Proof of Invariant for While Loop — Part II


   The proof is below:
                   ·
   ⊢ {i + 1 ≤ n} i := i + 1 {i ≤ n}    (i ≤ n ∧ i < n) → i + 1 ≤ n
                 ⊢ {i ≤ n ∧ i < n} i := i + 1 {i ≤ n}


   Therefore, i ≤ n still holds after the iteration, including the last
   iteration.
   At the end of the loop, the invariant i ≤ n holds, but the condition
   of the loop does not hold anymore; so, ¬(i < n) holds, that is,
   i ≥ n.
   From i ≤ n and i ≥ n we have i = n.
Summary of Hoare Logic Proof Rules

                                                ·
           Assignment                 ⊢{Q[e/x]} x := e {Q}


                                       ⊢{P ′ } S {Q} P→P ′
    Precondition Strengthening               ⊢{P} S {Q}


                                      ⊢{P} S {Q ′ } Q ′ →Q
    Postcondition Weakening               ⊢{P} S {Q}


                                    ⊢{P} S1 {Q} ⊢{Q} S2 {R}
           Composition                    ⊢{P} S1 ;S2 {R}


                                 ⊢{P∧C } S1 {Q} ⊢{P∧¬C } S2 {Q}
                If                 ⊢{P} if C then S1 else S2 {Q}


                                            ⊢{I ∧C } S {I }
              While                ⊢{I } while C do S end {I ∧¬C }
Soundness


    ▶ It can be shown that the proof rules for Hoare logic are sound:

                   If ⊢ {P} S {Q}, then |= {P} S {Q}

    ▶ This means that if ⊢ {P} S {Q} is provable using the proof
      rules, then |= {P} S {Q} — the triple is semantically valid
    ▶ Completeness of proof rules means that if {P} S {Q} is a
      semantically valid Hoare triple, then it can be proven using
      our proof rules, i.e.,

                   If |= {P} S {Q}, then ⊢ {P} S {Q}

    ▶ Unfortunately, completeness does not hold!
Relative Completeness


    ▶ The rules for precondition strengthening and postcondition
      weakening contain implications φ → φ′
    ▶ There are valid implications that cannot be proven (due to
      Peano Arithmetic which is incomplete)
    ▶ The rules still provide an important guarantee, called relative
      completeness:

       If we have an oracle for deciding whether an implication
       φ ⇒ φ′ holds, then any valid Hoare triple can be proven using
       our proof rules.
The sum Program in Dafny

1    method mysum ( n : nat ) returns ( sum : int )
2        requires n >= 0
3        ensures sum == n * ( n + 1) / 2
4    {
5        sum := 0;
6        var i := 1;
7
8         while i < n + 1
9             invariant 1 <= i <= n + 1
10            invariant sum == i * ( i - 1) / 2
11        {
12            sum := sum + i ;
13            i := i + 1;
14        }
15   }

     This is a direct translation of our Hoare Logic proof into
     executable, verified code!
What Dafny Automatically Verifies


   When you compile this Dafny program, it automatically:
    1. Initial State: Checks that the invariant holds after
       initialization
         ▶ After sum := 0; i := 1, does the invariant hold?
    2. Preservation: Verifies that the loop body preserves the
       invariant
         ▶ If invariant ∧ condition holds before, does invariant hold after?
    3. Postcondition: Confirms that invariant ∧ ¬condition implies
       postcondition
         ▶ invariant implies sum == n*(n+1)/2?
Summary



   ▶ Deductive Program Verification — a method to prove
     program correctness using formal logic
   ▶ Hoare Logic — a system to reason about program correctness
     using Hoare triples {P} S {Q}
   ▶ Partial Correctness vs Total Correctness (termination!)
   ▶ The Hoare Logic Proof System: A set of rules for proving the
     validity of Hoare triples
   ▶ Soundness and Relative Completeness
