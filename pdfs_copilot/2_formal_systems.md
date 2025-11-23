Week 2: Languages. Formal Systems. Inference
               rules. Proofs.

                Andrei Arusoaie
This material is heavily based on this book:


Boro Sitnikovski. Introducing Software Verification with Dafny
Language – Proving Program Correctness, ISBN
978-1-4842-7977-9.
Why Do We Need Formal Languages?


  Natural languages (English) are ambiguous:

  “There exists a number such that it’s greater than two and there
  exists a number such that it’s greater than three.”

  Questions arise:
   ▶ Are these the same number or different numbers?
   ▶ Are we talking about positive numbers only?
   ▶ Are negative numbers allowed?

  Computers require precision!
What is a Language?


   A language consists of:
    1. A finite set of symbols: {A, B, C , . . .}
    2. Rules to combine symbols into strings: ABBA, CAB, etc.
    3. Grammar that defines the rules to construct valid strings

   Examples:
    ▶ English: “Hi, how are you?” (valid)
    ▶ English: “hi, how” (not valid)
    ▶ Logic: ∀x.x ∈ N ∧ x ≥ 0 (valid)
Languages Shape Thinking

   Language affects how we think:

   Example: Numbers in different languages
    ▶ English: “ninety-six” (90 + 6)
    ▶ French: “quatre-vingt-seize” (4 * 20 + 16)
    ▶ Different grammars encode different construction rules

   Insight:
   Knowing multiple languages enriches not only our vocabulary but
   also exposes us to different ways of constructing and organizing
   ideas.

   Different grammars = different ways of thinking
Choosing the Right Programming Language
   Why does this matter?
    ▶ Different programming languages are better suited for specific
      tasks
    ▶ No single “best” language exists
    ▶ An implementation can be easier or harder depending on the
      language

   In programming:
     ▶ C may be better for low-level systems programming
    ▶ Haskell may be better for expressing mathematical properties
    ▶ Python may be better for rapid prototyping
    ▶ SQL may be better for database queries

   Choose the right (formal) language for the problem at hand!
From Languages to Formal Systems
   Languages vs. Formal Systems:

    ▶ Languages allow us to transfer messages
    ▶ Formal systems allow us to transfer abstract ideas

   Why formal systems?
   Formal systems lie at the heart of mathematics and specify its
   foundations.

   Key purpose: Enable reasoning about form rather than content
    ▶ Focus on structure, not meaning
    ▶ This abstraction makes them powerful tools
    ▶ Essential for proving software correctness

   Before proving programs correct, we must understand what
   “proof” means!
What is a Formal System?

   Definition: A model of abstract reasoning consisting of:
    1. Formal syntax
         ▶ Finite set of symbols
         ▶ Grammar (a set of rules to combine the symbols, in order to
           obtain strings of symbols)
    2. Axioms
         ▶ Certain strings accepted as valid without proof
    3. Inference rules
         ▶ Used to construct new valid formulas (theorems)

   Key idea: The grammar determines which strings are syntactically
   valid, while the inference rules determine which strings are
   semantically valid.
Example Formal System: Propositional Logic
   1. Alphabet (Symbols):
     ▶ Propositional atoms: A = {p, q, r , . . .}
    ▶ Logical connectives: ¬, ∧, ∨, →
    ▶ Parentheses: (, )

   2. Grammar (BNF):

                ϕ ::= a | ¬ϕ | (ϕ ∧ ϕ) | (ϕ ∨ ϕ) | (ϕ → ϕ),

   where a ∈ A.

   3. Examples:
     ▶ Well-formed: (p ∧ q), ((p → q) ∨ r ), ¬(p ∧ ¬q)
    ▶ NOT well-formed: p ∧ q, p ∧ ∧q, → p, pq
   We may write p ∧ q instead of (p ∧ q) as a notational convention
   when no ambiguity arises.
Inference Rules
   Definition: Rules that allow deriving new theorems from existing
   ones.
   General form of inference rules:
                        Premise1 . . . Premisen
                               Conclusion

   Notation: In logic, we use ⊢ (turnstile) to say something “is
   provable”
     ▶ ⊢ ϕ means “ϕ is a theorem”
    ▶ Γ ⊢ ϕ means “ϕ is provable from assumptions Γ”

   Example: Modus Ponens
                         Γ⊢P     Γ⊢P →Q
                                        MP
                                Γ⊢Q

   If we know P is provable and P → Q is provable, we can prove Q.
