(** Given an ASCII character, output its corresponding binary digit. *)

open! Core
open! Hardcaml

module I : sig
  type 'a t = { char_in : 'a } [@@deriving hardcaml]
end

(* Value is valid if input was "0"-"9" *)
module O : sig
  type 'a t = { digit : 'a With_valid.t } [@@deriving hardcaml]
end

val hierarchical : Scope.t -> Signal.t I.t -> Signal.t O.t
