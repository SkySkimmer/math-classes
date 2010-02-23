Set Automatic Introduction.

Require Import
 Morphisms List Program
 abstract_algebra theory.categories forget_algebra forget_variety.
Require
 (*ua_forget*) categories.setoid categories.product varieties.monoid categories.algebra.

Module setoidcat := categories.setoid.
Module productcat := categories.product.
Module ua := universal_algebra.

Definition forget_everything: monoid.Object -> product.Object _ (fun _ => setoid.Object) :=
  forget_object ∘ (forget_object: _ -> algebra.Object monoid.theory).

Section seq_ops.

  Variable A S: Type.

  Class SeqInject := seq_inject: A -> S.
  Class SeqToMonoid := seq_to_monoid: forall B `{SemiGroupOp B} `{MonoidUnit B}, (A -> B) -> S -> B.

  (* Given a SeqToMonoid that happens to map morphisms to morphisms, we can write it as
   function from arrows to arrows. In this form it can be passed to proves_free in the
   definition of Sequence below. *)

  Context
    {ae: Equiv A} `{!Equivalence ae} `{Monoid S} {sm: SeqToMonoid}
    {seq_to_monoid_mor: forall `{Monoid M} (f: A -> M), Setoid_Morphism f -> Monoid_Morphism (sm M _ _ f) }.

(*  Implicit Arguments varieties.monoid.arrow_from_morphism_from_instance_to_object [[A] [H] [op0] [unit0] [H0] [B] [fmor]].
*)

  Lemma seq_to_monoid_categorical (y: monoid.Object):
    product.Arrow () (fun _ : () => setoid.Object) (fun _ : () => setoid.Arrow)
      (fun _ : () => setoid.object A _ _) (forget_everything y) ->
    monoid.Arrow (monoid.object S) y.
  Proof.
  Admitted. (*

      (X:
     product.Arrow unit (fun _ => setoidcat.Object) (fun _ => setoid.Arrow)
       (fun _ => setoidcat.Build_Object A _ _)
       (ua_forget.forget_object varieties.monoid.theory y)): ua_variety.Arrow varieties.monoid.theory (varieties.monoid.object S) y.
  Proof.
    set (sm (y _) _ _ (X _)).
    assert (Monoid_Morphism v).
     apply seq_to_monoid_mor.
      apply _.
     exact (setoidcat.mor _ _ (X tt)).
    apply (varieties.monoid.arrow_from_morphism_from_instance_to_object v).
  Defined.
    (* todo: write as term using Program *)
*)
End seq_ops.

Instance: Params (@seq_to_monoid) 7.



Class Sequence (A S: Type) {ae: Equiv A} `{!Equiv S} `{!SemiGroupOp S} `{!MonoidUnit S}
  {si: SeqInject A S} {sm: SeqToMonoid A S} :=
  { seq_monoid:> Monoid S
  ; aequiv:> Equivalence ae
  ; seq_inject_mor:> Setoid_Morphism si
  ; A_setoid := setoidcat.object A _ _
  ; S_setoid := setoidcat.object S _ _
  ; seq_free: @proves_free
       monoid.Object monoid.Arrow _
       (product.Object unit (fun _ => setoid.Object))
       (product.Arrow unit (fun _ => setoid.Object) (fun i => setoid.Arrow)) _ _ forget_everything _ (fun _ => A_setoid)
       (monoid.object S) (fun u => setoid.arrow A_setoid (forget_everything (monoid.object S) u) si _) 
         (seq_to_monoid_categorical tt)
  }.

  ; seq_inject_arrow := setoidcat.Build_Arrow A_setoid S_setoid si _
  ; seq_to_monoid_mor:> forall `{Monoid M} (f: A -> M), Setoid_Morphism f -> Monoid_Morphism (sm M _ _ f)
   ; c := @seq_to_monoid_categorical A S _ _ _ _ _ _ _ (@seq_to_monoid_mor)
  ; seq_free: @proves_free _ _ _ _ _ _ _ 
      (ua_forget.forget_object varieties.monoid.theory) (ua_forget.forget_arrow varieties.monoid.theory)
      (fun _ => A_setoid) (varieties.monoid.object S) (fun _ => seq_inject_arrow) c
  }.