Require Import
        UniMath.CategoryTheory.precategories
        UniMath.CategoryTheory.functor_categories
        UniMath.Ktheory.Utilities
        UniMath.Ktheory.Precategories.

Require Export UniMath.CategoryTheory.precategories.
Require Export UniMath.CategoryTheory.opp_precat
               UniMath.CategoryTheory.yoneda
               UniMath.CategoryTheory.category_hset.
Require Export UniMath.CategoryTheory.functor_categories.
Require Export UniMath.CategoryTheory.category_hset.


Local Open Scope cat.

Set Automatic Introduction.

(** bifunctor commutativity *)

Definition comm_functor_data {I A B:Precategory} :
  [I, [A, B] ] -> A -> functor_data I B
  := λ D a, functor_data_constr I B (λ i, D ◾ i ◾ a) (λ i j e, D ▭ e ◽ a).

Lemma isfunctor_comm_functor_data {I A B:Precategory} :
  ∀ (D:[I,[A,B]]) (a:A), is_functor (comm_functor_data D a).
Proof.
  split.
  { unfold functor_idax. intro i; simpl. unfold functor_mor_application.
    now rewrite functor_id. }
  { intros i j k f g; simpl. unfold functor_mor_application.
    now rewrite functor_comp. }
Qed.

Definition comm_functor {I A B:Precategory} :
  [I, [A, B] ] -> A -> [I,B].
Proof.
  intros D a.
  exists (comm_functor_data D a).
  exact (isfunctor_comm_functor_data D a).
Defined.

Definition comm_functor_data_2 (I A B:Precategory) : functor_data [I,[A,B]] [A,[I,B]].
Proof.
  refine (_,,_).
  { intros D.
    refine (_,,_).
    { refine (_,,_).
      { intros a. exact (comm_functor D a). }
      intros a a' f; simpl.
      refine (_,,_).
      { simpl; intro i. exact (D ◾ i ▭ f). }
      { abstract (intros i j r; simpl; eqn_logic) using L. } }
    { abstract ( split;
                 [ intros a; simpl; apply nat_trans_eq;
                   [ apply homset_property
                   | intros i; simpl; apply functor_id ]
                 | intros a b g r s; simpl; apply nat_trans_eq;
                   [ apply homset_property
                   | simpl; intros i; apply functor_comp ] ] ) using M. } }
  { intros D D' p. simpl.
    refine (_,,_).
    { intros a. simpl.
      refine (_,,_).
      { exact (λ i, p ◽ i ◽ a). }
      { abstract (exact (λ i j e, maponpaths (λ v, v ◽ a) (nat_trans_ax p _ _ e))) using N. } }
    { abstract (intros a b f; apply nat_trans_eq;
                [ apply homset_property
                | intros i; simpl; apply nat_trans_ax]) using O. } }
Defined.

Definition isfunctor_comm_functor_data_2 {I A B:Precategory} :
  is_functor (comm_functor_data_2 I A B).
Proof.
  split.
  { intros D. simpl. apply nat_trans_eq.
    { exact (homset_property [I,B]). }
    simpl; intros a. apply nat_trans_eq.
    { apply homset_property. }
    reflexivity. }
  { intros D D' D'' p q; simpl. apply nat_trans_eq. exact (homset_property [I,B]).
    intros a; simpl. apply nat_trans_eq.
    { apply homset_property. }
    intros i; simpl. eqn_logic. }
Qed.

Definition bifunctor_comm (A B C:Precategory) : [A,[B,C]] ==> [B,[A,C]].
Proof.
  exists (comm_functor_data_2 A B C).
  apply isfunctor_comm_functor_data_2.
Defined.

