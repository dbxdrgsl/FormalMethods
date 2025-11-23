    Operational Semantics
IMP Language and Big-Step Semantics




         October 16, 2025
Overview

  Introduction to Semantics

  The IMP Language
     IMP in Dafny

  Operational Semantics
    Arithmetic Expressions
    Boolean Expressions
    Statements

  While Loop Example

  Implementation in Dafny

  Verification Example

  Summary
Formal Methods and Semantics
   Formal methods provide instruments for defining and reasoning
   about programming languages.

   The semantics of a language — the precise meaning of its
   constructs.

   Three main approaches to semantics:
    ▶ Operational semantics: Defines meaning through execution
       steps or evaluation rules
    ▶ Denotational semantics: Maps programs to mathematical
       objects in a semantic domain
    ▶ Axiomatic semantics: Program behavior captured through
       logical assertions and proof rules

   Focus of this presentation: Operational semantics (big-step)
Introducing IMP

   IMP: A minimal imperative programming language

   Why IMP?
    ▶ Includes fundamental control flow constructs (sequencing,
      conditionals, loops)
    ▶ Simple enough for clear, manageable formal definitions and
      proofs
    ▶ Expressive enough to write non-trivial programs
    ▶ Techniques extend naturally to more complex languages

   Despite its simplicity, IMP captures the essential features of
   imperative programming.
IMP Syntax: BNF Grammar


         n∈Z
         x ∈ Id

         a ::= n | x | a1 + a2 | a1 × a2
         b ::= true | false | a1 < a2 | ¬b | b1 ∧ b2
        S ::= skip | x := a | S1 ; S2 | if b then S1 else S2
             | while b do S

  where:
   ▶ a ranges over arithmetic expressions
   ▶ b ranges over boolean expressions
   ▶ S ranges over statements
Identifiers in Dafny




 1   datatype Id =
 2       x | y | z | s | t | u | v | n | m | i | j | g


     We represent identifiers as an enumerated datatype for simplicity.

     Alternatively, we could use strings.
Arithmetic Expressions in Dafny
     BNF:

                       a ::= n | x | a1 + a2 | a1 × a2


     Dafny:
 1   datatype AExp =
 2       Num ( int )
 3     | Var ( Id )
 4     | Plus ( AExp , AExp )
 5     | Times ( AExp , AExp )


     Examples:
      ▶ Num(5) represents the constant 5
      ▶ Var(x) represents the variable x
      ▶ Plus(Var(x), Num(2)) represents x + 2
Boolean Expressions in Dafny
     BNF:

               b ::= true | false | a1 < a2 | ¬b | b1 ∧ b2


     Dafny:
 1   datatype BExp =
 2     | B ( bool ) // true or false , but this is easier
 3     | Less ( AExp , AExp )
 4     | Not ( BExp )
 5     | And ( BExp , BExp )


     Examples:
      ▶ B(true) represents the constant true
      ▶ Less(Num(0), Var(x)) represents 0 < x
      ▶ Not(B(false)) represents ¬false
Statements in Dafny
     BNF:
              S ::= skip | x := a | S1 ; S2 | if b then S1 else S2
                  | while b do S

     Dafny:
 1   datatype Stmt =
 2       Skip
 3     | Assign ( Id , AExp )
 4     | Seq ( Stmt , Stmt )
 5     | If ( BExp , Stmt , Stmt )
 6     | While ( BExp , Stmt )


     Examples:
      ▶ Skip does nothing
      ▶ Assign(x, Num(5)) represents x := 5
      ▶ Seq(s1, s2) represents sequential composition s1 ; s2
States and Configurations

   State: A partial function from variables to values

                               σ : Id ⇀ Z


   Configuration: All information needed to describe what a
   program is doing at a particular point in time.

   For IMP, a configuration is a pair:

                                  ⟨⋆, σ⟩

   where σ is the program state and ⋆ ∈ {Stmt, AExp, BExp, Id, Z}.

   Or simply ⟨∗⟩ where ∗ ∈ Z when state is irrelevant.
Configuration Examples
    ▶ An arithmetic expression configuration:

                               ⟨x + 2, {x 7→ 5}⟩

    ▶ A boolean expression configuration:

                           ⟨0 < x, {x 7→ 3, y 7→ 7}⟩

    ▶ A statement configuration (assignment):

                            ⟨x := y + 1, {y 7→ 10}⟩

    ▶ A statement configuration (loop) :

                ⟨while (0 < x) do x := x + (−1), {x 7→ 2}⟩

    ▶ A final value configuration:
                                      ⟨7⟩
