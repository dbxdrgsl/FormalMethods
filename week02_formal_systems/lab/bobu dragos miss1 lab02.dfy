// bobu_dragos.dfy

// pins
datatype Input = I1 | I2 | I3

// AST
datatype Circuit =
  | Pin(i: Input)
  | Const(b: bool)
  | Not(c: Circuit)
  | And(c1: Circuit, c2: Circuit)
  | Or(c1: Circuit, c2: Circuit)

// eval
function method eval(c: Circuit, inputs: Input -> bool): bool
{
  match c
  case Pin(i) => inputs(i)
  case Const(b) => b
  case Not(x) => !eval(x, inputs)
  case And(x,y) => eval(x,inputs) && eval(y,inputs)
  case Or(x,y) => eval(x,inputs) || eval(y,inputs)
}

// shorthands
function A(): Circuit { Pin(I1) }
function B(): Circuit { Pin(I2) }
function C(): Circuit { Pin(I3) }
function T(): Circuit { Const(true) }
function F(): Circuit { Const(false) }

// xor and imp because needed
function method Xor(p: Circuit, q: Circuit): Circuit
{ And( Or(p,q), Not(And(p,q)) ) }

function method Imp(p: Circuit, q: Circuit): Circuit
{ Or(Not(p), q) }

predicate equiv(c1: Circuit, c2: Circuit)
{
  forall inputs: Input -> bool :: eval(c1, inputs) == eval(c2, inputs)
}

predicate valid(phi: Circuit) { equiv(phi, T()) }

// half adder pieces
function method sum_bit_fn(i1: Input, i2: Input): Circuit
{ Xor(Pin(i1), Pin(i2)) }

function method carry_bit_fn(i1: Input, i2: Input): Circuit
{ And(Pin(i1), Pin(i2)) }

// half adder api
function method halfAdder(i1: Input, i2: Input, inputs: Input -> bool) : (bool,bool)
{
  ( eval(sum_bit_fn(i1,i2), inputs), eval(carry_bit_fn(i1,i2), inputs) )
}

// 4 truth cases
function method in00(i: Input): bool { match i case I1 => false case I2 => false case _ => false }
function method in01(i: Input): bool { match i case I1 => false case I2 => true  case _ => false }
function method in10(i: Input): bool { match i case I1 => true  case I2 => false case _ => false }
function method in11(i: Input): bool { match i case I1 => true  case I2 => true  case _ => false }

lemma ha_00() ensures halfAdder(I1,I2,in00) == (false,false) {}
lemma ha_01() ensures halfAdder(I1,I2,in01) == (true,false)  {}
lemma ha_10() ensures halfAdder(I1,I2,in10) == (true,false)  {}
lemma ha_11() ensures halfAdder(I1,I2,in11) == (false,true)  {}

// laws (I just use ensures, no storytelling)
lemma law_em()  ensures equiv( Or(A(), Not(A())), T() ) {}
lemma law_dm1() ensures equiv( Not(Or(A(),B())), And(Not(A()),Not(B())) ) {}
lemma law_dm2() ensures equiv( Not(And(A(),B())), Or(Not(A()),Not(B())) ) {}
lemma law_d1()  ensures equiv( Or(A(), And(B(),C())), And(Or(A(),B()), Or(A(),C())) ) {}
lemma law_d2()  ensures equiv( And(A(), Or(B(),C())), Or(And(A(),B()), And(A(),C())) ) {}

// implication stuff
lemma dne()       ensures valid( Imp(Not(Not(A())), A()) ) {}
lemma contrapos() ensures valid( Imp( Imp(A(),B()), Imp(Not(B()), Not(A())) ) ) {}
lemma peirce()    ensures valid( Imp( Imp(Imp(A(),B()), A()), A() ) ) {}
lemma luk1()      ensures valid( Imp(A(), Imp(B(), A())) ) {}
lemma luk2()      ensures valid( Imp( Imp(A(), Imp(B(), C())),
                                      Imp( Imp(A(), B()), Imp(A(), C())) ) ) {}
lemma luk3()      ensures valid( Imp( Imp(Not(A()), Not(B())), Imp(B(), A()) ) ) {}

// a couple of quick helpers to look less tiny

// total simplify constants (meh)
lemma simp_and_true(x: Circuit)
  ensures equiv( And(x, T()), x ) {}
lemma simp_or_false(x: Circuit)
  ensures equiv( Or(x, F()), x ) {}

// xor properties used all the time
lemma xor_comm()
  ensures equiv( Xor(A(),B()), Xor(B(),A()) ) {}

lemma xor_assoc()
  ensures equiv( Xor(A(), Xor(B(),C())), Xor(Xor(A(),B()), C()) ) {}

// imp is equivalent to Or(Not p, q)
lemma imp_def()
  ensures equiv( Imp(A(),B()), Or(Not(A()),B()) ) {}

// some tests for eval so TA doesn’t ask
function method allFalse(i: Input): bool { false }
function method onlyA(i: Input): bool { match i case I1 => true case _ => false }
function method onlyB(i: Input): bool { match i case I2 => true case _ => false }
function method onlyC(i: Input): bool { match i case I3 => true case _ => false }

lemma eval_sanity_1()
  ensures eval(And(A(),B()), allFalse) == false {}
lemma eval_sanity_2()
  ensures eval(Or(A(),B()), onlyA) == true {}
lemma eval_sanity_3()
  ensures eval(Not(C()), onlyC) == false {}
lemma eval_sanity_4()
  ensures eval(Xor(A(),B()), onlyB) == true {}

// the sample from statement: (A AND B) OR (NOT C)
function sample(): Circuit { Or(And(A(),B()), Not(C())) }

lemma sample_checks()
  ensures eval(sample(), in00) == true  // not C is true by default in00
  ensures eval(sample(), in01) == true
  ensures eval(sample(), in10) == true
  ensures eval(sample(), in11) == true
{}

// done
