Set Implicit Arguments.

Require Import Relation.
Require Import Syntax.
Require Import Semantics.
Require Import Coq.Classes.Equivalence.
Require Import Coq.Arith.EqNat.
Require Import Coq.Logic.FunctionalExtensionality.
Require Import Coq.Setoids.Setoid.

 Existing Instances Equivalence_exp.
 Local Open Scope equiv_scope.

 Lemma KA_Plus_Zero: 
   forall (e : exp), (pol e) -> 
     (Par e Drop) === e.
 Proof with auto.
  intros. split. 
  + intros. simpl in *. unfold union in H0. destruct H0.
    - trivial.
    - unfold empty in H0. contradiction.
  + intros. simpl in *. unfold union. left. trivial.
 Qed.

 Lemma KA_Plus_Idem:
   forall (e : exp), (pol e) ->
     (Par e e) === e.
 Proof with auto.
  intros. split.
  + intros. simpl in *. unfold union in H0. destruct H0.
    - trivial.
    - trivial.
  + intros. simpl. unfold union. right. trivial.
 Qed.

 Lemma KA_One_Seq:
   forall (e : exp), (pol e) ->
     (Seq Id e) === e.
 Proof with auto.
  intros. split.
  + intros. simpl in *. unfold join in H0. destruct H0. destruct H0.
    unfold id in H0. subst...
  + intros. simpl. unfold join. exists x. split. unfold id... auto.
 Qed.

 Lemma KA_Seq_One:
   forall (e : exp), (pol e) -> (Seq e Id) === e.
 Proof with auto.
   intros. split.
  + intros. simpl in *. unfold join in H0. destruct H0. destruct H0.
    unfold id in H1. subst...
  + intros. simpl. unfold join. exists y. split. auto. unfold id...
 Qed.

 Lemma KA_Zero_Seq:
   forall (e : exp), (pol e) -> (Seq Drop e) === Drop.
 Proof with auto.
   intros. split.
   + intros. simpl in *. unfold join in H0. destruct H0. unfold empty. intuition. 
   + intros. simpl in *. unfold empty. contradiction.
 Qed.

 Lemma KA_Seq_Zero:
   forall (e : exp), (pol e) -> (Seq e Drop) === Drop.
 Proof with auto.
   intros. split.
   + intros. simpl in H0. unfold join in H0. destruct H0. unfold empty. intuition.
   + intros. simpl in H0. unfold empty in H0. intuition.
 Qed.
 
 Lemma KA_Plus_Assoc:
   forall (e1 e2 e3 : exp), (pol e1) -> (pol e2) -> (pol e3) ->
     (Par e1 (Par e2 e3)) === (Par (Par e1 e2) e3).
 Proof with auto.
   intros. split.
   + intros. simpl in *. unfold union in *. intuition.
   + intros. simpl in *. unfold union in *. intuition.
 Qed.

 Lemma KA_Plus_Comm: 
   forall (e1 e2 : exp), (pol e1) -> (pol e2) -> 
     (Par e1 e2) === (Par e2 e1).
 Proof with auto.
   intros. split.
   + intros. simpl in *. unfold union in *. intuition.
   + intros. simpl in *. unfold union in *. intuition.
 Qed.

 Lemma KA_Seq_Assoc:
   forall (e1 e2 e3 : exp), (pol e1) -> (pol e2) -> (pol e3) ->
     (Seq e1 (Seq e2 e3)) === (Seq (Seq e1 e2) e3).
 Proof with auto.
   intros. split.
   + intros. simpl in *. unfold join in *. destruct H2. destruct H2. destruct H3. destruct H3.
     exists x1. split. exists x0. split. intuition. auto. auto.
   + intros. simpl in *. unfold join in *. destruct H2. destruct H2. destruct H2. destruct H2.
     exists x1. split. auto. exists x0. auto.
 Qed.

 Lemma KA_Seq_Dist_L :
   forall (e1 e2 e3 : exp), (pol e1) -> (pol e2) -> (pol e3) ->
     (Seq e1 (Par e2 e3)) === (Par (Seq e1 e2) (Seq e1 e3)).
 Proof with auto.
   intros. split.
   + intros. simpl in *. unfold join in *. destruct H2. unfold union in *.
     destruct H2. destruct H3. left. exists x0. intuition.
     right. exists x0. intuition.
   + intros. simpl in *. unfold join in *. unfold union in *. destruct H2.
     destruct H2. exists x0. destruct H2. split. intuition. intuition.
     destruct H2. exists x0. destruct H2. split. intuition. intuition.
 Qed.
  
 Lemma KA_Seq_Dist_R:
   forall (e1 e2 e3 : exp), (pol e1) -> (pol e2) -> (pol e3) ->
     (Seq (Par e1 e2) e3) === (Par (Seq e1 e3) (Seq e2 e3)).
 Proof with auto.
   intros. split.
   + intros. simpl in *. unfold join in *. unfold union in *. destruct H2.
     destruct H2. destruct H2. left. exists x0. intuition.
     right. exists x0. intuition.
   + intros. simpl in *. unfold join in *. unfold union in *.
     destruct H2. destruct H2. destruct H2. exists x0. 
     split. intuition. auto.
     destruct H2. destruct H2. exists x0. split. intuition. auto.
 Qed. 

 Lemma KA_Unroll_L:
   forall (e : exp), (pol e) ->
     (Par Id (Seq e (Star e))) === (Star e).
 Proof with auto.
   intros. split.
   + intros. simpl in *. unfold union in H0. unfold join in H0. unfold star in *.
     destruct H0.
     - exists 0. simpl. auto.
     - destruct H0. destruct H0. destruct H1.
       exists (S x1). simpl in *. unfold join. exists x0. intuition.
   + intros. simpl in *. unfold union. unfold join. unfold star in *.
     destruct H0. induction x0.
     - left. simpl in H0. apply H0.
     - simpl in H0. unfold join in H0. right. destruct H0. exists x1.
       split. destruct H0. trivial. destruct H0. exists x0. auto.
 Qed.

 Lemma KA_Unroll_R:
   forall (e : exp), (pol e) -> 
     (Par Id (Seq (Star e) e)) === (Star e).
 Proof with auto.
   intros. split.
   + intros. simpl in *. unfold union in H0. unfold join in H0. unfold star in *.
     destruct H0. 
     - exists 0. simpl. auto.
     - destruct H0. destruct H0. destruct H0. exists (S x1). simpl in *. unfold join.
  Admitted.