            Operational Semantics of a Simple Imperative Language∗
                                                – lecture notes –


   Formal methods provide instruments for defining and reasoning about programming languages.
A key aspect of this is specifying the semantics of a language—the precise meaning of its constructs.
There are three main approaches to semantics:

        • Operational semantics: Defines meaning through execution steps or evaluation rules

        • Denotational semantics: Maps programs to mathematical objects in a semantic domain

        • Axiomatic semantics: Program behavior is captured through logical assertions and proof
          rules

    In these notes, we focus on operational semantics, specifically the big-step (or natural) semantics
style. Axiomatic semantics, including Hoare Logic, will be addressed in a different document.


1        The IMP Language
To illustrate these concepts, we introduce IMP, a minimal imperative programming language.
Despite its simplicity, IMP captures the essential features of imperative programming: arithmetic
and boolean expressions, variable assignment, sequential composition, conditional branching, and
loops.
   The syntax of IMP is defined by the following BNF grammar:


                     n∈Z
                     x ∈ Id

                     a ::= n | x | a1 + a2 | a1 × a2
                     b ::= true | false | a1 < a2 | ¬b | b1 ∧ b2
                     S ::= skip | x := a | S1 ; S2 | if b then S1 else S2 | while b do S

        where a ranges over arithmetic expressions, b over boolean expressions, and S over statements.
        IMP is sufficient for our purposes because:
        • It includes the fundamental control flow constructs (sequencing, conditionals, loops)

        • It is simple enough to allow clear, manageable formal definitions and proofs

        • It is expressive enough to write non-trivial programs

        • The techniques developed for IMP extend naturally to more complex languages
    ∗
    The content of this document is not claimed to be original or to be published as original research. It is meant to
serve as a learning resource for students.


                                                          1
     1.1     Syntax of IMP in Dafny
     We begin with the syntax of our imperative language, consisting of identifiers, arithmetic expres-
     sions, boolean expressions, and statements. There is a natural encoding of the BNF grammar of
     IMP in Dafny.

     1.1.1    Identifiers

1    datatype Id = x | y | z | s | t | u | v | n | m | i | j | g


     1.2     Arithmetic Expressions

2    datatype AExp =
3        Num ( int )
4      | Var ( Id )
5      | Plus ( AExp , AExp )
6      | Times ( AExp , AExp )


     1.3     Boolean Expressions

7    datatype BExp =
8      | B ( bool )
9      | Less ( AExp , AExp )
10     | Not ( BExp )
11     | And ( BExp , BExp )


     1.4     Statements

12   datatype Stmt =
13       Skip
14     | Assign ( Id , AExp )
15     | Seq ( Stmt , Stmt )
16     | If ( BExp , Stmt , Stmt )
17     | While ( BExp , Stmt )



     2     Semantics
     We define the meaning of each language construct using big-step operational semantics. The first
     most important part is to define what is the state of an IMP program. Naturally, the state is just
     a partial function from variables to values:

                                                 σ : Id ⇀ Z

         The second step is to define what is a configuration, that is, all the needed information needed
     to describe what a program is doing at a particular point in time. For IMP, the configuration is a
     pair
                                                    ⟨⋆, σ⟩,

                                                      2
     where σ is the program state and ⋆ ∈ {Stmt, AExp, BExp, Id, Z}. The configuration can also have
     the form
                                                  ⟨∗⟩,
     where ∗ ∈ Z, since in that case, the second component (i.e., σ) of the pair does not play an
     important role.

     Examples of Configurations.
     Here are some concrete examples of configurations:
        • ⟨x + 2, σ⟩ where σ = {x 7→ 5} — an arithmetic expression configuration
        • ⟨0 < x, σ⟩ where σ = {x 7→ 3, y 7→ 7} — a boolean expression configuration
        • ⟨x := y + 1, σ⟩ where σ = {y 7→ 10} — a statement configuration (assignment)
        • ⟨while (0 < x) do x := x + (−1), σ⟩ where σ = {x 7→ 2} — a statement configuration (loop)
        • ⟨7⟩ — a final value configuration (result of evaluating an arithmetic expression)
        • ⟨skip, σ⟩ where σ = {x 7→ 0, y 7→ 1} — the trivial statement with some state

     2.1   States and Configurations in Dafny

