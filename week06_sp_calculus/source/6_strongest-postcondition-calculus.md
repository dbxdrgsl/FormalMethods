Strongest Postcondition Calculus

          Andrei Arusoaie
Hoare Logic - quick recap



    ▶ C. A. R. Hoare, 1969:
      https://dl.acm.org/doi/pdf/10.1145/363235.363259
Hoare Logic - quick recap



    ▶ C. A. R. Hoare, 1969:
      https://dl.acm.org/doi/pdf/10.1145/363235.363259
    ▶ Hoare’s work was inspired R.W.Floyd’s work on Assigning
      Meanings to Programs
Hoare Logic - quick recap



    ▶ C. A. R. Hoare, 1969:
      https://dl.acm.org/doi/pdf/10.1145/363235.363259
    ▶ Hoare’s work was inspired R.W.Floyd’s work on Assigning
      Meanings to Programs
    ▶ Robert Willoughby Floyd, 1967:
      https://people.eecs.berkeley.edu/~necula/Papers/
      FloydMeaning.pdf
Hoare Logic - quick recap



    ▶ C. A. R. Hoare, 1969:
      https://dl.acm.org/doi/pdf/10.1145/363235.363259
    ▶ Hoare’s work was inspired R.W.Floyd’s work on Assigning
      Meanings to Programs
    ▶ Robert Willoughby Floyd, 1967:
      https://people.eecs.berkeley.edu/~necula/Papers/
      FloydMeaning.pdf
    ▶ However, there are some differences in their approaches
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
Floyd’s approach

                                                  ·
          Assignment            ⊢{P} x := e {∃v .(x=e[v /x])∧P[v /x]}


                                       ⊢{P ′ } S {Q} P→P ′
   Precondition Strengthening                ⊢{P} S {Q}


                                       ⊢{P} S {Q ′ } Q ′ →Q
    Postcondition Weakening                ⊢{P} S {Q}


                                    ⊢{P} S1 {Q} ⊢{Q} S2 {R}
          Composition                     ⊢{P} S1 ;S2 {R}


                                ⊢{P∧C } S1 {Q} ⊢{P∧¬C } S2 {Q}
               If                 ⊢{P} if C then S1 else S2 {Q}


                                            ⊢{I ∧C } S {I }
             While                 ⊢{I } while C do S end {I ∧¬C }
Assignment has existential quantifiers in Floyd’s approach

                                 ·
          ⊢ { P } x := e {∃v .( x = e [v / x ]) ∧ P [v / x ]}
   The existentially quantified value v corresponds to the old value of
   x. Therefore, after the assignment, we replace in e the value v for
   x, and we also keep the information that P holds for v .
Assignment has existential quantifiers in Floyd’s approach

                                 ·
          ⊢ { P } x := e {∃v .( x = e [v / x ]) ∧ P [v / x ]}
   The existentially quantified value v corresponds to the old value of
   x. Therefore, after the assignment, we replace in e the value v for
   x, and we also keep the information that P holds for v .
   Example:


   ⊢ { s = 0 } s := s + i {∃v .( s = ( s+i )[v / s ])∧( s = 0 )[v / s ]}
Assignment has existential quantifiers in Floyd’s approach

                                 ·
          ⊢ { P } x := e {∃v .( x = e [v / x ]) ∧ P [v / x ]}
   The existentially quantified value v corresponds to the old value of
   x. Therefore, after the assignment, we replace in e the value v for
   x, and we also keep the information that P holds for v .
   Example:


   ⊢ { s = 0 } s := s + i {∃v .( s = ( s+i )[v / s ])∧( s = 0 )[v / s ]}

   After applying substitutions, we get:

       ⊢ { s = 0 } s := s + i {∃v .( s = ( v+i )) ∧ ( v = 0 )}
Example – continued
   We obtain an existentially quantified postcondition:

      ⊢ { s = 0 } s := s + i {∃v .( s = ( v+i )) ∧ ( v = 0 )}
Example – continued
   We obtain an existentially quantified postcondition:

       ⊢ { s = 0 } s := s + i {∃v .( s = ( v+i )) ∧ ( v = 0 )}

   Note: in this example, this can be further simplified, by substituting 0 for
   v , and eliminate the quantifier (this is not always possible!):

                    ⊢ { s = 0 } s := s + i {s = 0 + i}
