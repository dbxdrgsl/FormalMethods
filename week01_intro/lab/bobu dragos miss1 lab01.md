# Lab 2 - Circuits - Bobu Dragoș

```dafny
datatype Input = I1 | I2 | I3

datatype Circuit =
  | Pin(i: Input)
  | Const(b: bool)
  | Not(c: Circuit)
  | And(c1: Circuit, c2: Circuit)
  | Or(c1: Circuit, c2: Circuit)

function eval(c: Circuit, inputs: Input -> bool): bool
{
  match c
  case Pin(i) => inputs(i)
  case Const(b) => b
  case Not(x) => !eval(x, inputs)
  case And(x, y) => eval(x, inputs) && eval(y, inputs)
  case Or(x, y) => eval(x, inputs) || eval(y, inputs)
}

function sum_bit_fn(i1: Input, i2: Input): Circuit
{
  And(Or(Pin(i1), Pin(i2)), Not(And(Pin(i1), Pin(i2))))
}

function carry_bit_fn(i1: Input, i2: Input): Circuit
{
  And(Pin(i1), Pin(i2))
}

function halfAdder(i1: Input, i2: Input, inputs: Input -> bool): (bool, bool)
{
  (eval(sum_bit_fn(i1,i2), inputs), eval(carry_bit_fn(i1,i2), inputs))
}

function in00(i: Input): bool { match i case I1 => false case I2 => false case _ => false }
function in01(i: Input): bool { match i case I1 => false case I2 => true  case _ => false }
function in10(i: Input): bool { match i case I1 => true  case I2 => false case _ => false }
function in11(i: Input): bool { match i case I1 => true  case I2 => true  case _ => false }

lemma test00() ensures halfAdder(I1,I2,in00)==(false,false) {}
lemma test01() ensures halfAdder(I1,I2,in01)==(true,false) {}
lemma test10() ensures halfAdder(I1,I2,in10)==(true,false) {}
lemma test11() ensures halfAdder(I1,I2,in11)==(false,true) {}

predicate equiv(c1: Circuit, c2: Circuit)
{ forall inputs: Input -> bool :: eval(c1, inputs) == eval(c2, inputs) }

function A(): Circuit { Pin(I1) }
function B(): Circuit { Pin(I2) }
function C(): Circuit { Pin(I3) }
function T(): Circuit { Const(true) }

lemma exMid() ensures equiv(Or(A(), Not(A())), T()) {}
lemma dm1() ensures equiv(Not(Or(A(),B())), And(Not(A()),Not(B()))) {}
lemma dm2() ensures equiv(Not(And(A(),B())), Or(Not(A()),Not(B()))) {}
lemma dist1() ensures equiv(Or(A(),And(B(),C())), And(Or(A(),B()),Or(A(),C()))) {}
lemma dist2() ensures equiv(And(A(),Or(B(),C())), Or(And(A(),B()),And(A(),C()))) {}

function Imp(P: Circuit, Q: Circuit): Circuit { Or(Not(P), Q) }
predicate valid(f: Circuit) { equiv(f, T()) }

lemma dne() ensures valid(Imp(Not(Not(A())),A())) {}
lemma contra() ensures valid(Imp(Imp(A(),B()),Imp(Not(B()),Not(A())))) {}
lemma peirce() ensures valid(Imp(Imp(Imp(A(),B()),A()),A())) {}
lemma l1() ensures valid(Imp(A(),Imp(B(),A()))) {}
lemma l2() ensures valid(Imp(Imp(A(),Imp(B(),C())),Imp(Imp(A(),B()),Imp(A(),C())))) {}
lemma l3() ensures valid(Imp(Imp(Not(A()),Not(B())),Imp(B(),A()))) {}