18   type State = map < Id , int >
19   type Configuration = ( Stmt , State )


     2.2   Big-Step Semantics of Arithmetic Expressions
     The evaluation of arithmetic expressions is defined by the following inference rules:
                                                            ·
                                             Const
                                                      ⟨n, σ⟩ ⇓ ⟨n⟩
                                                          ·      x∈σ
                                        Lookup
                                                   ⟨x, σ⟩ ⇓ σ(x)

                                            ⟨a1 , σ⟩ ⇓ n1     ⟨a2 , σ⟩ ⇓ n2
                                      Add
                                              ⟨a1 + a2 , σ⟩ ⇓ ⟨n1 + n2 ⟩

                                            ⟨a1 , σ⟩ ⇓ n1     ⟨a2 , σ⟩ ⇓ n2
                                      Mul
                                              ⟨a1 × a2 , σ⟩ ⇓ ⟨n1 × n2 ⟩

     Implementation in Dafny.

20   function evalAExp ( a : AExp , s : State ) : int {
21     match a {
22       case Num ( n ) = > n
23       case Var ( someVar ) = > if someVar in s then s [ someVar ] else 0
24       case Plus ( a1 , a2 ) = > evalAExp ( a1 , s ) + evalAExp ( a2 , s )
25       case Times ( a1 , a2 ) = > evalAExp ( a1 , s ) * evalAExp ( a2 , s )
26     }
27   }



                                                       3
     Example Derivation. Consider the arithmetic expression x + 2 and a state σ where σ(x) = 2.
     We show that ⟨x + 2, σ⟩ ⇓ ⟨4⟩:

                                          ·     x ∈ σ Const             ·
                              Lookup
                                     ⟨x, σ⟩ ⇓ 2                   ⟨2, σ⟩ ⇓ ⟨2⟩
                                 Add
                                                 ⟨x + 2, σ⟩ ⇓ ⟨4⟩

     2.2.1   Big-Step Semantics of Boolean Expressions
     The evaluation of boolean expressions is defined by the following inference rules:

                                                              ·
                                           BTrue
                                                     ⟨true, σ⟩ ⇓ ⟨true⟩


                                                              ·
                                       BFalse
                                                    ⟨false, σ⟩ ⇓ ⟨false⟩



                                           ⟨a1 , σ⟩ ⇓ ⟨n1 ⟩    ⟨a2 , σ⟩ ⇓ ⟨n2 ⟩
                                    Less
                                              ⟨a1 < a2 , σ⟩ ⇓ (n1 <Z n2 )



                                                       ⟨b, σ⟩ ⇓ ⟨v⟩
                                               Not
                                                      ⟨¬b, σ⟩ ⇓ ⟨!v⟩



                                            ⟨b1 , σ⟩ ⇓ ⟨v1 ⟩      ⟨b2 , σ⟩ ⇓ ⟨v2 ⟩
                                    And
                                                 ⟨b1 ∧ b2 , σ⟩ ⇓ ⟨v1 && v2 ⟩

     2.2.2   Implementation in Dafny.

28   function evalBExp ( b : BExp , s : State ) : bool {
29     match b {
30       case B ( bval ) = > bval
31       case Less ( a1 , a2 ) = > evalAExp ( a1 , s ) < evalAExp ( a2 , s )
32       case Not ( b1 ) = > ! evalBExp ( b1 , s )
33       case And ( b1 , b2 ) = > evalBExp ( b1 , s ) && evalBExp ( b2 , s )
34     }
35   }


     2.2.3   Example Derivation.
     Consider the expression 0 < x where σ(x) = 2. We show that ⟨0 < x, σ⟩ ⇓ true:

                                         ·                          ·      x∈σ
                             Const                 Lookup
                                   ⟨0, σ⟩ ⇓ ⟨0⟩               ⟨x, σ⟩ ⇓ ⟨2⟩
                              Less
                                             ⟨0 < x, σ⟩ ⇓ ⟨true⟩


                                                         4
