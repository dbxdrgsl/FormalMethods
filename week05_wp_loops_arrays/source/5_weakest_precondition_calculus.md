Weakest Precondition Calculus

        Andrei Arusoaie


        October 17, 2025
Hoare Logic - quick recap


    ▶ C. A. R. Hoare, 1969:
      https://dl.acm.org/doi/pdf/10.1145/363235.363259
    ▶ Hoare triples:
                            {P} S {Q}
    ▶ Partial correctness: If S is executed in a state satisfying P and
      the execution of S terminates then the resulted program state
      satisfies Q: |= {P}S{Q}.
Hoare Logic - quick recap


    ▶ C. A. R. Hoare, 1969:
      https://dl.acm.org/doi/pdf/10.1145/363235.363259
    ▶ Hoare triples:
                            {P} S {Q}
    ▶ Partial correctness: If S is executed in a state satisfying P and
      the execution of S terminates then the resulted program state
      satisfies Q: |= {P}S{Q}.
    ▶ Total correctness: If S is executed in a state satisfying P then
      the execution of S terminates and the resulted program state
      satisfies Q: |= [P]S[Q].
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

                    If ⊢ {P}S{Q}, then |= {P}S{Q}.

    ▶ Completeness does not hold:

                    If |= {P}S{Q}, then ⊢ {P}S{Q}.
Automation




    ▶ Manual proofs of sequents are tedious.
    ▶ What can be automated?
        ▶ The computation of the preconditions for assignments? Yes!
        ▶ The invariants for loops? No, these are not always easy to find.
        ▶ However, if someone else provides the invariants, many parts
          can be automated.
    ▶ Weakest precondition calculus is step towards automation.
IMP with Invariants for Loops
    ▶ Arithmetic Expressions

            AExp ::= Var | Int | AExp + AExp | AExp / AExp

    ▶ Conditionals:

      BExp ::= true | false | AExp < AExp | not BExp | BExp and BExp


    ▶ Statements:

               Stmt ::= Var := AExp
                       | if BExp then Stmt else Stmt
                       | while BExp inv: φ do Stmt end
                       | Stmt ; Stmt
                       | skip
Example Program in IMP with Invariants



   The sumPgm program with invariant:

   sum := 0;
   i := 0;
   while (i < n)
      inv: i ≤ n ∧ 2 * sum = i * (i + 1)
   do
        i := i + 1
        sum := sum + i;
   end
Proof Rule for While with Loop Invariants



   Proof Rule for While with invariants is updated:

                             ⊢ {I ∧ C }S{I }
                  ⊢ {I } while C inv:I do S {I ∧ ¬C }

    ▶ Beware that completeness is completely lost: if the invariant
      is not strong enough, there is a high chance that some valid
      triples might not be derived.
Automation using Verification Conditions



    ▶ Automating Hoare logic is based on generating verification
      conditions.
    ▶ A verification condition (VC) is a formula, ψ, such that the
      program is correct if and only if ψ is valid.
    ▶ Two steps are needed:
        1. First, generate VCs from the source code.
        2. Second, use an automated tool to check the validity of the
           VCs.
Forwards vs. Backwards methods for generating VCs



    ▶ Two main approaches to VCs:
        1. Forward: Start from the precondition and generate formulas
           to prove the postcondition.
             ▶ This computes the strongest postconditions (sp).
        2. Backward: Start from the postcondition and works backwards
           to find the precondition.
             ▶ This computes the weakest preconditions (wp).
    ▶ Here we focus on the weakest (liberal) precondition.
Weakest Preconditions



    ▶ The weakest precondition (wp) for a statement S and
      postcondition Q is a formula wp(S, Q) such that:
        ▶ If wp(S, Q) holds before executing S, then Q will hold after S
          finishes.
        ▶ wp(S, Q) is the weakest formula satisfying this, meaning any
          weaker precondition would fail to ensure Q after S.
    ▶ Calculating wp(S, Q) depends on the type of statement S.
    ▶ We start with Q and going backwards we compute wp(S, Q).
    ▶ The sequent ⊢ {P}S{Q} is valid iff |= P → wp(S, Q).
Weakest (Liberal) Precondition Calculus



    ▶ However, it si very difficult to compute the weakest
      precondition of loops, due to termination.
    ▶ Recall: If wp(S, Q) holds before executing S, then Q will hold
      after S finishes.
    ▶ This is why we need some sort of function that does not rely
      on the fact that S terminates.
    ▶ We call this function: Weakest Liberal Precondition,
      shorthanded as wlp.