Prerequisites: Sequents
   In Propositional Logic, the premisses and the conclusion of an
   inference rule are called sequents and have the form:

                                  Γ ⊢ φ,

   where Γ is a set of formulae (axioms) and φ – a formula
   (conclusion).

   Γ ⊢ φ is correct if whenever all formulae in Γ are true, then φ is
   also true.

   Examples:
    ▶ If Γ = {p}, then Γ ⊢ p. (Trivial: from p we can conclude p.)
    ▶ Γ can also be empty: ∅ ⊢ φ means “φ holds without
      assumptions.”
    ▶ Another example: {p, r } ⊢ p ∧ r . Intuitively correct: if both p
      and r hold, then p ∧ r holds. But how do we prove it?
Inference Rules for Propositional Logic/Natural Deduction
   And-Introduction (∧-intro):

                       Γ⊢A Γ⊢B
                               ∧-intro
                        Γ⊢A∧B

   And-Elimination (∧-elim):

             Γ⊢A∧B                   Γ⊢A∧B
                   ∧-elim-L                ∧-elim-R
              Γ⊢A                     Γ⊢B

   Or-Introduction (∨-intro):

             Γ⊢A                      Γ⊢B
                  ∨-intro-L                ∨-intro-R
            Γ⊢A∨B                    Γ⊢A∨B

   Or-Elimination (∨-elim):

           Γ⊢A∨B       Γ ∪ {A} ⊢ C   Γ ∪ {B} ⊢ C
                                                   ∨-elim
                            Γ⊢C
Inference Rules for Propositional Logic/Natural Deduction
   Hypothesis:                  ·      Hyp
                           Γ ∪ {A} ⊢ A
   Implication Introduction (→-intro/Deduction Theorem):

                         Γ ∪ {A} ⊢ B
                                     → -intro
                          Γ⊢A→B

   Implication Elimination (→-elim/Modus-Ponens):
                      Γ⊢A→B Γ⊢A
                                → -elim
                         Γ⊢B

   Negation Introduction (¬-intro) & Negation Elimination (¬-elim):

           Γ ∪ {A} ⊢ ⊥                Γ ⊢ A Γ ⊢ ¬A
                       ¬-intro                     ¬-elim
              Γ ⊢ ¬A                      Γ⊢⊥

   Double Negation Elimination (¬¬-elim) & ⊥-elim:
                 Γ ⊢ ¬¬A                 Γ⊢⊥
                         ¬¬-elim             ⊥-elim
                  Γ⊢A                    Γ⊢φ
What is a Proof?



   Definition: In general, an argument showing that a conclusion
   logically follows from hypotheses.

   To prove G from premises {g1 , g2 , . . . , gn }, we must show:

                         (g1 ∧ g2 ∧ . . . ∧ gn ) → G


   A proof is valid if: whenever all premises are true, the conclusion
   is also true.
Example Proof: ⊢ (p ∧ q) → (q ∧ p)

   Goal: Prove that ⊢ (p ∧ q) → (q ∧ p) (N.b. ⊢ φ is a notation for ∅ ⊢ φ)
Example Proof: ⊢ (p ∧ q) → (q ∧ p)

   Goal: Prove that ⊢ (p ∧ q) → (q ∧ p) (N.b. ⊢ φ is a notation for ∅ ⊢ φ)

   Proof using natural deduction:
     1. (p ∧ q) ⊢ (p ∧ q)                                           (Hyp)
     2. (p ∧ q) ⊢ p                                          (∧-elim-L, 1)
     3. (p ∧ q) ⊢ q                                          (∧-elim-R, 1)
     4. (p ∧ q) ⊢ (q ∧ p)                                   (∧-intro, 3, 2)
     5. ⊢ (p ∧ q) → (q ∧ p)                                (→-intro, 1, 4)


        ·      Hyp     Γ⊢A∧B                 Γ⊢A∧B
                             ∧-elim-L              ∧-elim-R
   Γ ∪ {A} ⊢ A          Γ⊢A                   Γ⊢B
           Γ ∪ {A} ⊢ B              Γ⊢A Γ⊢B
                       → -intro             ∧-intro
            Γ⊢A→B                    Γ⊢A∧B