2.2.4   Big-Step Semantics of Statements
The execution of statements is defined by the following inference rules:

                                                         ·
                                         Skip
                                                  ⟨skip, σ⟩ ⇓ ⟨σ⟩



                                                    ⟨a, σ⟩ ⇓ ⟨n⟩
                                 Assign
                                              ⟨x := a, σ⟩ ⇓ ⟨σ[x 7→ n]⟩



                                      ⟨S1 , σ⟩ ⇓ ⟨σ ′′ ⟩     ⟨S2 , σ ′′ ⟩ ⇓ ⟨σ ′ ⟩
                                Seq
                                                ⟨S1 ; S2 , σ⟩ ⇓ ⟨σ ′ ⟩



                                    ⟨b, σ⟩ ⇓ ⟨true⟩   ⟨S1 , σ⟩ ⇓ ⟨σ ′ ⟩
                            If-True
                                    ⟨if b then S1 else S2 , σ⟩ ⇓ ⟨σ ′ ⟩



                                        ⟨b, σ⟩ ⇓ ⟨false⟩    ⟨S2 , σ⟩ ⇓ ⟨σ ′ ⟩
                           If-False
                                         ⟨if b then S1 else S2 , σ⟩ ⇓ ⟨σ ′ ⟩



                                                      ⟨b, σ⟩ ⇓ ⟨false⟩
                              While-False
                                                   ⟨while b do S, σ⟩ ⇓ ⟨σ⟩



                          ⟨b, σ⟩ ⇓ ⟨true⟩         ⟨S, σ⟩ ⇓ ⟨σ ′′ ⟩  ⟨while b do S, σ ′′ ⟩ ⇓ ⟨σ ′ ⟩
           While-True
                                                  ⟨while b do S, σ⟩ ⇓ ⟨σ ′ ⟩

Example: While Loop Derivation.
Consider the program while (0 < x) do x := x + (−1) where σ0 (x) = 2. We show that execution
terminates in state σ2 where σ2 (x) = 0.

   We use the next notations:

   • W = while (0 < x) do x := x + (−1);

   • S = x := x + (−1);

   • σ0 = {x 7→ 2};

   • σ1 = {x 7→ 1};

   • σ2 = {x 7→ 0}.


                                                      5
   First iteration (σ0 → σ1 ): the loop executes for the first time, the value of x is decreased by 1.
   The condition of the loop:

                                    ·                            ·       x ∈ σ0
                       Const                   Lookup
                             ⟨0, σ0 ⟩ ⇓ ⟨0⟩               ⟨x, σ0 ⟩ ⇓ ⟨2⟩
                        Less
                                        ⟨0 < x, σ0 ⟩ ⇓ ⟨true⟩

   The first execution of the body of the loop:

                                   ·       x ∈ σ0 Const                ·
                     Lookup
                            ⟨x, σ0 ⟩ ⇓ ⟨2⟩                     ⟨−1, σ0 ⟩ ⇓ ⟨−1⟩
                        Add
                                           ⟨x + (−1), σ0 ⟩ ⇓ ⟨1⟩
                                 Assign
                                              ⟨S, σ0 ⟩ ⇓ ⟨σ1 ⟩

   Second iteration (σ1 → σ2 ): the loop executes the second time, the value of x becomes 0.
   The condition of the loop:

                                    ·                            ·       x ∈ σ1
                       Const                   Lookup
                             ⟨0, σ1 ⟩ ⇓ ⟨0⟩               ⟨x, σ1 ⟩ ⇓ ⟨1⟩
                        Less
                                        ⟨0 < x, σ1 ⟩ ⇓ ⟨true⟩

   The first execution of the body of the loop:

                                   ·       x ∈ σ1 Const                ·
                     Lookup
                            ⟨x, σ1 ⟩ ⇓ ⟨1⟩                     ⟨−1, σ1 ⟩ ⇓ ⟨−1⟩
                        Add
                                           ⟨x + (−1), σ1 ⟩ ⇓ ⟨0⟩
                                 Assign
                                              ⟨S, σ1 ⟩ ⇓ ⟨σ2 ⟩

   Loop termination (at σ2 ): the condition in the loop is false in σ2 .

                                    ·                              ·       x ∈ σ2
                       Const                   Lookup
                             ⟨0, σ2 ⟩ ⇓ ⟨0⟩                 ⟨x, σ2 ⟩ ⇓ ⟨0⟩
                        Less
                                       ⟨0 < x, σ2 ⟩ ⇓ ⟨false⟩
                        While-False
                                            ⟨W, σ2 ⟩ ⇓ ⟨σ2 ⟩

    A complete derivation is shown on the next page but, because it is quite big, the rule names