wlp for Assignment




   For assignment, the weakest liberal precondition is defined by
   substituting the assigned variable with the expression:

                        wlp(x := e, Q) = Q[e/x]

   If Q[e/x] is the precondition then Q holds after assigning e to x.
Example

  Let the postcondition Q be i ≤ n ∧ 2 · s = i · (i + 1).
   ▶ Example 1: s := s + i

       wlp(s := s + i, Q) = (i ≤ n) ∧ (2 · (s + i) = i · (i + 1))


  A quick note to avoid confusion:
  ⊢ wlp(s := s + i, Q){s := s + i}Q is valid because the precondition

                   (i ≤ n) ∧ (2 · (s + i) = i · (i + 1))
  holds before executing the assignment; after the assignment, the
  value of s changes (i.e., it becomes s + i), so s holds the value of
  s + i. Therefore, i ≤ n ∧ 2 · s = i · (i + 1) is now true for this new
  value of s.
Another Example




  Let the postcondition Q ′ be (i ≤ n) ∧ (2 · (s + i) = i · (i + 1)).
   ▶ Example 2: i := i + 1
       wlp(i := i + 1, Q ′ ) = ( i + 1 ≤ n) ∧
                 (2 · (s + (i + 1) ) = (i + 1) · ( (i + 1) + 1))
wlp for Sequential Composition




   For sequential composition, where S1 is followed by S2 :

                  wlp(S1 ; S2 , Q) = wlp(S1 , wlp(S2 , Q))

   This calculates the weakest precondition by chaining the conditions
   backward through each statement.
Example


  We want to compute wlp(i := i + 1; s := s + i, Q) with the
  postcondition Q : i ≤ n ∧ 2 · s = i · (i + 1).
   ▶ Step 1: Calculate wlp(s := s + i, Q)

       wlp(s := s + i, Q) = (i ≤ n) ∧ (2 · (s + i) = i · (i + 1)) = Q ′

   ▶ Step 2: Compute
     wlp(i := i + 1, wlp(s := s + i, Q)) = wlp(i := i + 1, Q ′ )

      wlp(i := i + 1, Q ′ ) = (i + 1 ≤ n) ∧
                            (2 · (s + (i + 1)) = (i + 1) · ((i + 1) + 1))
wlp for the Skip Statement




   For the skip statement, the weakest liberal precondition is simply:

                           wlp(skip, Q) = Q

   This means that executing ‘skip‘ does not alter Q.
wlp for Conditional Statements




   For conditional statements, the wlp is defined as follows:

   wlp(if C then S1 else S2 , Q) =

                    (C → wlp(S1 , Q)) ∧ (¬C → wlp(S2 , Q))

   This considers both branches based on the truth value of C .
Example

  We compute wlp(if x < 0 then m := −x else m := x, Q) where Q
  is m ≥ 0.
    ▶ For the ‘then‘ branch (x < 0):

             wlp(m := −x, Q) = (m ≥ 0)[−x/m] = −x ≥ 0

   ▶ For the ‘else‘ branch (x ≥ 0):

                wlp(m := x, Q) = (m ≥ 0)[x/m] = x ≥ 0

   ▶ wlp(if x < 0 then m := −x else m := x, Q) =
                   (x < 0 → −x ≥ 0) ∧ (x ≥ 0 → x ≥ 0)
Example

  We compute wlp(if x < 0 then m := −x else m := x, Q) where Q
  is m ≥ 0.
    ▶ For the ‘then‘ branch (x < 0):

              wlp(m := −x, Q) = (m ≥ 0)[−x/m] = −x ≥ 0

   ▶ For the ‘else‘ branch (x ≥ 0):

                wlp(m := x, Q) = (m ≥ 0)[x/m] = x ≥ 0

   ▶ wlp(if x < 0 then m := −x else m := x, Q) =
                   (x < 0 → −x ≥ 0) ∧ (x ≥ 0 → x ≥ 0)
   ▶ wlp(if x < 0 then m := −x else m := x, Q) = true
  So Q (i.e., m ≥ 0) holds for both branches.
wlp for While Loops with Invariants



   For while loops with an invariant I , the wlp is defined as:

   wlp(while C inv:I do S, Q) =
                                                             
   I ∧ ∀x1 , . . . , xk . (C ∧ I ) → wlp(S, I ) ∧ (¬C ∧ I ) → Q [xi /wi ]

   where w1 , . . . , wk are variables modified in S, and x1 , . . . , xk are
   fresh variables.