Example Proof: ⊢ (p ∧ q) → (q ∧ p)

   Goal: Prove that ⊢ (p ∧ q) → (q ∧ p) (N.b. ⊢ φ is a notation for ∅ ⊢ φ)

   A proof tree:
                   ·         Hyp                 ·         Hyp
           (p ∧ q) ⊢ (p ∧ q)             (p ∧ q) ⊢ (p ∧ q)
                             ∧-elim-R                      ∧-elim-L
              (p ∧ q) ⊢ q                   (p ∧ q) ⊢ p
                                                        ∧-intro
                          (p ∧ q) ⊢ (q ∧ p)
                                               → -intro
                       ⊢ ((p ∧ q) → (q ∧ p))

        ·      Hyp     Γ⊢A∧B                  Γ⊢A∧B
                             ∧-elim-L               ∧-elim-R
   Γ ∪ {A} ⊢ A          Γ⊢A                    Γ⊢B
           Γ ∪ {A} ⊢ B              Γ⊢A Γ⊢B
                       → -intro             ∧-intro
            Γ⊢A→B                    Γ⊢A∧B
Why Formal Languages Matter
  Natural languages limitations:
   ▶ Ambiguous and context-dependent
    ▶ No systematic way to verify correctness of reasoning
    ▶ Difficult to establish absolute trust in arguments

  Formal languages enable trustworthy reasoning:
   ▶ They are precise, have unambiguous syntax and semantics
    ▶ Enable mechanical verification of proofs
    ▶ If reasoning follows the rules, the conclusions are guaranteed
      correct

  Computers can operate on formal languages!
   ▶ Tools for formal software verification are possible (e.g., Dafny)
    ▶ Automated checking of proofs and reasoning
Dafny – intro

   What is Dafny?
    ▶ A programming language with built-in verification
    ▶ Designed by Rustan Leino (Microsoft Research)
    ▶ Automatically proves program correctness
    ▶ Uses Z3 theorem prover under the hood

   Key features:
    ▶ Preconditions (requires)
    ▶ Postconditions (ensures)
    ▶ Loop invariants (invariant)
    ▶ Algebraic datatypes
    ▶ Pattern matching
First Dafny Program


 1   method Main () {
 2     print " Hello , ␣ World !\ n " ;
 3   }


     With verification:
 1   method Main ()
 2     ensures 3 * 2 == 6
 3   {
 4     print " Hello , ␣ World !\ n " ;
 5   }

     Dafny proves properties at compile time!
Basic Constructs: Methods and Functions

     Method (can have side effects, runs at runtime):
 1   method Abs ( x : int ) returns ( y : int )
 2   {
 3     if x < 0 {
 4       return -x ;
 5     } else {
 6       return x ;
 7     }
 8   }

     Function (pure, used in specifications):
 1   function AbsFun ( x : int ) : int
 2   {
 3     if x < 0 then -x else x
 4   }
Algebraic Data Types (ADTs)


     ADTs define custom types with multiple variants (constructors).
     Basic syntax:
 1   datatype TypeName <T > =
 2     | Constructor1 ( field1 : Type1 )
 3     | Constructor2 ( field2 : Type2 , field3 : Type3 )
 4     | ...

     Example: Boolean
 1   datatype Bool = True | False
ADT Example: Lists

 1   datatype List <T > =
 2     | Nil
 3     | Cons ( head : T , tail : List <T >)


     Creating lists:
 1   // Empty list
 2   const empytyList : List < int > := Nil
 3

 4   // [1 , 2 , 3]
 5   const someList : List < int > :=
 6                     Cons (1 , Cons (2 , Cons (3 , Nil ) ) )

     Note: Constructor parameters are named, making code more
     readable.
ADT Example: Binary Trees

 1   datatype Tree <T > =
 2     Leaf
 3   | Node ( value : T , left : Tree <T > , right : Tree <T >)


 1   // A simple tree :
 2   //         5
 3   //        / \
 4   //      3     7
 5   const myTree :=
 6      Node (
 7        5,
 8        Node (3 , Leaf , Leaf ) ,
 9        Node (7 , Leaf , Leaf )
10      )
ADT Example: Option Type

    Represents a value that may or may not exist.
1   datatype Option <T > =
2     | None
3     | Some ( value : T )


    Usage:
1   function    divide ( x : int , y : int ) : Option < int >
2   {
3       if y    == 0
4       then    None
5       else    Some ( x / y )
6   }

    Properly handle the special cases
Back to Functions

     Pure functions use the function keyword:
      ▶ No side effects
      ▶ Deterministic (same input → same output)
      ▶ Can be used in specifications
      ▶ Must terminate

     Syntax:
 1   function functionName <T >( param : Type ) :
        ReturnType
 2   {
 3     // function body
 4   }