Example – continued
   We obtain an existentially quantified postcondition:

       ⊢ { s = 0 } s := s + i {∃v .( s = ( v+i )) ∧ ( v = 0 )}

   Note: in this example, this can be further simplified, by substituting 0 for
   v , and eliminate the quantifier (this is not always possible!):

                    ⊢ { s = 0 } s := s + i {s = 0 + i}

   {s = 0 + i} is the strongest postcondition after the assignment.
Example – continued
   We obtain an existentially quantified postcondition:

       ⊢ { s = 0 } s := s + i {∃v .( s = ( v+i )) ∧ ( v = 0 )}

   Note: in this example, this can be further simplified, by substituting 0 for
   v , and eliminate the quantifier (this is not always possible!):

                    ⊢ { s = 0 } s := s + i {s = 0 + i}

   {s = 0 + i} is the strongest postcondition after the assignment.

   Using Hoare’s rule, with postcondition {s = 0 + i} we obtain the same
   precondition:
Example – continued
   We obtain an existentially quantified postcondition:

       ⊢ { s = 0 } s := s + i {∃v .( s = ( v+i )) ∧ ( v = 0 )}

   Note: in this example, this can be further simplified, by substituting 0 for
   v , and eliminate the quantifier (this is not always possible!):

                    ⊢ { s = 0 } s := s + i {s = 0 + i}

   {s = 0 + i} is the strongest postcondition after the assignment.

   Using Hoare’s rule, with postcondition {s = 0 + i} we obtain the same
   precondition:

             ⊢ {s = (0 + i)[s + i/s]} s := s + i {s = 0 + i}
Example – continued
   We obtain an existentially quantified postcondition:

       ⊢ { s = 0 } s := s + i {∃v .( s = ( v+i )) ∧ ( v = 0 )}

   Note: in this example, this can be further simplified, by substituting 0 for
   v , and eliminate the quantifier (this is not always possible!):

                    ⊢ { s = 0 } s := s + i {s = 0 + i}

   {s = 0 + i} is the strongest postcondition after the assignment.

   Using Hoare’s rule, with postcondition {s = 0 + i} we obtain the same
   precondition:

             ⊢ {s = (0 + i)[s + i/s]} s := s + i {s = 0 + i}


                 ⊢ {s + i = 0 + i} s := s + i {s = 0 + i}
Example – continued
   We obtain an existentially quantified postcondition:

       ⊢ { s = 0 } s := s + i {∃v .( s = ( v+i )) ∧ ( v = 0 )}

   Note: in this example, this can be further simplified, by substituting 0 for
   v , and eliminate the quantifier (this is not always possible!):

                    ⊢ { s = 0 } s := s + i {s = 0 + i}

   {s = 0 + i} is the strongest postcondition after the assignment.

   Using Hoare’s rule, with postcondition {s = 0 + i} we obtain the same
   precondition:

             ⊢ {s = (0 + i)[s + i/s]} s := s + i {s = 0 + i}


                 ⊢ {s + i = 0 + i} s := s + i {s = 0 + i}


                     ⊢ {s = 0} s := s + i {s = 0 + i}
From Floyd’s assignment rule to strongest postconditions



    ▶ It is not yet clear who introduced the concept of strongest
      postconditions, but Floyd discusses a related notion of
      “strongest verifiable consequents” in his 1967 paper.
From Floyd’s assignment rule to strongest postconditions



    ▶ It is not yet clear who introduced the concept of strongest
      postconditions, but Floyd discusses a related notion of
      “strongest verifiable consequents” in his 1967 paper.
    ▶ Idea: compute a postcondition predicate for a statement S by
      transforming the precondition P.
    ▶ The result is denoted sp(S, P) – the strongest postcondition
      which holds after executing S in a state satisfying P.
From Floyd’s assignment rule to strongest postconditions



    ▶ It is not yet clear who introduced the concept of strongest
      postconditions, but Floyd discusses a related notion of
      “strongest verifiable consequents” in his 1967 paper.
    ▶ Idea: compute a postcondition predicate for a statement S by
      transforming the precondition P.
    ▶ The result is denoted sp(S, P) – the strongest postcondition
      which holds after executing S in a state satisfying P.
    ▶ sp(S, P) is strongest in the sense that any other postcondition
      Q for a valid triple {P} S {Q} is implied by sp(S, P).