States and Configurations in Dafny




 1   type State = map < Id , int >
 2   type Configuration = ( Stmt , State )



      ▶ A State is a map from identifiers to integers (corresponds to
        partial functions σ : Id ⇀ Z)
      ▶ A Configuration is a pair of a statement and a state
Big-Step Semantics: Arithmetic Expressions


   The notation
                              ⟨a, σ⟩ ⇓ ⟨n⟩
   means that “expression a evaluates to value n in state σ”

   Inference Rules:
                                         ·
                          Const
                                   ⟨n, σ⟩ ⇓ ⟨n⟩


                                       ·      x ∈σ
                      Lookup
                                ⟨x, σ⟩ ⇓ σ(x)
Arithmetic Operations



                         ⟨a1 , σ⟩ ⇓ n1      ⟨a2 , σ⟩ ⇓ n2
                   Add
                           ⟨a1 + a2 , σ⟩ ⇓ ⟨n1 +Z n2 ⟩



                         ⟨a1 , σ⟩ ⇓ n1     ⟨a2 , σ⟩ ⇓ n2
                   Mul
                           ⟨a1 × a2 , σ⟩ ⇓ ⟨n1 ·Z n2 ⟩

   Note: the + symbol is part of the syntax of IMP, but its semantics
   is given using +Z .
Evaluating Arithmetic Expressions in Dafny


 1   function evalAExp ( a : AExp , s : State ) : int {
 2     match a {
 3       case Num ( n ) = > n
 4       case Var ( someVar ) = >
 5         if someVar in s then s [ someVar ] else 0
 6       case Plus ( a1 , a2 ) = >
 7         evalAExp ( a1 , s ) + evalAExp ( a2 , s )
 8       case Times ( a1 , a2 ) = >
 9         evalAExp ( a1 , s ) * evalAExp ( a2 , s )
10     }
11   }

     This function directly implements the inference rules.
Example: Arithmetic Derivation



   Goal: Show that ⟨x + 2, σ⟩ ⇓ ⟨4⟩ where σ(x) = 2


                       ·     x ∈ σ Const             ·
           Lookup
                  ⟨x, σ⟩ ⇓ 2                   ⟨2, σ⟩ ⇓ ⟨2⟩
              Add
                              ⟨x + 2, σ⟩ ⇓ ⟨4⟩

   This derivation tree use the inference rules for arithmetic
   expressions.
Big-Step Semantics: Boolean Expressions


                                      ·
                 BTrue
                             ⟨true, σ⟩ ⇓ ⟨true⟩


                                     ·
                BFalse
                           ⟨false, σ⟩ ⇓ ⟨false⟩



                    ⟨a1 , σ⟩ ⇓ ⟨n1 ⟩     ⟨a2 , σ⟩ ⇓ ⟨n2 ⟩
             Less
                        ⟨a1 < a2 , σ⟩ ⇓ (n1 <Z n2 )
Boolean Operations




                                ⟨b, σ⟩ ⇓ ⟨v ⟩
                       Not
                               ⟨¬b, σ⟩ ⇓ ⟨!v ⟩



                     ⟨b1 , σ⟩ ⇓ ⟨v1 ⟩     ⟨b2 , σ⟩ ⇓ ⟨v2 ⟩
             And
                          ⟨b1 ∧ b2 , σ⟩ ⇓ ⟨v1 && v2 ⟩
Evaluating Boolean Expressions in Dafny



 1   function evalBExp ( b : BExp , s : State ) : bool {
 2     match b {
 3       case B ( bval ) = > bval
 4       case Less ( a1 , a2 ) = >
 5         evalAExp ( a1 , s ) < evalAExp ( a2 , s )
 6       case Not ( b1 ) = > ! evalBExp ( b1 , s )
 7       case And ( b1 , b2 ) = >
 8         evalBExp ( b1 , s ) && evalBExp ( b2 , s )
 9     }
10   }
Example: Boolean Derivation




   Goal: Show that ⟨0 < x, σ⟩ ⇓ ⟨true⟩ where σ(x) = 2


                     ·                          ·      x ∈σ
         Const                 Lookup
               ⟨0, σ⟩ ⇓ ⟨0⟩               ⟨x, σ⟩ ⇓ ⟨2⟩
          Less
                         ⟨0 < x, σ⟩ ⇓ ⟨true⟩