Function Example: Factorial


 1   function factorial ( n : nat ) : nat
 2   {
 3     if n == 0 then 1
 4     else n * factorial ( n - 1)
 5   }


     Key features:
      ▶ nat is the type of natural numbers (non-negative)
      ▶ Recursive definition
      ▶ Single expression body (no return statement)
      ▶ Dafny automatically verifies termination
Collatz

 1   function   collatz ( n : nat ) : nat
 2   {
 3       if n   == 0 then 1
 4       else   if n % 2 == 0 then collatz ( n / 2)
 5       else   collatz (3 * n + 1)
 6   }


      ▶ Dafny: cannot prove termination; try supplying a
        decreases clause
      ▶ In 2019, mathematician Terence Tao proved that the Collatz
        conjecture is ”almost” true for ”almost” all starting numbers
      ▶ https://terrytao.wordpress.com/2019/09/10/
          almost-all-collatz-orbits-attain-almost-bounded-values/
Pattern Matching with match

     Pattern matching deconstructs ADTs:
 1   function length <T >( xs : List <T >) : nat
 2   {
 3     match xs
 4     case Nil = > 0
 5     case Cons ( head , tail ) = > 1 + length ( tail )
 6   }


      ▶ match expression examines the structure of xs as in the
        definition of List<T>
      ▶ Each case handles exactly one constructor
      ▶ Binds constructor fields to variables
      ▶ Must be exhaustive (all cases covered)!
More Pattern Matching Examples
     List append:
 1   function append <T >( xs : List <T > , ys : List <T >) :
        List <T >
 2   {
 3     match xs
 4     case Nil = > ys
 5     case Cons ( head , tail ) = >
 6       Cons ( head , append ( tail , ys ) )
 7   }


     Tree height:
 1   function height <T >( t : Tree <T >) : nat
 2   {
 3     match t
 4     case Leaf = > 0
 5     case Node (_ , left , right ) = >
 6       1 + max ( height ( left ) , height ( right ) )
 7   }
Higher-Order Functions
     Functions can take other functions as parameters!
 1   function mymap <A , B >( f : A -> B , xs : List <A >) :
        List <B >
 2   {
 3       match xs
 4       case Nil = > Nil
 5       case Cons ( head , tail ) = >
 6            Cons ( f ( head ) , mymap (f , tail ) )
 7   }
 8
 9   function increment ( x : int ) : int { x + 1 }
10

11   method testMap () returns ( res : List < int >)
12     ensures res == Cons (2 , Cons (3 , Cons (4 , Nil ) ) )
13   {
14       var list := Cons (1 , Cons (2 , Cons (3 , Nil ) ) ) ;
15       res := mymap ( increment , list ) ;
16   }
Higher-Order Functions
 1   function filter <T >( pred : T -> bool , xs : List <T >)
        : List <T >
 2   {
 3     match xs
 4     case Nil = > Nil
 5     case Cons ( head , tail ) = >
 6       if pred ( head )
 7       then Cons ( head , filter ( pred , tail ) )
 8       else filter ( pred , tail )
 9   }
10   function isEven ( x : int ) : bool { x % 2 == 0 }
11   method testFilter () returns ( result : List < int >)
12       ensures result == Cons (2 , Cons (4 , Nil ) )
13   {
14       var list := Cons (1 , Cons (2 , Cons (3 , Cons (4 ,
            Nil ) ) ) ) ;
15       result := filter ( isEven , list ) ;
16   }
Function Specifications

     Dafny’s superpower: formal specifications
 1   function factorial ( n : nat ) : nat
 2     requires n >= 0
 3     ensures factorial ( n ) >= 1
 4     ensures n > 0 == > factorial ( n ) >= n
 5   {
 6     if n == 0 then 1
 7     else n * factorial ( n - 1)
 8   }


      ▶ ensures: postconditions (what’s true after execution)
      ▶ requires: preconditions (assumptions about inputs)
      ▶ Dafny automatically verifies these properties!
Specification Example: List Length
 1   function length <T >( xs : List <T >) : nat
 2     ensures length ( xs ) >= 0
 3   {
 4     match xs
 5     case Nil = > 0
 6     case Cons (_ , tail ) = > 1 + length ( tail )
 7   }
 8

 9   function append <T >( xs : List <T > , ys : List <T >) :
        List <T >