are removed. However, it is intended to be viewed by zooming in rather than on paper, as the font
size is quite small.




                                                  6
                                                                                                                               ·                     ·                 ·                   ·
                                            ·                     ·                       ·                   ·         ⟨x, σ1 ⟩ ⇓ ⟨1⟩       ⟨−1, σ1 ⟩ ⇓ ⟨−1⟩   ⟨0, σ2 ⟩ ⇓ ⟨0⟩      ⟨x, σ2 ⟩ ⇓ ⟨0⟩
       ·                   ·         ⟨x, σ0 ⟩ ⇓ ⟨2⟩       ⟨−1, σ0 ⟩ ⇓ ⟨−1⟩         ⟨0, σ1 ⟩ ⇓ ⟨0⟩      ⟨x, σ1 ⟩ ⇓ ⟨1⟩           ⟨x + (−1), σ1 ⟩ ⇓ ⟨0⟩                 ⟨0 < x, σ2 ⟩ ⇓ ⟨false⟩
⟨0, σ0 ⟩ ⇓ ⟨0⟩      ⟨x, σ0 ⟩ ⇓ ⟨2⟩           ⟨x + (−1), σ0 ⟩ ⇓ ⟨1⟩                       ⟨0 < x, σ1 ⟩ ⇓ ⟨true⟩                     ⟨S, σ1 ⟩ ⇓ ⟨σ2 ⟩                      ⟨W, σ2 ⟩ ⇓ ⟨σ2 ⟩
      ⟨0 < x, σ0 ⟩ ⇓ ⟨true⟩                     ⟨S, σ0 ⟩ ⇓ ⟨σ1 ⟩                                                                  ⟨W, σ1 ⟩ ⇓ ⟨σ2 ⟩
                                                                     ⟨W, σ0 ⟩ ⇓ ⟨σ2 ⟩
     2.3   Implementation Challenges
     Implementing statement execution as a terminating function in Dafny is problematic due to po-
     tentially non-terminating while loops. The decreases clause cannot be provided for arbitrary
     loops.
36   function execStmt ( stmt : Stmt , s : State ) : State
37       decreases ? // <-- problem here
38   {
39     match stmt {
40       case Sgip = > s
41       case Assign ( someVar , a ) = > s [ someVar := evalAExp (a , s ) ]
42       case Seq ( s1 , s2 ) = > execStmt ( s2 , execStmt ( s1 , s ) )
43       case If (b , s1 , s2 ) = > if evalBExp (b , s ) then execStmt ( s1 , s ) else
            execStmt ( s2 , s )
44       case While (b , body ) = >
45         if evalBExp (b , s ) then execStmt ( While (b , body ) , execStmt ( body , s ) )
              else s
46     }
47   }


     Solution: Relational Semantics with Gas.          Instead of a function, we use a ghost predicate
     with a gas parameter to ensure termination:
48   ghost predicate evalStmt ( stmt : Stmt , s : State , s1 : State , g : nat )
49     decreases stmt , g
50   {
51       match stmt
52       case Skip = > g == 1 && s == s1
53       case Assign ( myVar , ae ) = > g == 1 && s [ myVar := evalAExp ( ae , s ) ] == s1
54       case Seq ( stmt1 , stmt2 ) = >
55           exists g0 : nat , s_tmp : State ::
56                0 < g0 < g &&
57                evalStmt ( stmt1 , s , s_tmp , g0 ) &&
58                evalStmt ( stmt2 , s_tmp , s1 , g - g0 )
59       case If (b , stmt1 , stmt2 ) = >
60            if evalBExp (b , s )
61            then evalStmt ( stmt1 , s , s1 , g )
62            else evalStmt ( stmt2 , s , s1 , g )
63       case While (b , body ) = >
64            if evalBExp (b , s )
65            then exists s2 : State , g0 : nat ::
66                     0 < g0 < g &&
67                     evalStmt ( body , s , s2 , g0 ) &&
68                     evalStmt ( stmt , s2 , s1 , g - g0 )
69            else g == 1 && s1 == s
70   }

     The gas parameter g decreases with each recursive call, ensuring termination of the predicate
     definition.

     Verification Example. Using this relational semantics, we can prove that specific programs
     terminate with expected results. Below is a proof which corresponds to the derivation for the

                                                   8
      program while (0 < x) do x := x + (−1) where σ0 = {x 7→ 2}.
 71   lemma loop_to_zero ()
 72       ensures evalStmt ( While ( Less ( Num (0) , Var ( x ) ) ,
 73                                         Assign (x , Plus ( Var ( x ) , Num ( -1) ) )
 74                                     ) ,
 75                              map [ x := 2] ,
 76                              map [ x := 0] ,
 77                        3)
 78   {
 79       var while_stmt := While ( Less ( Num (0) , Var ( x ) ) ,
 80                                         Assign (x , Plus ( Var ( x ) , Num ( -1) ) )
 81                              );
 82       var cond := Less ( Num (0) , Var ( x ) ) ;
 83       var body := Assign (x , Plus ( Var ( x ) , Num ( -1) ) ) ;
 84       var aexp := Plus ( Var ( x ) , Num ( -1) ) ;
 85       var sigma := map [ x := 2];
 86       var sigma1 := sigma [ x := 1];
 87       var sigma2 := sigma1 [ x := 0];
 88
 89           // calculational proof
 90           calc <== {
 91             evalStmt ( while_stmt , sigma , sigma2 , 3) ;
 92

 93             evalBExp ( cond , sigma ) &&
 94                 evalStmt ( body , sigma , sigma1 , 1) &&
 95                 evalStmt ( while_stmt , sigma1 , sigma2 , 2) ;
 96                 { assert evalAExp ( aexp , sigma ) == 1; }
 97
 98             evalAExp ( aexp , sigma ) == 1 && evalStmt ( while_stmt , sigma1 , sigma2 ,2) ;
 99
100             evalBExp ( cond , sigma1 ) &&
101               evalStmt ( body , sigma1 , sigma2 , 1) &&
102               evalStmt ( while_stmt , sigma2 , sigma2 , 1) ;
103
104             evalAExp ( aexp , sigma1 ) == 0;
105
106             true ;
107       }
108
109       assert evalAExp ( aexp , sigma1 ) == 0;
110   }

      The lemma above proves that the while loop terminates in three steps, transforming the state from
      {x 7→ 2} to {x 7→ 0}. In Dafny, a calculational proof (calc <== ... ) shows a logical chain
      of reasoning where each step follows from the previous by inference rules or equalities. Here, it
      mirrors the operational semantics derivation tree of the while loop. The evalStmt (while stmt,
      sigma, sigma2, 3); is the root of the derivation tree. The next row:
111             evalBExp ( cond , sigma ) &&
112                 evalStmt ( body , sigma , sigma1 , 1) &&
113                 evalStmt ( while_stmt , sigma1 , sigma2 , 2) ;
114                 { assert evalAExp ( aexp , sigma ) == 1; }

      captures the premisses for While-True.

                                                     9
         The intermediary step below:
115           evalAExp ( aexp , sigma ) == 1 && evalStmt ( while_stmt , sigma1 , sigma2 ,2) ;

      corresponds to the derivation of the arithmetic expression inside the assignment and the second
      evaluation of the loop body, which again, is justified by:
116           evalBExp ( cond , sigma1 ) &&
117             evalStmt ( body , sigma1 , sigma2 , 1) &&
118             evalStmt ( while_stmt , sigma2 , sigma2 , 1) ;

      Finally, the arithmetic expression is evaluated to zero. The assert statements are necessary because
      they help guide the SMT solver that Dafny uses for verification by making intermediate facts
      explicit.




                                                      10
