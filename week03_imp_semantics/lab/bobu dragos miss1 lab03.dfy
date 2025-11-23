// Lab03_Standalone.dfy  — self-contained IMP + tests

// identifiers as strings
const x: string := "x";
const y: string := "y";
const z: string := "z";

// arithmetic and boolean expressions
datatype AExp = Num(n: int) | Var(id: string) | Plus(a: AExp, b: AExp) | Times(a: AExp, b: AExp)
datatype BExp = B(b: bool) | Less(a1: AExp, a2: AExp) | Not(b: BExp) | And(b1: BExp, b2: BExp)

// states map identifiers to ints
type State = map<string,int>

// pure evaluators
function evalAExp(a: AExp, s: State): int
{
  match a
  case Num(n)        => n
  case Var(id)       => s[id]
  case Plus(a1, a2)  => evalAExp(a1, s) + evalAExp(a2, s)
  case Times(a1, a2) => evalAExp(a1, s) * evalAExp(a2, s)
}

function evalBExp(b: BExp, s: State): bool
{
  match b
  case B(v)         => v
  case Less(a1,a2)  => evalAExp(a1, s) < evalAExp(a2, s)
  case Not(b1)      => !evalBExp(b1, s)
  case And(b1, b2)  => evalBExp(b1, s) && evalBExp(b2, s)
}

// statements
datatype Stmt = Skip | Assign(id: string, a: AExp) | Seq(s1: Stmt, s2: Stmt) | If(c: BExp, t: Stmt, e: Stmt) | While(c: BExp, body: Stmt)

// big-step executor with fuel (gas). ok==true means full termination within given gas.
method exec(st: Stmt, s: State, gas: nat) returns (s': State, ok: bool)
  decreases gas, st
{
  if gas == 0 {
    s' := s; ok := false; return;
  }
  match st
  case Skip =>
    s' := s; ok := true;
  case Assign(id, a) =>
    s' := s[id := evalAExp(a, s)];
    ok := true;
  case Seq(s1, s2) =>
    var mid: State; var ok1: bool;
    call mid, ok1 := exec(s1, s, gas - 1);
    if !ok1 {
      s' := mid; ok := false;
    } else {
      var out: State; var ok2: bool;
      call out, ok2 := exec(s2, mid, gas - 1);
      s' := out; ok := ok2;
    }
  case If(c, t, e) =>
    if evalBExp(c, s) {
      call s', ok := exec(t, s, gas - 1);
    } else {
      call s', ok := exec(e, s, gas - 1);
    }
  case While(c, body) =>
    if evalBExp(c, s) {
      var sb: State; var okb: bool;
      call sb, okb := exec(body, s, gas - 1);
      if !okb {
        s' := sb; ok := false;
      } else {
        // continue the same While; gas decreases
        call s', ok := exec(st, sb, gas - 1);
      }
    } else {
      s' := s; ok := true;
    }
}

// ===== Lab 3 exercises as simple lemmas/tests =====

lemma ex1()
{
  // (x + 5) * (y + -3) with σ = {x↦2, y↦5}  ==> 14
  var a := Times(Plus(Var(x), Num(5)), Plus(Var(y), Num(-3)));
  var sigma := map[x := 2, y := 5];
  assert evalAExp(a, sigma) == 14;
}

lemma ex2()
{
  // !(x < 4) && (y < (x + y)) with σ = {x↦5, y↦10}  ==> true
  var b :=
    And(
      Not(Less(Var(x), Num(4))),
      Less(Var(y), Plus(Var(x), Var(y)))
    );
  var sigma := map[x := 5, y := 10];
  assert evalBExp(b, sigma) == true;
}

lemma ex3()
{
  // seq: x := 10; y := x * x from σ0={x↦0,y↦0} to σf={x↦10,y↦100}
  var assignX := Assign(x, Num(10));
  var rhsYY  := Times(Var(x), Var(x));
  var assignY := Assign(y, rhsYY);
  var prog := Seq(assignX, assignY);

  var sigma0 := map[x := 0, y := 0];
  var sigmaf := map[x := 10, y := 100];

  var out: State; var ok: bool;
  call out, ok := exec(prog, sigma0, 3);
  assert ok;
  assert out == sigmaf;
}

lemma ex4()
{
  // if (x < y) then x := y + 1 else skip; σ={x↦5,y↦8} ==> σf={x↦9,y↦8}
  var cond := Less(Var(x), Var(y));
  var thenS := Assign(x, Plus(Var(y), Num(1)));
  var elseS := Skip;
  var prog := If(cond, thenS, elseS);

  var sigma := map[x := 5, y := 8];
  var sigmaf := map[x := 9, y := 8];

  var out: State; var ok: bool;
  call out, ok := exec(prog, sigma, 2);
  assert ok;
  assert out == sigmaf;
}

lemma ex5()
{
  // while (0 < x) do x := x + 1 on σ={x↦0} terminates immediately
  var cond := Less(Num(0), Var(x));
  var body := Assign(x, Plus(Var(x), Num(1)));
  var loop := While(cond, body);

  var sigma0 := map[x := 0];

  var out: State; var ok: bool;
  call out, ok := exec(loop, sigma0, 2);
  assert ok;
  assert out == sigma0;
}

lemma ex6()
{
  // Make exec(Seq(Seq(assign1,assign2), If(...)), sigma, 4) succeed and end with z=15
  var assign1 := Assign(x, Num(15));
  var assign2 := Assign(y, Num(15));
  var assign3 := Assign(z, Var(y)); // then
  var assign4 := Assign(z, Var(x)); // else
  var cond := Less(Var(x), Var(y));
  var iff := If(cond, assign3, assign4);
  var seq1 := Seq(assign1, assign2);
  var seq2 := Seq(seq1, iff);

  var sigma := map[x := 0, y := 0, z := 0];

  var out: State; var ok: bool;
  // x==y so cond is false, else branch copies x into z
  call out, ok := exec(seq2, sigma, 5);
  assert ok;
  assert out[x] == 15 && out[y] == 15 && out[z] == 15;
}

