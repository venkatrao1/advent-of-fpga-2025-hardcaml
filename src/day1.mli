open! Core
open! Hardcaml

(**
Input interface: the input stream of characters is sent via char_in; pauses between char_in being valid are allowed.
Once the entire input has been sent, a \0 should be sent as well, after which the output will be calculated and transmitted.
*)
module I : sig
  type 'a t =
    { clock : 'a
    ; clear : 'a
    ; char_in : 'a With_valid.t
    }
  [@@deriving hardcaml]
end

(**
Output interface: once the answer has been calculated, answer.valid is set high and answer.answer contains the result.
*)
module O : sig
  type 'a t = { answer : 'a With_valid.t [@bits 32] } [@@deriving hardcaml]
end

module Part1 : sig
    module I = I
    module O = O
    val hierarchical : Scope.t -> Signal.t I.t -> Signal.t O.t
end

module Part2 : sig
    module I = I
    module O = O
    val hierarchical : Scope.t -> Signal.t I.t -> Signal.t O.t
end