open! Core
open! Hardcaml

module I : sig
  type 'a t =
    { clock : 'a
    ; clear : 'a
    ; char_in : 'a With_valid.t
    }
  [@@deriving hardcaml]
end

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