10     ensures length ( append ( xs , ys ) ) ==
11                length ( xs ) + length ( ys )
12   {
13     match xs
14     case Nil = > ys
15     case Cons ( head , tail ) = >
16                   Cons ( head , append ( tail , ys ) )
17   }
Termination: The decreases Clause

     Dafny requires proof that functions terminate.
 1   function gcd ( a : nat , b : nat ) : nat
 2     requires b > 0
 3     decreases a
 4   {
 5     if a == 0 then b
 6     else gcd ( b % a , a )
 7   }


      ▶ decreases n says the parameter n gets smaller
      ▶ Dafny verifies the measure decreases in each recursive call
      ▶ Usually inferred automatically for simple cases
      ▶ Explicit decreases needed for complex recursion
Propositional Logic in Dafny

     Direct encoding of our formal language:
 1   datatype Atom = P | Q | R
 2   datatype Prop =
 3     | Var ( Atom )                               //   Constants
 4     | Not ( Prop )                               //   Negation
 5     | And ( Prop , Prop )                        //   Conjunction
 6     | Or ( Prop , Prop )                         //   Disjunction
 7     | Imp ( Prop , Prop )                        //   Implication


     Grammar (BNF):

                   ϕ ::= a | ¬ϕ | (ϕ ∧ ϕ) | (ϕ ∨ ϕ) | (ϕ → ϕ),

     where a ∈ A = {p, q, r , . . .}.
Propositional Logic in Dafny

     Direct encoding of our formal language:
 1   datatype Prop =
 2     | P | Q | R                             //   Constants
 3     | Not ( Prop )                          //   Negation
 4     | And ( Prop , Prop )                   //   Conjunction
 5     | Or ( Prop , Prop )                    //   Disjunction
 6     | Imp ( Prop , Prop )                   //   Implication


     Examples of encoding formulas:
      ▶ (p ∧ q) becomes And(P, Q)
      ▶ (¬p → q) becomes Imp(Not(P), Q)
      ▶ ((p ∨ q) ∧ r ) becomes And(Or(P, Q), R)
Valuations of Propositional Variables
     Def: A valuation is a function that assigns truth values to atoms:

                            α : A → {true, false}


     Example valuation α1 :

        α1 (p) = true,   α1 (q) = false,   α1 (r ) = true   α1 ( ) = true


     Encoding in Dafny:
 1   function alpha1 ( a : Atom ) : bool
 2   {
 3       match a
 4       case P = > true
 5       case Q = > false
 6       case R = > true
 7   }
Semantics of Propositional Formulas
     Def: Given a valuation α, we define JφKα inductively:
                              JaKα = α(a)
                            J¬φKα =! JφKα
                         Jφ ∧ ψKα = JφKα && JψKα
                         Jφ ∨ ψKα = JφKα || JψKα
                        Jφ → ψKα =! JφKα || JψKα

     Encoding in Dafny:
 1   function eval ( phi : Prop , alpha : Atom -> bool ) : bool
 2   {
 3     match phi
 4     case Var ( p ) = > alpha ( p )
 5     case Not ( p ) = > ! eval (p , alpha )
 6     case And (p , q ) = > eval (p , alpha ) && eval (q , alpha )
 7     case Or (p , q ) = > eval (p , alpha ) || eval (q , alpha )
 8     case Imp (p , q ) = > ! eval (p , alpha ) || eval (q , alpha )
 9   }
Testing Evaluation
     Example: Evaluate ((p ∧ q) → r ) under α1

      ▶ Formula: ((p ∧ q) → r )
      ▶ Valuation: α1 (p) = true, α1 (q) = false, α1 (r ) = true
      ▶ Details:
        J((p ∧ q) → r )Kα1 = ... =! (JpKα1 && JqKα1 ) || Jr Kα1 =
        !(true && false) || true = !false || true = true

     Dafny implementation:
 1   method testEval () returns ( b : bool )
 2   {
 3       var phi := Imp ( And ( Var ( P ) , Var ( Q ) ) , Var ( R ) ) ;
 4       b := eval ( phi , alpha1 ) ;
 5       assert b == true ;
 6   }

     Note: Dafny automatically verifies the assertion holds!
Validity in Propositional Logic

     Def: A formula φ is valid (tautology) if it evaluates to true under
     all valuations:

                      |= φ   iff   for all α : JφKα = true


     Example: The formula p → p is valid, i.e., |= p → p.

     Dafny:
 1   method testPimpliesP ()
 2      ensures forall alpha ::
 3         eval ( Imp ( Var ( P ) , Var ( P ) ) , alpha ) == true
 4   {}

     Dafny proves the postcondition automatically, no computation
     needed— just pure verification.