Example
  wlp(while (i < n) inv: (i ≤ n) do i := i + 1, i = n ) =?

  wlp(while (i < n) inv: i ≤ n do i := i + 1, i = n ) =
                                                               
   = (i ≤ n) ∧ ∀x. ( i < n ∧ i ≤ n ) → wlp(i := i + 1, (i ≤ n) )
                                                 
                  ∧ (¬ i < n ∧ i ≤ n ) → i = n [x/i]
                                                                
   = (i ≤ n) ∧ ∀x. ( x < n ∧ x ≤ n ) → wlp(x := x + 1, x ≤ n )
                                                  
                  ∧ (¬ x < n ∧ x ≤ n ) → x = n
                                                    
   = (i ≤ n) ∧ ∀x. ( x < n ∧ x ≤ n ) → (x + 1 ≤ n))
                                                  
                  ∧ (¬ x < n ∧ x ≤ n ) → x = n
                                                           
   ≡ (i ≤ n) ∧ ∀x. x < n → (x + 1 ≤ n) ∧ x = n → x = n

   ≡ (i ≤ n)
Summary


   ▶ wlp(x := e, Q) = Q[e/x]
   ▶ wlp(S1 ; S2 , Q) = wlp(S1 , wlp(S2 , Q))
   ▶ wlp(skip, Q) = Q
   ▶ wlp(if C then S1 else S2 , Q) =
                       (C → wlp(S1 , Q)) ∧ (¬C → wlp(S2 , Q))
   ▶ wlp(while C inv:I do S, Q) =
                                                             
      I ∧∀x1 , . . . , xk . (C ∧I ) → wlp(S, I ) ∧ (¬C ∧I ) → Q [xi /wi ]

      where w1 , . . . , wk are variables modified in S, and x1 , . . . , xk
      are fresh variables.
Important results


   Theorem (Soundness)
                                                         
   For all statements S and postconditions Q, ⊢ {wlp S, Q } S {Q}.
Important results


   Theorem (Soundness)
                                                         
   For all statements S and postconditions Q, ⊢ {wlp S, Q } S {Q}.
   Key ideas:
    ▶ The proof is on structural induction on S.
Important results


   Theorem (Soundness)
                                                         
   For all statements S and postconditions Q, ⊢ {wlp S, Q } S {Q}.
   Key ideas:
    ▶ The proof is on structural induction on S.
    ▶ For the case of the loop, an induction on the length of its
      execution is needed.
Important results


   Theorem (Soundness)
                                                         
   For all statements S and postconditions Q, ⊢ {wlp S, Q } S {Q}.
   Key ideas:
    ▶ The proof is on structural induction on S.
    ▶ For the case of the loop, an induction on the length of its
      execution is needed.
    ▶ Also important, the interpretation of the universally quantified
      formula                                               
      ∀x1 , . . . , xk . (C ∧ I ) → wlp(S, I ) ∧ (¬C ∧ I ) → Q [xi /wi ]
      does not depend on the values of the variables wi , so the
      formula still holds for two consecutive program states.
Important results


   Theorem (WLP property)
   For any triple {P}S{Q} that is derivable using the proof rules
   (including the modified one for the loop), we have P → wlp(S, Q).
Important results


   Theorem (WLP property)
   For any triple {P}S{Q} that is derivable using the proof rules
   (including the modified one for the loop), we have P → wlp(S, Q).
   Key ideas:
    ▶ The proof is on structural induction on S.
Important results


   Theorem (WLP property)
   For any triple {P}S{Q} that is derivable using the proof rules
   (including the modified one for the loop), we have P → wlp(S, Q).
   Key ideas:
    ▶ The proof is on structural induction on S.
    ▶ An important consequence of this theorem is the fact that,
      without loss of generality, we can look for a proof of
      P → wlp(S, Q) instead of finding a proof derivation for
      {P}S{Q}.
Important results


   Theorem (WLP property)
   For any triple {P}S{Q} that is derivable using the proof rules
   (including the modified one for the loop), we have P → wlp(S, Q).
   Key ideas:
    ▶ The proof is on structural induction on S.
    ▶ An important consequence of this theorem is the fact that,
      without loss of generality, we can look for a proof of
      P → wlp(S, Q) instead of finding a proof derivation for
      {P}S{Q}.
    ▶ In order to prove P → wlp(S, Q), various automatic proving
      tools can be employed.
Total correctness



    ▶ So far, we considered only partial correctness.
Total correctness



    ▶ So far, we considered only partial correctness.
    ▶ Total correctness needs, besides partial correctness, a proof
      for termination.
    ▶ Total correctness: If S is executed in a state satisfying P then
      the execution of S terminates and the resulted program state
      satisfies Q: |= [P]S[Q].