sp for Assignment


   The strongest postcondition calculus for assignment is:

               sp(x := e, P) = ∃v .(x = e[v /x]) ∧ P[v /x]

   Property: {P}x := e{Q} holds iff sp(x := e, P) → Q.
sp for Assignment


   The strongest postcondition calculus for assignment is:

               sp(x := e, P) = ∃v .(x = e[v /x]) ∧ P[v /x]

   Property: {P}x := e{Q} holds iff sp(x := e, P) → Q.


   Recall the weakest precondition definition for assignment:

                        wp(x := e, Q) = Q[e/x]

   Property: {P}x := e{Q} holds iff P → wp(x := e, Q).
Example

  Is {s = 0}s := s + i{s ≥ i} valid?
Example

  Is {s = 0}s := s + i{s ≥ i} valid?

  First, we compute sp(s := s + i, s = 0):
Example

  Is {s = 0}s := s + i{s ≥ i} valid?

  First, we compute sp(s := s + i, s = 0):


    sp(s := s + i, s = 0) = ∃v .(s = (s + i)[v /s]) ∧ (s = 0)[v /s]
                           = ∃v .(s = v + i) ∧ (v = 0)
                           ≡ ∃v .s = 0 + i ≡ s = 0 + i ≡ s = i.
Example

  Is {s = 0}s := s + i{s ≥ i} valid?

  First, we compute sp(s := s + i, s = 0):


    sp(s := s + i, s = 0) = ∃v .(s = (s + i)[v /s]) ∧ (s = 0)[v /s]
                           = ∃v .(s = v + i) ∧ (v = 0)
                           ≡ ∃v .s = 0 + i ≡ s = 0 + i ≡ s = i.

  Finally, we check whether sp(s := s + i, s = 0) → s ≥ i, that is:

                            s = i → s ≥ i.
Example

  Is {s = 0}s := s + i{s ≥ i} valid?

  First, we compute sp(s := s + i, s = 0):


    sp(s := s + i, s = 0) = ∃v .(s = (s + i)[v /s]) ∧ (s = 0)[v /s]
                           = ∃v .(s = v + i) ∧ (v = 0)
                           ≡ ∃v .s = 0 + i ≡ s = 0 + i ≡ s = i.

  Finally, we check whether sp(s := s + i, s = 0) → s ≥ i, that is:

                            s = i → s ≥ i.

  Since this is true, we have {s = 0}s := s + i{s ≥ i} valid.
sp for Sequences


   The definition of sp for sequences is:

                     sp(S1 ; S2 , P) = sp(S2 , sp(S1 , P))

   Note: sp(S1 , P) serves as precondition for S2 .
sp for Sequences


   The definition of sp for sequences is:

                     sp(S1 ; S2 , P) = sp(S2 , sp(S1 , P))

   Note: sp(S1 , P) serves as precondition for S2 .


   In contrast, the weakest precondition definition for sequences is:

                   wp(S1 ; S2 , Q) = wp(S1 , wp(S2 , Q))

   Note: wp(S2 , Q) serves as postcondition for S1 .
Example
  We want to compute: sp(i := i + 1; s := s + i, i = 0 ∧ s = 0).
Example
  We want to compute: sp(i := i + 1; s := s + i, i = 0 ∧ s = 0).

  Step 1:
                                                        
  sp(i := i + 1, i = 0 ∧ s = 0) = ∃v . i = (i + 1)[v /i] ∧ (i = 0 ∧ s = 0)[v /i]
                                                 
                                = ∃v . i = v + 1 ∧ (v = 0 ∧ s = 0)
