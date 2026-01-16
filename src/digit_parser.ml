(** Given an ASCII character, output its corresponding binary digit. *)
open! Core
open! Hardcaml
open! Signal

module I = struct
  type 'a t = { char_in : 'a [@bits 8] } [@@deriving hardcaml]
end

module O = struct
  type 'a t = { digit : 'a With_valid.t [@bits 4] } [@@deriving hardcaml]
end

let create _scope ({ char_in } : _ I.t) : _ O.t
  =
  (* bottom 4 bits of ASCII number are just its binary representation *)
  { digit = { value = sel_bottom char_in ~width:4; valid = (char_in >=: of_char '0') &&: (char_in <=: of_char '9')} }
;;

(* The [hierarchical] wrapper is used to maintain module hierarchy in the generated
   waveforms and (optionally) the generated RTL. *)
let hierarchical scope =
  let module Scoped = Hierarchy.In_scope (I) (O) in
  Scoped.hierarchical ~scope ~name:"digit_parser" create
;;