Big-Step Sem. Statements (1): skip, assignment, sequence


                                      ·
                      Skip
                               ⟨skip, σ⟩ ⇓ ⟨σ⟩



                                 ⟨a, σ⟩ ⇓ ⟨n⟩
               Assign
                           ⟨x := a, σ⟩ ⇓ ⟨σ[x 7→ n]⟩



                   ⟨S1 , σ⟩ ⇓ ⟨σ ′′ ⟩      ⟨S2 , σ ′′ ⟩ ⇓ ⟨σ ′ ⟩
             Seq
                             ⟨S1 ; S2 , σ⟩ ⇓ ⟨σ ′ ⟩
Big-Step Sem. Statements (2): decisional statements




                      ⟨b, σ⟩ ⇓ ⟨true⟩   ⟨S1 , σ⟩ ⇓ ⟨σ ′ ⟩
           If-True
                      ⟨if b then S1 else S2 , σ⟩ ⇓ ⟨σ ′ ⟩



                      ⟨b, σ⟩ ⇓ ⟨false⟩    ⟨S2 , σ⟩ ⇓ ⟨σ ′ ⟩
           If-False
                       ⟨if b then S1 else S2 , σ⟩ ⇓ ⟨σ ′ ⟩
Big-Step Sem. Statements (3): while loop



                                          ⟨b, σ⟩ ⇓ ⟨false⟩
                       While-False
                                       ⟨while b do S, σ⟩ ⇓ ⟨σ⟩




                   ⟨b, σ⟩ ⇓ ⟨true⟩      ⟨S, σ⟩ ⇓ ⟨σ ′′ ⟩    ⟨while b do S, σ ′′ ⟩ ⇓ ⟨σ ′ ⟩
   While-True
                                        ⟨while b do S, σ⟩ ⇓ ⟨σ ′ ⟩


   Note: The while rule is recursive; it allows non-terminating loops
Example Program

  Consider the program:

                   while (0 < x) do x := x + (−1)


  Initial state: σ0 = {x 7→ 2}

  Goal: Show that execution terminates in state σ2 = {x 7→ 0}

  Notation:
   ▶ W = while (0 < x) do x := x + (−1)
   ▶ S = x := x + (−1)
   ▶ σ0 = {x 7→ 2}, σ1 = {x 7→ 1}, σ2 = {x 7→ 0}
First Iteration: Condition



   First iteration (σ0 → σ1 ): Loop executes for the first time, x
   decreases by 1.

   The condition of the loop:
                      ·                            ·       x ∈ σ0
         Const                   Lookup
               ⟨0, σ0 ⟩ ⇓ ⟨0⟩               ⟨x, σ0 ⟩ ⇓ ⟨2⟩
          Less
                          ⟨0 < x, σ0 ⟩ ⇓ ⟨true⟩
First Iteration: Body




   The first execution of the body: σ1 = σ0 [x 7→ 1].
                     ·       x ∈ σ0 Const                ·
       Lookup
              ⟨x, σ0 ⟩ ⇓ ⟨2⟩                     ⟨−1, σ0 ⟩ ⇓ ⟨−1⟩
          Add
                             ⟨x + (−1), σ0 ⟩ ⇓ ⟨1⟩
                   Assign
                                ⟨S, σ0 ⟩ ⇓ ⟨σ1 ⟩
Second Iteration: Condition




   Second iteration (σ1 → σ2 ): Loop executes again, x becomes 0.

   The condition of the loop:
                     ·                            ·       x ∈ σ1
        Const                   Lookup
              ⟨0, σ1 ⟩ ⇓ ⟨0⟩               ⟨x, σ1 ⟩ ⇓ ⟨1⟩
         Less
                         ⟨0 < x, σ1 ⟩ ⇓ ⟨true⟩
Second Iteration: Body




   The second execution of the body: σ2 = σ1 [x 7→ 0]
                    ·       x ∈ σ1 Const                ·
      Lookup
             ⟨x, σ1 ⟩ ⇓ ⟨1⟩                     ⟨−1, σ1 ⟩ ⇓ ⟨−1⟩
         Add
                            ⟨x + (−1), σ1 ⟩ ⇓ ⟨0⟩
                  Assign
                               ⟨S, σ1 ⟩ ⇓ ⟨σ2 ⟩