Example
  We want to compute: sp(i := i + 1; s := s + i, i = 0 ∧ s = 0).

  Step 1:
                                                        
  sp(i := i + 1, i = 0 ∧ s = 0) = ∃v . i = (i + 1)[v /i] ∧ (i = 0 ∧ s = 0)[v /i]
                                                 
                                = ∃v . i = v + 1 ∧ (v = 0 ∧ s = 0)


   Step 2:
                                                   
   sp s := s + i, ∃v . i = v + 1 ∧ (v = 0 ∧ s = 0) =
                                                                  
    = ∃v ′ . s := (s + i)[v ′ /s] ∧ ∃v . i = v + 1 ∧ (v = 0 ∧ s = 0) [v ′ /s]
                                                  

                                                             
    = ∃v ′ . s := v ′ + i ∧ ∃v . i = v + 1 ∧ (v = 0 ∧ v ′ = 0)
                                             

    ≡ ∃v .∃v ′ . s := v ′ + i ∧ i = v + 1 ∧ (v = 0 ∧ v ′ = 0)
                                                           

    ≡ ∃v .∃v ′ . s := 0 + i ∧ i = 0 + 1 ∧ (v = 0 ∧ v ′ = 0)
                                                          

   ≡ s = i ∧ i = 1 ≡ s = 1 ∧ i = 1.
Skip



   The definition of sp for skip is:

                            sp(skip, P) = P
Skip



   The definition of sp for skip is:

                            sp(skip, P) = P


   Also recall that for wp we have

                            wp(skip, Q) = Q
Conditional Statement



   The definition of sp for the if-then-else is:

   sp(if C then S1 else S2 , P) = sp(S1 , P ∧ C ) ∨ sp(S2 , P ∧ ¬C )
Conditional Statement



   The definition of sp for the if-then-else is:

   sp(if C then S1 else S2 , P) = sp(S1 , P ∧ C ) ∨ sp(S2 , P ∧ ¬C )



   Recall that wlp for if-then-else is computed as:

wlp(if C then S1 else S2 , Q) = (C → wlp(S1 ,Q)) ∧ (¬C → wlp(S2 ,Q))
Example
  We compute sp(if x < 0 then m := −x else m := x, true), using

    sp(if C then S1 else S2 , P) = sp(S1 , P ∧ C ) ∨ sp(S2 , P ∧ ¬C )
Example
  We compute sp(if x < 0 then m := −x else m := x, true), using

    sp(if C then S1 else S2 , P) = sp(S1 , P ∧ C ) ∨ sp(S2 , P ∧ ¬C )


   ▶ First, we compute for S1 : m := −x with C : x < 0:

     sp(m := −x, true ∧ (x < 0)) =
           = ∃v .m = (−x)[v /m] ∧ (true ∧ (x < 0))[v /m]
           = ∃v .m = −x ∧ (true ∧ (x < 0)) ≡ m = −x ∧ x < 0.
Example
  We compute sp(if x < 0 then m := −x else m := x, true), using

    sp(if C then S1 else S2 , P) = sp(S1 , P ∧ C ) ∨ sp(S2 , P ∧ ¬C )


   ▶ First, we compute for S1 : m := −x with C : x < 0:

     sp(m := −x, true ∧ (x < 0)) =
           = ∃v .m = (−x)[v /m] ∧ (true ∧ (x < 0))[v /m]
           = ∃v .m = −x ∧ (true ∧ (x < 0)) ≡ m = −x ∧ x < 0.


   ▶ Then, we compute for S2 : m := x with ¬C : x ≥ 0:

      sp(m := x, true ∧ ¬(x < 0)) =
            = ∃v .m = (x)[v /m] ∧ (true ∧ ¬(x < 0))[v /m]
            = ∃v .m = x ∧ (true ∧ ¬(x < 0)) ≡ m = x ∧ x ≥ 0.
Example – continued



   So:
    ▶ sp(m := −x, true ∧ (x < 0)) = m = −x ∧ x < 0
    ▶ sp(m := x, true ∧ ¬(x < 0)) = m = x ∧ x ≥ 0
Example – continued



   So:
    ▶ sp(m := −x, true ∧ (x < 0)) = m = −x ∧ x < 0
    ▶ sp(m := x, true ∧ ¬(x < 0)) = m = x ∧ x ≥ 0


     sp(if x < 0 then m := −x else m := x, true) =
               = (m = −x ∧ x < 0) ∨ (m = x ∧ x ≥ 0)
Loops

  The definition of sp for the while loop is:
                                                      
  sp(while C do S, P) = sp while C do S, sp(S, P ∧ C ) ∨ (P ∧ ¬C )

  Note: strongest postcondition calculus only makes sense for partial
  correctness, since it captures the changes made to the program
  state after executing a statement.
