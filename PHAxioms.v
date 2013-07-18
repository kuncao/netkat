Set Implicit Arguments.

Require Import Relation.
Require Import Syntax.
Require Import Semantics.
Require Import KAAxioms.
Require Import Coq.Classes.Equivalence.
Require Import Coq.Arith.EqNat.
Require Import Coq.Logic.FunctionalExtensionality.
Require Import Coq.Setoids.Setoid.

 Existing Instances Equivalence_exp.
 Local Open Scope equiv_scope.
 
 Lemma PA_Mod_Mod_Comm_Help: 
   forall (f1 f2 : field) (x : packet) (n1 n2 : nat), ~(f1 = f2) ->
   set_field_p (set_field_p x f1 n1) f2 n2 = set_field_p (set_field_p x f2 n2) f1 n1.
 Proof with auto.
   intros. destruct x. 
   destruct f1; destruct f2; try solve [simpl; auto | contradiction H; auto]. 
 Qed.  

 Lemma PA_Mod_Mod_Comm_Help2:
   forall (f1 f2 : field) (x : history) (n1 n2 : nat), ~(f1 = f2) ->
     set_field (set_field x f1 n1) f2 n2 = set_field (set_field x f2 n2) f1 n1.
 Proof with auto.
   intros.
   destruct x; simpl; rewrite -> PA_Mod_Mod_Comm_Help...
 Qed.
      
 Lemma PA_Mod_Mod_Comm:
   forall (f1 f2 : field) (n1 n2 : nat), ~(f1 = f2) -> 
    (Seq (Mod f1 n1) (Mod f2 n2)) 
     === (Seq (Mod f2 n2) (Mod f1 n1)).
 Proof with auto.
   intros. split.
   + intros. simpl in *. unfold join in *. destruct H0 as [z [H1 H2]].
     subst. exists (set_field x f2 n2). split... apply PA_Mod_Mod_Comm_Help2...
   + intros. simpl in *. unfold join in *. destruct H0 as [z [H1 H2]].
     subst. exists (set_field x f1 n1). split... apply PA_Mod_Mod_Comm_Help2...
 Qed.

 Lemma set_other_field_not_effect:
   forall (f1 f2 : field) (n1 n2 : nat) (x : history), ~(f1 = f2) ->
     (get_Field (get_Packet (set_field x f1 n1)) f2) =
     (get_Field (get_Packet x) f2).
   Proof with auto.
     intros. destruct x. destruct p.
     + destruct f1; destruct f2.
       - contradiction H...
       - simpl...
       - simpl...
       - contradiction H...
     + destruct f1; destruct f2.
       - contradiction H...
       - simpl... 
       - simpl...
       - contradiction H...
 Qed.
    
 Lemma PA_Mod_Filter_Comm:
   forall (f1 f2 : field) (n1 n2 : nat), ~(f1 = f2) ->
     (Seq (Mod f1 n1) (Match f2 n2)) === (Seq (Match f2 n2) (Mod f1 n1)).
 Proof with auto.
   intros. split.
   + intros. simpl in *. unfold join in *. destruct H0 as [z [H1 H2]]. subst.
     remember (beq_nat (get_Field (get_Packet (set_field x f1 n1)) f2) n2).
     destruct b... subst. exists x. split... subst. 
     rewrite set_other_field_not_effect in Heqb. rewrite <- Heqb...
     trivial. trivial. contradiction.
   + intros. simpl in *. unfold join in *. destruct H0 as [z [H1 H2]].
     subst. rewrite <- set_other_field_not_effect with (f1 := f1) (n1 := n1) in H1...
     remember (beq_nat (get_Field (get_Packet (set_field x f1 n1)) f2) n2).
     destruct b. subst. exists (set_field z f1 n1). split... rewrite <- Heqb...
     contradiction.
 Qed.

 
      
     
       
 