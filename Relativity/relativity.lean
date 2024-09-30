import Mathlib.Data.Set.Basic
import Mathlib

set_option diagnostics true
--set_option diagnostics.threshold 80

@[ext]
structure Point4 where
  x : ℝ
  y : ℝ
  z : ℝ
  t : ℝ

@[ext]
structure Point3 where
  x : ℝ
  y : ℝ
  z : ℝ

def pointSpace (p : Point4) : Point3 := Point3.mk p.x p.y p.z
def pointTime (p : Point4) : ℝ := p.t
def pointSpaceMinus (p q: Point3): Point3 := Point3.mk (p.x - q.x) (p.y - q.y) (p.z - q.z)
def pointSpaceAbsSq (p : Point3) : ℝ := p.x ^ 2 + p.y ^ 2 + p.z ^ 2
def spaceNormSq (p q : Point4) : ℝ := pointSpaceAbsSq (pointSpaceMinus (pointSpace p) (pointSpace q))

def zeroCoord : Point4 where
  x := 0
  y := 0
  z := 0
  t := 0

def oneCoord : Point4 where
  x := 1
  y := 0
  z := 0
  t := 1

opaque U : Type
opaque B : Type -- Bodies
opaque IB : B → Prop -- Inertial bodies predicate
opaque Ph : B → Prop -- Photon predicate
opaque W : B → B → Point4 → Prop -- Worldview


def Ob (m : B) := ∃ (b : B) (pt : Point4 ) , W m b pt -- Define observers

def IOb (m : B) := IB m ∧ Ob m -- Define inertial observers

def events (m : B) (x : Point4) : Set B := { b | W m b x } -- events observed by m at x

-- AXIOM 1: "For any inertial observer, the speed of light is the same everywhere and in every direction, and it is finite. Furthermore, it is possible to send out a light signal in any direction."

def AxPh : Prop := ∀ (m : B), ∃ (c : ℝ), ∀ (x y : Point4), IOb m →
  (∃ (p : B), Ph p ∧ W m p x ∧ W m p y) ↔ (spaceNormSq x y = c * (abs (pointTime y - pointTime x)) ^ 2)

axiom axph : AxPh
-- END AXIOM


-- AXIOM 2: "All inertial observers coordinatize the same set of events."
def AxEv : Prop := ∀ (m k : B), IOb m ∧ IOb k → ∀ (x : Point4), ∃ (y : Point4), events m x = events k y

axiom axev : AxEv
-- END AXIOM

-- AXIOM 3: "Any inertial observer sees himself as standing still at the origin."
def AxSf : Prop := ∀ (m : B), IOb m → ∀ (x : Point4), W m m x ↔ x.x = 0 ∧ x.y = 0 ∧ x.z = 0

axiom axsf : AxSf
-- END AXIOM

-- AXIOM 4a : " Any two inertial observers agree as to the spatial distance between two events if these two events are simultaneous for both of them."

def AxSmA : Prop := ∀ (m k : B), IOb m ∧ IOb k → ∀ (x y x' y' : Point4), (pointTime x = pointTime y) ∧ (pointTime x' = pointTime y') ∧ (events m x = events k x') ∧ (events m y = events k y) → spaceNormSq x y = spaceNormSq x' y'

axiom axsm : AxSmA
-- END AXIOM

-- AXIOM 4b : "the speed of light is 1 for all observers."
def AxSmB : Prop := ∀ (m : B), IOb m → ∃ (p : B), Ph p ∧ W m p zeroCoord ∧ W m p oneCoord

axiom axsmb : AxSmB
-- END AXIOM