Loop Termination




   Loop termination (at σ2 ): The condition is now false.


                     ·                              ·       x ∈ σ2
        Const                   Lookup
              ⟨0, σ2 ⟩ ⇓ ⟨0⟩                 ⟨x, σ2 ⟩ ⇓ ⟨0⟩
         Less
                        ⟨0 < x, σ2 ⟩ ⇓ ⟨false⟩
         While-False
                            ⟨W , σ2 ⟩ ⇓ ⟨σ2 ⟩
Implementation Challenges




   Problem: Implementing statement evaluation as a (terminating)
   function in Dafny is problematic due to potentially non-terminating
   while loops.

   The decreases clause cannot be provided for arbitrary loops.

   We need a different approach!
Naive Implementation: non-termination issue


 1   function execStmt ( stmt : Stmt , s : State ) : State
 2       decreases ? // <-- cannot provide a decreases clause
 3   {
 4       match stmt {
 5         case Skip = > s
 6         case Assign ( someVar , a ) = >
 7           s [ someVar := evalAExp (a , s ) ]
 8         case Seq ( s1 , s2 ) = >
 9           execStmt ( s2 , execStmt ( s1 , s ) )
10         case If (b , s1 , s2 ) = >
11           if evalBExp (b , s ) then execStmt ( s1 , s )
12           else execStmt ( s2 , s )
13         case While (b , body ) = >
14           if evalBExp (b , s )
15           then execStmt ( While (b , body ) , execStmt ( body , s ) )
16           else s
17       }
18   }


     Issue: Cannot prove termination for While case!
Solution: define a relation instead of a function

   Instead of a function, we use a ghost predicate with a gas
   parameter:

    ▶ The gas parameter g : N decreases with each recursive call
    ▶ Ensures termination of the predicate definition
    ▶ Represents a bound on computation steps when the statement
      under evaluation does not structurally decrease
    ▶ Predicate: evalStmt(stmt, s, s ′ , g ) – “stmt evolves from state s
       to s ′ in at most g steps”

   This approach separates:
    ▶ Semantics (what the program means)
    ▶ Termination (whether computation halts)
Relational Semantics: Skip and Assign

 1   ghost predicate evalStmt ( stmt : Stmt , s : State ,
 2                              s1 : State , g : nat )
 3     decreases stmt , g
 4   {
 5      match stmt
 6      case Skip = >
 7         g == 1 && s == s1
 8
 9         case Assign ( myVar , ae ) = >
10          g == 1 && s [ myVar := evalAExp ( ae , s ) ] == s1
11   ...


      ▶ Skip: Requires exactly 1 unit of gas, state unchanged
      ▶ Assign: Requires exactly 1 unit of gas, updates state
Relational Semantics: Seq and If

 1   ...
 2         case Seq ( stmt1 , stmt2 ) = >
 3             exists g0 : nat , s_tmp : State ::
 4                  0 < g0 < g &&
 5                  evalStmt ( stmt1 , s , s_tmp , g0 ) &&
 6                  evalStmt ( stmt2 , s_tmp , s1 , g - g0 )
 7
 8         case If (b , stmt1 , stmt2 ) = >
 9              if evalBExp (b , s )
10              then evalStmt ( stmt1 , s , s1 , g )
11              else evalStmt ( stmt2 , s , s1 , g )
12   ...


      ▶ Seq: Splits gas between two statements via intermediate state
      ▶ If: Uses full gas for chosen branch based on condition
Relational Semantics: While

 1   ...
 2          case While (b , body ) = >
 3               if evalBExp (b , s )
 4               then exists s2 : State , g0 : nat ::
 5                        0 < g0 < g &&
 6                        evalStmt ( body , s , s2 , g0 ) &&
 7                        evalStmt ( stmt , s2 , s1 , g - g0 )
 8               else g == 1 && s1 == s
 9   }


         ▶ If condition is true: execute body, then recursively evaluate
           loop with remaining gas
         ▶ If condition is false: terminate immediately (1 gas unit)
         ▶ Gas decreases, ensuring termination of the predicate
Verifying the While Loop


   We can now prove that specific programs terminate with expected
   results!

   The program gets executed directly using the formal semantics.

   Goal:
   Prove that while (0 < x) do x := x + (−1) starting from
   σ0 = {x 7→ 2} terminates in σ2 = {x 7→ 0} using 3 gas units.

   The proof in the next slides corresponds to the derivation we
   constructed earlier.