Lemma transportOverSet {X:UU} {Y:X->UU} (i:isaset X) {x:X} (e:x=x) {y y':Y x} :
  transportf Y e y = y.
Proof.
  exact ((transportf (λ k, transportf Y k y = y) (pr1 (i x x (idpath x) e))) (idpath y)).
Defined.

Lemma comm_comm_iso_id (A B C:Precategory) :
  nat_iso (bifunctor_comm B A C □ bifunctor_comm A B C) (functor_identity _).
Proof.
  intros. refine (makeNatiso _ _).
  { intro F.
    { refine (makeNatiso _ _).
      { intro a. refine (makeNatiso _ _).
        { intro b. exact (identity_iso _). }
        { abstract (intros b b' f; simpl; rewrite id_right, id_left; reflexivity) using L. } }
      abstract (intros a a' f; apply nat_trans_eq;
                [ apply homset_property
                | intro b; simpl; now rewrite id_left, id_right]) using M. } }
  { abstract (intros F F' p; simpl; apply nat_trans_eq;
              [ exact (homset_property [B,C])
              | intro a; apply nat_trans_eq;
                [ apply homset_property
                | intro b; simpl; now rewrite id_right, id_left]]) using N. }
Defined.

Lemma comm_comm_eq_id (A B C:Precategory) :
  bifunctor_comm B A C □ bifunctor_comm A B C = functor_identity _.
Proof.
  intros. refine (total2_paths _ _).
  { refine (total2_paths _ _).
    { apply funextsec; intro F.
      change (pr1 (pr1 (functor_identity [A, [B, C]])) F) with F.
      refine (total2_paths _ _).
      { refine (total2_paths _ _).
        { apply funextsec; intro a. apply functor_eq.
          { apply homset_property. }
          { refine (total2_paths _ _).
            { abstract (apply funextsec; now intro b) using L. }
            { apply funextsec; intro b.
              apply funextsec; intro b'.
              apply funextsec; intro f.


              set (P:=@paths).
              set (MOR:=@precategory_morphisms).

              try reflexivity.
              (* how does one deal with such transports in Coq? *)

Abort.


(** bifunctors related to representable functors  *)

Definition θ_1 {B C:Precategory} (F : [B, C]) (X : [B, [C^op, SET]]) : hSet
  := (∀ b, F ◾ b ⇒ X ◾ b) % set.

Definition θ_2 {B C:Precategory} (F : [B, C]) (X : [B, [C^op, SET]])
           (x : θ_1 F X) : hSet
  := (∀ (b' b:B) (f:b'→b), x b ⟲ F ▭ f = X ▭ f ⟳ x b' ) % set.

Definition θ {B C:Precategory} (F : [B, C]) (X : [B, [C^op, SET]]) : hSet
  := ( Σ x : θ_1 F X, θ_2 F X x ) % set.

Notation "F ⟹ X" := (θ F X) (at level 50) : cat.

Definition θ_subset {B C:Precategory} {F : [B, C]} {X : [B, [C^op, SET]]}
           (t u : F ⟹ X) :
  pr1 t = pr1 u -> t = u.
Proof.
  apply subtypeEquality.
  intros x. apply impred; intro b;apply impred; intro b'; apply impred; intro f.
  apply setproperty.
Defined.

Definition θ_map_1 {B C:Precategory} {F' F:[B, C]} {X : [B, [C^op, SET]]} :
  F' → F -> F ⟹ X -> θ_1 F' X
  := λ p xe b, pr1 xe b ⟲ p ◽ b.

Definition θ_map_2 {B C:Precategory} {F' F:[B, C]} {X : [B, [C^op, SET]]}
  (p : F' → F) (xe : F ⟹ X) : θ_2 F' X (θ_map_1 p xe).
Proof.
  induction xe as [x e]. unfold θ_map_1; unfold θ_1 in x; unfold θ_2 in e.
  intros b' b f; simpl.
  rewrite <- arrow_mor_mor_assoc.
  rewrite nattrans_naturality.
  rewrite arrow_mor_mor_assoc.
  rewrite e.
  rewrite nattrans_arrow_mor_assoc.
  reflexivity.
Qed.

Definition θ_map {B C:Precategory} {F' F:[B, C]} {X : [B, [C^op, SET]]} :
  F' → F -> F ⟹ X -> F' ⟹ X
  := λ p xe, θ_map_1 p xe ,, θ_map_2 p xe.

Notation "xe ⟲⟲ p" := (θ_map p xe) (at level 50) : cat.

Definition φ_map_1 {B C:Precategory} {F:[B, C]} {X' X: [B, [C^op, SET]]} :
  F ⟹ X -> X → X' -> θ_1 F X'
  := λ x p b, p ◽ b ⟳ pr1 x b.

Definition φ_map_2 {B C:Precategory} {F:[B, C]} {X' X: [B, [C^op, SET]]}
  (x : F ⟹ X) (p : X → X') : θ_2 F X' (φ_map_1 x p).
Proof.
  induction x as [x e]. unfold φ_map_1; unfold θ_1 in x; unfold θ_2 in e; unfold θ_2.
  intros b b' f; simpl.
  rewrite <- nattrans_arrow_mor_assoc.
  rewrite e.
  rewrite 2? nattrans_nattrans_arrow_assoc.
  exact (maponpaths (λ k, k ⟳ x b) (nattrans_naturality p f)).
Qed.

Definition φ_map {B C:Precategory} {F:[B, C]} {X' X: [B, [C^op, SET]]} :
  F ⟹ X -> X → X' -> F ⟹ X'
  := λ x p, φ_map_1 x p,, φ_map_2 x p.

Definition bifunctor_assoc {B C:Precategory} : [B, [C^op,SET]] ==> [[B,C]^op,SET].
Proof.
  refine (makeFunctor _ _ _ _).
  { intros X.
    refine (makeFunctor_op _ _ _ _).
    { intro F. exact (F ⟹ X). }
    { intros F' F p xe. exact (xe ⟲⟲ p). }
    { abstract (
          intros F; apply funextsec; intro xe; apply θ_subset;
          simpl; apply funextsec; intro b; apply arrow_mor_id) using K. }
    { abstract (
          intros F F' F'' p q; simpl; apply funextsec; intro xe; apply θ_subset;
          simpl; apply funextsec; intro b;
          unfold θ_map_1; exact (arrow_mor_mor_assoc _ _ _)) using L. } }
  { intros X Y p. simpl.
    refine (_,,_).
    { intros F. simpl. intro x. exact (φ_map x p). }
    { abstract (
          intros F G q; simpl in F, G; simpl;
          apply funextsec; intro w;
          refine (total2_paths2 _ _);
          [ apply funextsec; intro b;
            unfold φ_map, φ_map_1, θ_map_1; simpl;
            unfold θ_map_1; simpl;
            apply nattrans_arrow_mor_assoc
          | apply funextsec; intro b;
            apply funextsec; intro b';
            apply funextsec; intro b'';
            apply setproperty ]) using L. } }
  { abstract( simpl;
    intro F;
    apply nat_trans_eq;
    [ exact (homset_property SET)
    | intro G;
      simpl;
      unfold φ_map; simpl; unfold φ_map_1; simpl;
      apply funextsec; intro w;
      simpl;
      refine (total2_paths _ _);
      [ simpl; apply funextsec; intro b; reflexivity
      | apply funextsec; intro b;
        apply funextsec; intro b';
        apply funextsec; intro f;
        simpl;
        apply setproperty] ]) using L. }
  { abstract (intros F F' F'' p q;
              simpl;
              apply nat_trans_eq;
              [ exact (homset_property SET)
              | intro G;
                simpl;
                apply funextsec; intro w;
                refine (total2_paths2 _ _);
                [ unfold φ_map, φ_map_1; simpl;
                  apply funextsec; intro b;
                  apply pathsinv0, nattrans_nattrans_arrow_assoc
                | apply funextsec; intro b;
                  apply funextsec; intro b';
                  apply funextsec; intro f;
                  apply setproperty ]]) using L. }
Defined.

(* *)