Loops

  The definition of sp for the while loop is:
                                                      
  sp(while C do S, P) = sp while C do S, sp(S, P ∧ C ) ∨ (P ∧ ¬C )

  Note: strongest postcondition calculus only makes sense for partial
  correctness, since it captures the changes made to the program
  state after executing a statement.
   The definition of wlp for loops uses the invariants:


  wlp(while C inv:       I do S, Q) = I ∧                          
      ∀x1 , . . . , xk . (C ∧ I ) → wp(S, I ) ∧ (¬C ∧ I ) → Q [xi /wi ],
  where w1 , . . . , wk are variables modified in s, and x1 , . . . , xk are
  fresh variables.
Example
  We want to compute sp(while (i ≤ n) do i := i + 1, i = 0 ∧ n = 2).

  sp(while (i ≤ n) do i := i +1, n = 2) =
                                                                          
   = sp while (i ≤ n) do i := i +1, sp(i := i +1, i = 0 ∧ n = 2 ∧ (i ≤ n))
                                                     ∨ (i = 0 ∧ n = 2 ∧ i > n)
Example
  We want to compute sp(while (i ≤ n) do i := i + 1, i = 0 ∧ n = 2).

  sp(while (i ≤ n) do i := i +1, n = 2) =
                                                                          
   = sp while (i ≤ n) do i := i +1, sp(i := i +1, i = 0 ∧ n = 2 ∧ (i ≤ n))
                                                     ∨ (i = 0 ∧ n = 2 ∧ i > n)


                                                    
   = sp while (i ≤ n) do i := i +1, i = 1 ∧ n = 2 ∨ (i = 0 ∧ n = 2 ∧ i > n)
                                                                          
   = sp while (i ≤ n) do i := i +1, sp(i := i +1, i = 1 ∧ n = 2 ∧ (i ≤ n))
                              ∨ (i = 1 ∧ n = 2 ∧ i > n) ∨ (i = 0 ∧ n = 2 ∧ i > n)
Example
  We want to compute sp(while (i ≤ n) do i := i + 1, i = 0 ∧ n = 2).

  sp(while (i ≤ n) do i := i +1, n = 2) =
                                                                          
   = sp while (i ≤ n) do i := i +1, sp(i := i +1, i = 0 ∧ n = 2 ∧ (i ≤ n))
                                                     ∨ (i = 0 ∧ n = 2 ∧ i > n)


                                                    
   = sp while (i ≤ n) do i := i +1, i = 1 ∧ n = 2 ∨ (i = 0 ∧ n = 2 ∧ i > n)
                                                                          
   = sp while (i ≤ n) do i := i +1, sp(i := i +1, i = 1 ∧ n = 2 ∧ (i ≤ n))
                              ∨ (i = 1 ∧ n = 2 ∧ i > n) ∨ (i = 0 ∧ n = 2 ∧ i > n)


                                                           
   = sp while (i ≤ n) do i := i +1, i = 2 ∧ n = 2 ∧ (i ≤ n)
                              ∨ (i = 1 ∧ n = 2 ∧ i > n) ∨ (i = 0 ∧ n = 2 ∧ i > n)
   = ...
Example – continued

                                                                 
   . . . = sp while (i ≤ n) do i := i +1, i = 3 ∧ n = 2 ∧ (i ≤ n)
   ∨ (i = 2 ∧ n = 2 ∧ i > n) ∨ (i = 1 ∧ n = 2 ∧ i > n) ∨ (i = 0 ∧ n = 2 ∧ i > n)
Example – continued

                                                                 
   . . . = sp while (i ≤ n) do i := i +1, i = 3 ∧ n = 2 ∧ (i ≤ n)
   ∨ (i = 2 ∧ n = 2 ∧ i > n) ∨ (i = 1 ∧ n = 2 ∧ i > n) ∨ (i = 0 ∧ n = 2 ∧ i > n)

                                                                          
   = sp while (i ≤ n) do i := i +1, sp(i := i +1, i = 3 ∧ n = 2 ∧ (i ≤ n))
                            ∨ (i = 3 ∧ n = 2 ∧ i > n) ∨ (i = 2 ∧ n = 2 ∧ i > n)
                            ∨ (i = 1 ∧ n = 2 ∧ i > n) ∨ (i = 0 ∧ n = 2 ∧ i > n)