Total correctness



    ▶ So far, we considered only partial correctness.
    ▶ Total correctness needs, besides partial correctness, a proof
      for termination.
    ▶ Total correctness: If S is executed in a state satisfying P then
      the execution of S terminates and the resulted program state
      satisfies Q: |= [P]S[Q].
    ▶ Obviously, termination is hard to prove in the case of loops.
Total correctness



    ▶ So far, we considered only partial correctness.
    ▶ Total correctness needs, besides partial correctness, a proof
      for termination.
    ▶ Total correctness: If S is executed in a state satisfying P then
      the execution of S terminates and the resulted program state
      satisfies Q: |= [P]S[Q].
    ▶ Obviously, termination is hard to prove in the case of loops.
    ▶ In fact, most of the Hoare logic rules remain unchanged when
      dealing with total correctness, except the rule for loops.
The Rule for Loops in the context of Total Correctness


              ⊢ {I ∧ C ∧ v = ξ} S {I ∧ v ≺ ξ}      wf(≺)
           ⊢ {I } while C inv:I variant:v do S end {I ∧ ¬C }



   Here, v is an expression called variant, and ξ is a fresh logical
   variable.
   The meaning of wf (≺) is: ≺ is a well-founded relation, that is,
   there is no infinite sequence ξ1 ≻ ξ2 ≻ ξ3 ≻ · · · .

   An example of a well-founded relation on unbounded integers is:

                         x ≺ y = x < y ∧ 0 ≤ y.
IMP with Variants for Loops
    ▶ Arithmetic Expressions

            AExp ::= Var | Int | AExp + AExp | AExp / AExp

    ▶ Conditionals:

      BExp ::= true | false | AExp < AExp | not BExp | BExp and BExp


    ▶ Statements:

          Stmt ::= Var := AExp
                  | if BExp then Stmt else Stmt
                  | while BExp inv: φ variant: ψ do Stmt end
                  | Stmt ; Stmt
                  | skip
Once again the updated loop rule




            ⊢ {I ∧ C ∧ v = ξ} S {I ∧ v ≺ ξ}      wf(≺)
         ⊢ {I } while C inv:I variant:v do S end {I ∧ ¬C }
Rules for Total Correctness (only While is changed)

                                                     ·
          Assignment                       ⊢{Q[e/x]} x := e {Q}


                                            ⊢{P ′ } S {Q} P→P ′
   Precondition Strengthening                     ⊢{P} S {Q}


                                            ⊢{P} S {Q ′ } Q ′ →Q
    Postcondition Weakening                     ⊢{P} S {Q}


                                         ⊢{P} S1 {Q} ⊢{Q} S2 {R}
          Composition                          ⊢{P} S1 ;S2 {R}


                                     ⊢{P∧C } S1 {Q} ⊢{P∧¬C } S2 {Q}
               If                      ⊢{P} if C then S1 else S2 {Q}


                                    ⊢{I ∧C ∧v =ξ} S {I ∧v ≺ξ}        wf(≺)
             While              ⊢{I } while C inv:I variant:v do S end {I ∧¬C }
Weakest (Strict) Precondition


    ▶ wp(x := e, Q) = Q[e/x]
    ▶ wp(S1 ; S2 , Q) = wp(S1 , wp(S2 , Q))
    ▶ wp(skip, Q) = Q
    ▶ wp(if C then S1 else S2 , Q) =
                                   (C → wp(S1 , Q)) ∧ (¬C → wp(S2 , Q))
    ▶ wp(while C inv:I          variant : v do S, Q) =                
      I ∧ ∀x1 , . . . , xk , ξ. (C ∧ I ∧ ξ = v ) → wp(S, I ∧ v ≺ ξ)
                                                                
                                               ∧ (¬C ∧ I ) → Q [xi /wi ],
      where w1 , . . . , wk are variables modified in s, and x1 , . . . , xk , ξ
      are fresh variables.
Example



  Let incToN be:

  while i < n
     inv: i <= n
     variant: n - i
  do
     i := i + 1

  What is wp(incToN, i = n) ?
Example


  while i < n
     inv: i ≤ n
     variant: n - i
  do
     i := i + 1


  wp(incToN, i = n ) =
  ( i ≤ n )∧
                                                                       
  ∀x, ξ. ( i < n ∧ i ≤ n ∧ξ = n - i ) → wp(i := i +1, i≤ n ∧ n - i ≺ ξ)
                                                                 
                                ∧ ¬( i < n ) ∧ i ≤ n → i = n [x/i]