Satisfiability in Propositional Logic
     Def: A formula φ is satisfiable if there exists at least one valuation
     that makes it true:

               φ is satisfiable   iff   there exists α : JφKα = true

     Example: p ∧ q is satisfiable with α1 : α1 (x) = true, for any x ∈ A.
     Dafny:
 1   method testSat ()
 2     ensures exists alpha ::
 3            eval ( And ( Var ( P ) , Var ( Q ) ) , alpha ) == true
 4   {
 5     var alpha1 := ( a : Atom ) = > true ;
 6     assert
 7       eval ( And ( Var ( P ) , Var ( Q ) ) , alpha1 ) == true ;
 8   }

     Note: We have to provide a witness valuation α1 , then assert it satisfies
     the formula. Dafny uses the witness to verify the existential claim.
Equivalence in Propositional Logic

     Definition: Two formulas φ and ψ are logically equivalent if they
     have the same truth value under all valuations:

                     φ≡ψ      iff   for all α : JφKα = JψKα


     Example: The formulas p → q and ¬p ∨ q are logically equivalent.

     Verification in Dafny:
 1   method testEquiv ()
 2      ensures forall alpha ::
 3        eval ( Imp ( Var ( P ) , Var ( Q ) ) , alpha ) ==
 4        eval ( Or ( Not ( Var ( P ) ) , Var ( Q ) ) , alpha )
 5   {}

     Note: Dafny automatically verifies this classical equivalence.
Predicates in Dafny
     Predicates are boolean-valued functions that can be used in specs.

     Key features:
      ▶ Declared with predicate keyword
      ▶ Return type is always bool (implicit)
      ▶ ghost means used only for verification!
      ▶ Can use quantifiers (forall, exists)

     Syntax:
 1   ghost predicate predicateName ( params ) {
 2     // boolean expression
 3   }

     We can reuse complex logical properties via predicates; improves
     readability as well.
Defining Logical Properties as Predicates

     We can encode our semantic definitions as (reusable) predicates:

 1   ghost predicate satisfiable ( phi : Prop ) {
 2     exists alpha : Atom -> bool :: eval ( phi , alpha )
 3   }
 4

 5   ghost predicate tautology ( phi : Prop ) {
 6     forall alpha :: eval ( phi , alpha )
 7   }
 8
 9   ghost predicate equivalent ( phi : Prop , psi : Prop )
10   {
11     forall alpha ::
12       eval ( phi , alpha ) == eval ( psi , alpha )
13   }
Lemmas in Dafny

    Lemmas are theorems that Dafny proves automatically.

    Syntax:
1   lemma lemmaName ()
2     ensures postcondition
3   {
4     // proof ( optional )
5   }


    Differences w.r.t. methods:
     ▶ Ghost code (verification only, not compiled)
     ▶ Prove mathematical properties
     ▶ Can be called in other proofs to establish facts
     ▶ Body can be empty if Dafny can prove it automatically
Using Predicates in Lemmas: Satisfiability
     Lemma: The formula p ∧ q is satisfiable.

 1   lemma TestSatisfiable ()
 2     ensures satisfiable ( And ( Var ( P ) , Var ( Q ) ) )
 3   {
 4     var alpha1 := ( a : Atom ) = > true ;
 5     assert
 6       eval ( And ( Var ( P ) , Var ( Q ) ) , alpha1 ) == true ;
 7   }


     Proof:
      1. Dafny needs a witness valuation: we provide α1 (which maps
         all propositional variables to true)
      2. Assert the formula evaluates to true under α′
      3. Dafny verifies this satisfies the existential in the predicate
Using Predicates in Lemmas: Validity & Equivalence


     Lemma: The formula p → p is a tautology.
 1   lemma testValidity ()
 2     ensures tautology ( Imp ( Var ( P ) , Var ( P ) ) )
 3   { }


     Lemma: Implication translates into a disjunction.
 1   lemma testEquivalence ()
 2     ensures equivalent ( Imp ( Var ( P ) , Var ( Q ) ) ,
 3                          Or ( Not ( Var ( P ) ) , Var ( Q ) ) )
 4   { }
Overview



    1. Formal languages eliminate ambiguity
    2. Formal systems = Language + Axioms + Inference Rules
    3. Proofs are systematic applications of inference rules
    4. Dafny enables formal systems for verification
    5. Dafny automatically verifies correctness using SMT solving
    6. Sometimes, in Dafny, we can help the prover (e.g., providing
       witness for existential statements)
Questions?




             Questions?