Example – continued

                                                                 
   . . . = sp while (i ≤ n) do i := i +1, i = 3 ∧ n = 2 ∧ (i ≤ n)
   ∨ (i = 2 ∧ n = 2 ∧ i > n) ∨ (i = 1 ∧ n = 2 ∧ i > n) ∨ (i = 0 ∧ n = 2 ∧ i > n)

                                                                          
   = sp while (i ≤ n) do i := i +1, sp(i := i +1, i = 3 ∧ n = 2 ∧ (i ≤ n))
                            ∨ (i = 3 ∧ n = 2 ∧ i > n) ∨ (i = 2 ∧ n = 2 ∧ i > n)
                            ∨ (i = 1 ∧ n = 2 ∧ i > n) ∨ (i = 0 ∧ n = 2 ∧ i > n)


   ...(i = 3 ∧ n = 2 ∧ i > n) ∨ (i = 2 ∧ n = 2 ∧ i > n)
                            ∨ (i = 1 ∧ n = 2 ∧ i > n) ∨ (i = 0 ∧ n = 2 ∧ i > n)
Example – continued

                                                                 
   . . . = sp while (i ≤ n) do i := i +1, i = 3 ∧ n = 2 ∧ (i ≤ n)
   ∨ (i = 2 ∧ n = 2 ∧ i > n) ∨ (i = 1 ∧ n = 2 ∧ i > n) ∨ (i = 0 ∧ n = 2 ∧ i > n)

                                                                          
   = sp while (i ≤ n) do i := i +1, sp(i := i +1, i = 3 ∧ n = 2 ∧ (i ≤ n))
                            ∨ (i = 3 ∧ n = 2 ∧ i > n) ∨ (i = 2 ∧ n = 2 ∧ i > n)
                            ∨ (i = 1 ∧ n = 2 ∧ i > n) ∨ (i = 0 ∧ n = 2 ∧ i > n)


   ...(i = 3 ∧ n = 2 ∧ i > n) ∨ (i = 2 ∧ n = 2 ∧ i > n)
                            ∨ (i = 1 ∧ n = 2 ∧ i > n) ∨ (i = 0 ∧ n = 2 ∧ i > n)
   Note 1: each conjunction corresponds to a particular program path.
Example – continued

                                                                 
   . . . = sp while (i ≤ n) do i := i +1, i = 3 ∧ n = 2 ∧ (i ≤ n)
   ∨ (i = 2 ∧ n = 2 ∧ i > n) ∨ (i = 1 ∧ n = 2 ∧ i > n) ∨ (i = 0 ∧ n = 2 ∧ i > n)

                                                                          
   = sp while (i ≤ n) do i := i +1, sp(i := i +1, i = 3 ∧ n = 2 ∧ (i ≤ n))
                            ∨ (i = 3 ∧ n = 2 ∧ i > n) ∨ (i = 2 ∧ n = 2 ∧ i > n)
                            ∨ (i = 1 ∧ n = 2 ∧ i > n) ∨ (i = 0 ∧ n = 2 ∧ i > n)


   ...(i = 3 ∧ n = 2 ∧ i > n) ∨ (i = 2 ∧ n = 2 ∧ i > n)
                            ∨ (i = 1 ∧ n = 2 ∧ i > n) ∨ (i = 0 ∧ n = 2 ∧ i > n)
   Note 1: each conjunction corresponds to a particular program path.
   Note 2: the last 3 conjunctions are false suggesting impossible executions.
Example – continued

                                                                 
   . . . = sp while (i ≤ n) do i := i +1, i = 3 ∧ n = 2 ∧ (i ≤ n)
   ∨ (i = 2 ∧ n = 2 ∧ i > n) ∨ (i = 1 ∧ n = 2 ∧ i > n) ∨ (i = 0 ∧ n = 2 ∧ i > n)

                                                                          
   = sp while (i ≤ n) do i := i +1, sp(i := i +1, i = 3 ∧ n = 2 ∧ (i ≤ n))
                            ∨ (i = 3 ∧ n = 2 ∧ i > n) ∨ (i = 2 ∧ n = 2 ∧ i > n)
                            ∨ (i = 1 ∧ n = 2 ∧ i > n) ∨ (i = 0 ∧ n = 2 ∧ i > n)


   ...(i = 3 ∧ n = 2 ∧ i > n) ∨ (i = 2 ∧ n = 2 ∧ i > n)
                            ∨ (i = 1 ∧ n = 2 ∧ i > n) ∨ (i = 0 ∧ n = 2 ∧ i > n)
   Note 1: each conjunction corresponds to a particular program path.
   Note 2: the last 3 conjunctions are false suggesting impossible executions.
   Note 3: at the end of the execution, the program state satisfies
   i = 3 ∧ n = 2 ∧ i > n.