Example - continued

   wp(incToN, i = n ) =
   ( i ≤ n )∧
                                                                        
   ∀x, ξ. ( i < n ∧ i ≤ n ∧ξ = n - i ) → wp(i := i +1, i≤ n ∧ n - i ≺ ξ)
                                                                  
                                 ∧ ¬( i < n ) ∧ i ≤ n → i = n [x/i]


   Recall that x ≺ y = x < y ∧ 0 ≤ y . So, we compute:

   wp(i := i + 1, i≤ n ∧ n - i ≺ ξ) =
   wp(i := i + 1, i≤ n ∧ n - i < ξ ∧ 0 ≤ ξ) =

                  = i + 1 ≤ n ∧ n − (i + 1) < ξ ∧ 0 ≤ ξ
Example - continued

   wp(incToN, i = n ) =
   ( i ≤ n )∧
                                                                          
   ∀x, ξ.  ( i < n ∧ i ≤ n ∧ ξ = n - i ) → wp(i := i + 1, i≤ n ∧ n - i ≺ ξ)
                                                                                                  
                                                                   ∧ ¬( i < n ) ∧ i ≤ n → i = n        [x/i]=

   ( i ≤ n )∧
                                                                              
   ∀x, ξ. ( i < n ∧ i ≤ n ∧ ξ = n - i ) → (i + 1 ≤ n ∧ n − (i + 1) < ξ ∧ 0 ≤ ξ)
                                                                                                  
                                                                  ∧ ¬( i < n ) ∧ i ≤ n → i = n         [x/i] =

   ( i ≤ n )∧
                                                                               
   ∀x, ξ. ( x < n ∧ x ≤ n ∧ ξ = n - x ) → (x + 1 ≤ n ∧ n − (x + 1) < ξ ∧ 0 ≤ ξ)
                                                                                                        
                                                                     ∧ ¬( x < n ) ∧ x ≤ n → x = n            ≡
                                                                                                  
   ( i ≤ n ) ∧ ∀x, ξ. ( x < n ∧ ξ = n - x ) → (x + 1 ≤ n ∧ n − (x + 1) < ξ ∧ 0 ≤ ξ) ∧ x = n → x = n

   Which can be simplified to:

                                                                                           
   ( i ≤ n ) ∧ ∀x, ξ.       ( x < n ∧ ξ = n - x ) → (x + 1 ≤ n ∧ n − (x + 1) < ξ ∧ 0 ≤ ξ)
Example - continued

   wp(incToN, i = n ) =
                                                                                  
   ( i ≤ n ) ∧ ∀x, ξ. ( x < n ∧ ξ = n - x ) → (x + 1 ≤ n ∧ n − (x + 1) < ξ ∧ 0 ≤ ξ)


   But:
     ▶ x < n implies x + 1 ≤ n.
     ▶ Since ξ = n − x, we have
       n − (x + 1) < ξ ≡ n − (x + 1) < n − x ≡ (n − x) − 1 < (n − x) ≡ −1 < 0.
     ▶ Also, x < n ≡ 0 < n − x. Since ξ = n − x we have 0 < ξ which implies 0 ≤ ξ.


   Note that here we used the variant to prove termination!


   Therefore, the universally quantified formula is true, so we have:

                               wp(incToN, i = n ) = i ≤ n .
Properties



   Theorem (Soundness)
   For all statements S and postconditions Q, ⊢ {wp(S, Q)}S{Q}.
Properties



   Theorem (Soundness)
   For all statements S and postconditions Q, ⊢ {wp(S, Q)}S{Q}.

   Theorem
   For any triple {P}S{Q} that is derivable using the proof rules
   (including the modified one for the loop) we have P → wp(S, Q).
Properties



   Theorem (Soundness)
   For all statements S and postconditions Q, ⊢ {wp(S, Q)}S{Q}.

   Theorem
   For any triple {P}S{Q} that is derivable using the proof rules
   (including the modified one for the loop) we have P → wp(S, Q).

   As a consequence, for proving that a triple {P}S{Q} is valid (for
   total correctness), we can without loss of generality prove the
   formula |= P → wp(S, Q).
Summary – Weakest Precondition Calculus


    ▶ Weakest Liberal Precondition (WLP):
        ▶ Definition: The wlp(S, Q) provides the weakest condition P
          such that if P holds before executing statement S, Q will hold
          after execution, provided S terminates.
        ▶ Usage: Focuses on partial correctness, ensuring postcondition
          Q is true if S terminates.

    ▶ Weakest Precondition (WP):
        ▶ Definition: The wp(S, Q) provides the weakest condition P
          ensuring that Q holds after S, accounting for both termination
          and correctness.
        ▶ Usage: Ensures total correctness, as it demands both
          termination and the truth of Q.