Verification Lemma (1/3)


 1   lemma loop_to_zero ()
 2       ensures evalStmt (
 3           While ( Less ( Num (0) , Var ( x ) ) ,
 4                     Assign (x , Plus ( Var ( x ) , Num ( -1) ) )
 5                   ) ,
 6           map [ x := 2] ,
 7           map [ x := 0] ,
 8           3)
 9   {
10       var while_stmt :=
11           While ( Less ( Num (0) , Var ( x ) ) ,
12                     Assign (x , Plus ( Var ( x ) , Num ( -1) ) ) ) ;
13       var cond := Less ( Num (0) , Var ( x ) ) ;
14       var body := Assign (x , Plus ( Var ( x ) , Num ( -1) ) ) ;
15       var aexp := Plus ( Var ( x ) , Num ( -1) ) ;
16       var sigma := map [ x := 2];
17       var sigma1 := sigma [ x := 1];
18       var sigma2 := sigma1 [ x := 0];
19   ...
Verification Lemma (2/3)


 1   ...
 2         // calculational proof
 3         calc <== {
 4           evalStmt ( while_stmt , sigma , sigma2 , 3) ;
 5
 6           evalBExp ( cond , sigma ) &&
 7               evalStmt ( body , sigma , sigma1 , 1) &&
 8               evalStmt ( while_stmt , sigma1 , sigma2 , 2) ;
 9               { assert evalAExp ( aexp , sigma ) == 1; }
10
11           evalAExp ( aexp , sigma ) == 1 &&
12               evalStmt ( while_stmt , sigma1 , sigma2 ,2) ;
13   ...




     The calc <== construct shows logical chain of reasoning.
     Each step follows from the previous by inference rules.
Verification Lemma (3/3)



 1   ...
 2           evalBExp ( cond , sigma1 ) &&
 3             evalStmt ( body , sigma1 , sigma2 , 1) &&
 4             evalStmt ( while_stmt , sigma2 , sigma2 , 1) ;
 5
 6           evalAExp ( aexp , sigma1 ) == 0;
 7
 8           true ;
 9       }
10
11       assert evalAExp ( aexp , sigma1 ) == 0;
12   }




     Key insight: The calculational proof mirrors the operational
     semantics derivation tree structure!
Understanding Calculational Proofs

   What does calc <== { ...        } do?

   A calculational proof shows a logical chain where each step follows
   from the previous.

    ▶ evalStmt (while stmt, sigma, sigma2, 3);
       Root of derivation tree
    ▶ evalBExp(cond, sigma) && evalStmt(body, ...)               &&
      evalStmt(while stmt, ...)
       Captures premises for While-True rule
    ▶ Intermediate assertions guide the SMT solver
    ▶ Each line represents applying an inference rule
Takeaways

  Operational Semantics:
   ▶ Defines meaning through execution steps
    ▶ Uses inference rules to specify evaluation
    ▶ Provides a foundation for reasoning about programs

  Big-Step Semantics:
   ▶ Relates initial and final configurations directly
    ▶ Compositional: meaning of compound constructs from parts
    ▶ Can be formalized and verified in Dafny
    ▶ Programs can be executed using formal operational semantics
    ▶ Sometimes, the interpreter generated from an operational
      semantics is not fast enough, but it can serve as a reference
      implementation for compilers or interpreters
Implementation Strategy

   Challenges:
    ▶ While loops may not terminate
    ▶ Cannot write direct recursive functions
    ▶ Need to ensure termination of definitions

   Solutions:
    ▶ Use relational semantics (predicates, not functions)
    ▶ Add gas parameter to bound recursion
    ▶ Separate semantics from termination concerns
    ▶ Verify specific programs with explicit gas amounts

   This approach extends to more complex languages and properties!
From Theory to Practice


   What we’ve achieved:
    1. Formal specification of IMP syntax
    2. Big-step operational semantics via inference rules
    3. Implementation in Dafny with verification support
    4. Concrete example: verified while loop execution

   Next steps:
    ▶ Axiomatic semantics (Hoare Logic)
    ▶ Program verification techniques
    ▶ Proving program properties (correctness, termination)
Connections to Broader Topics



    ▶ Program verification: Proving programs satisfy specifications
    ▶ Compiler correctness: Showing optimizations preserve
      meaning
    ▶ Language design: Precise understanding of new features
    ▶ Static analysis: Sound approximations of program behavior
    ▶ Better software engineering: Rigorous engineering practices

   Operational semantics provides the mathematical foundation for
   reasoning about what programs actually do.
     Questions?
Thank you for your attention!