Summary of Strongest Postcondition Calculus
    ▶ Assignment:

                sp(x := e, P) = ∃v .(x = e[v /x]) ∧ P[v /x]

    ▶ Sequential Composition:

                     sp(S1 ; S2 , P) = sp(S2 , sp(S1 , P))

    ▶ Skip:
                             sp(skip, P) = P
    ▶ Conditional:

      sp(if C then S1 else S2 , P) = sp(S1 , P ∧ C ) ∨ sp(S2 , P ∧ ¬C )

    ▶ While Loop:
                                                      
      sp(while C doS, Q) = sp while C doS, sp(S, P∧C ) ∨(P∧¬C )
Properties


   Theorem
   A Hoare triple {P} S {Q} is valid if and only if |= sp(S, P) → Q.


   Theorem
   A Hoare triple {P} S {Q} is valid if and only if |= P → wp(S, Q).

   Remarks:
    ▶ |= sp(S, P) → Q iff {P} S {Q} is valid iff |= P → wp(S, Q).
    ▶ wp is more appropriate for automated verification, as it supports
      loop invariants and can manage termination through variants.
    ▶ Strongest postcondition is often aligned with symbolic execution,
      and it is less suitable for verification tools.
Strongest Postcondition and Symbolic Execution



    ▶ Formally, sp(S, P) is a condition satisfied by the program
      state resulted after S is executed.
Strongest Postcondition and Symbolic Execution



    ▶ Formally, sp(S, P) is a condition satisfied by the program
      state resulted after S is executed.
    ▶ Symbolic execution corresponds to symbolically executing the
      program, that is, we run the program symbolic inputs (i.e.,
      symbolic states) - described by predicates - instead of
      concrete inputs (i.e., concrete states).
Strongest Postcondition and Symbolic Execution



    ▶ Formally, sp(S, P) is a condition satisfied by the program
      state resulted after S is executed.
    ▶ Symbolic execution corresponds to symbolically executing the
      program, that is, we run the program symbolic inputs (i.e.,
      symbolic states) - described by predicates - instead of
      concrete inputs (i.e., concrete states).
    ▶ When computing strongest postconditions, we aim to modify
      the precondition s.t. it captures the changes made to the
      program states by the executed program.
Symbolic execution by example




     read n;
     s = 0;
     while n > 0 do
        s = s + n;
        n = n − 1;
     end while;
Symbolic execution by example


                      Symbolic execution with symbolic input x

     read n;
     s = 0;
     while n > 0 do
        s = s + n;
        n = n − 1;
     end while;
Symbolic execution by example


                      Symbolic execution with symbolic input x

     read n;           ▶ x ≤0
     s = 0;              state: s = 0
     while n > 0 do
        s = s + n;
        n = n − 1;
     end while;
Symbolic execution by example


                      Symbolic execution with symbolic input x

     read n;           ▶ x ≤0
     s = 0;              state: s = 0
     while n > 0 do
                       ▶ x > 0 ∧ (x − 1) ≤ 0
        s = s + n;
                         state: s = x
        n = n − 1;
     end while;
Symbolic execution by example


                      Symbolic execution with symbolic input x

     read n;           ▶ x ≤0
     s = 0;              state: s = 0
     while n > 0 do
                       ▶ x > 0 ∧ (x − 1) ≤ 0
        s = s + n;
                         state: s = x
        n = n − 1;
     end while;        ▶ x > 0 ∧ (x − 1) > 0 ∧ (x − 2) ≤ 0
                         state: s = x + (x − 1)
Symbolic execution by example


                      Symbolic execution with symbolic input x

     read n;           ▶ x ≤0
     s = 0;              state: s = 0
     while n > 0 do
                       ▶ x > 0 ∧ (x − 1) ≤ 0
        s = s + n;
                         state: s = x
        n = n − 1;
     end while;        ▶ x > 0 ∧ (x − 1) > 0 ∧ (x − 2) ≤ 0
                         state: s = x + (x − 1)
                       ▶ ...
Key concepts


       • Symbolic values   x, . . .
Key concepts


       • Symbolic values   x, . . .
       • Path condition    x ≤ 0, x > 0 ∧ x − 1 ≤ 0, . . .
Key concepts


       • Symbolic values           x, . . .
       • Path condition            x ≤ 0, x > 0 ∧ x − 1 ≤ 0, . . .

                                               read n;
                                                      x ∈Z
                                               s = 0;
                                                      x ∈Z

                                   while (n > 0) { . . . }




                                                       x
                                           0
       • Symbolic execution tree




                                                           >
                                           ≤




                                                           0
                                       x
                                       •                   { ...}




                                                       0



                                                                x−
                                                      1≤




                                                                    1>
                                                 x−




                                                                     0
                                                  •                  ...
Strongest Postcondition and Symbolic Execution



    ▶ Symbolic execution is a technique that allows one to execute
      programs with symbolic values rather than concrete ones.
Strongest Postcondition and Symbolic Execution



    ▶ Symbolic execution is a technique that allows one to execute
      programs with symbolic values rather than concrete ones.
    ▶ It generates symbolic expressions representing the program’s
      state and path conditions.
Strongest Postcondition and Symbolic Execution



    ▶ Symbolic execution is a technique that allows one to execute
      programs with symbolic values rather than concrete ones.
    ▶ It generates symbolic expressions representing the program’s
      state and path conditions.
    ▶ The path conditions generated during symbolic execution
      represent the conditions under which each path is feasible.
Strongest Postcondition and Symbolic Execution



    ▶ Symbolic execution is a technique that allows one to execute
      programs with symbolic values rather than concrete ones.
    ▶ It generates symbolic expressions representing the program’s
      state and path conditions.
    ▶ The path conditions generated during symbolic execution
      represent the conditions under which each path is feasible.
    ▶ The final symbolic state, combined with the path conditions,
      forms the strongest postcondition for the given program and
      initial condition.
Desired Properties and Difficulties
   Symbolic execution returns path conditions instead of values.
Desired Properties and Difficulties
   Symbolic execution returns path conditions instead of values.
   Desired Properties:
    ▶ Coverage (soundness): each concrete execution is covered by
        a symbolic execution.
    ▶ Precision (completeness): each symbolic execution captures at
        least one concrete execution.
Desired Properties and Difficulties
   Symbolic execution returns path conditions instead of values.
   Desired Properties:
    ▶ Coverage (soundness): each concrete execution is covered by
        a symbolic execution.
    ▶ Precision (completeness): each symbolic execution captures at
        least one concrete execution.
   Difficulties:
    ▶ the path explosion problem: the number of paths in a
         program grows exponentially.
Desired Properties and Difficulties
   Symbolic execution returns path conditions instead of values.
   Desired Properties:
    ▶ Coverage (soundness): each concrete execution is covered by
        a symbolic execution.
    ▶ Precision (completeness): each symbolic execution captures at
        least one concrete execution.
   Difficulties:
    ▶ the path explosion problem: the number of paths in a
         program grows exponentially.
    ▶ requires various mechanisms to tackle the big number of
         states (e.g., eliminate some of them using automated
         reasoning, employ abstract interpretation, etc.).
Desired Properties and Difficulties
   Symbolic execution returns path conditions instead of values.
   Desired Properties:
    ▶ Coverage (soundness): each concrete execution is covered by
        a symbolic execution.
    ▶ Precision (completeness): each symbolic execution captures at
        least one concrete execution.
   Difficulties:
    ▶ the path explosion problem: the number of paths in a
         program grows exponentially.
    ▶ requires various mechanisms to tackle the big number of
         states (e.g., eliminate some of them using automated
         reasoning, employ abstract interpretation, etc.).
    ▶ dealing with loops and recursion is a known problem.
    ▶ scalability and performance remain an issue in practice.
Tools based on Symbolic Execution




    ▶ KLEE: https://klee.github.io/
    ▶ S2E (Selective Symbolic Execution): https://s2e.systems/
    ▶ Angr: https://angr.io/
    ▶ SymCC: https://github.com/eurecom-s3/symcc
    ▶ Manticore: https://github.com/trailofbits/manticore
    ▶ Driller: https://github.com/shellphish/driller
