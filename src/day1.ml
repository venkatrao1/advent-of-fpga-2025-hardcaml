open! Core
open! Hardcaml
open! Signal

module I = struct
  type 'a t =
    { clock : 'a
    ; clear : 'a
    ; char_in : 'a With_valid.t [@bits 8]
    }
  [@@deriving hardcaml]
end

module O = struct
  type 'a t = { answer : 'a With_valid.t [@bits 32] } [@@deriving hardcaml]
end

module Make(Config: sig val is_part_1 : bool end) = struct
  module I = I
  module O = O

  let create scope ({ clock; clear; char_in } : _ I.t) : _ O.t
    =
    let spec = Reg_spec.create ~clock ~clear () in
    let open Always in
    let%hw_var tens_place = Variable.reg spec ~width:4 in
    let%hw_var ones_place = Variable.reg spec ~width:4 in
    let%hw_var answer = Variable.reg spec ~width:32 in
    let%hw_var answer_valid = Variable.reg spec ~width:1 in
    let%hw_var pos = Variable.reg spec ~width:7 ~clear_to:(of_int_trunc ~width:7 50) in (* 0-99 *)
    let%hw_var facing_right = Variable.reg spec ~width:1 in (* Instead of having to handle wrapping <0 and >=100, just always rotate clockwise and flip current pos when we switch dirs *)
    let%hw_var facing_right_next = Variable.wire ~default:gnd () in
    let%hw_var pos_next = Variable.wire ~default:(zero 7) () in
    let digit_parsed = Digit_parser.hierarchical scope { char_in=char_in.value } in
    compile [
      (
        let next_pos_not_wrapped = (tens_place.value *: Signal.of_int_trunc ~width: 4 10) +: (uresize ~width:8 ones_place.value) +: (uresize ~width:8 pos.value) in
        let hundred = of_int_trunc ~width:8 100 in
        pos_next <-- uresize ~width:7 (mux2 (next_pos_not_wrapped >=: hundred) (next_pos_not_wrapped -: hundred) next_pos_not_wrapped)
      );

      if_ char_in.valid [
        facing_right_next <-- cases
          ~default:facing_right.value (* default to old value *)
          char_in.value
        [
          of_char 'L', gnd;
          of_char 'R', vdd;
        ];
        if_ (facing_right_next.value <>: facing_right.value) [ (* changing direction - flip current pos *)
          facing_right <-- facing_right_next.value;
          pos <-- mux2 (pos.value <>: zero 7) ((of_int_trunc ~width:7 100) -: pos.value) (zero 7); (* 0 flips to itself, otherwise 100 - last pos *)
        ] [];
        if_ (char_in.value ==: of_char '\n') [
          (* Newline - add accumulated value to pos *)
          ones_place <-- zero 4;
          tens_place <-- zero 4;
          pos <-- pos_next.value;
          answer <-- answer.value +: (uresize ~width:32 (mux2 (pos_next.value ==: zero 7) vdd gnd))
        ] [];


        if_ digit_parsed.digit.valid [
          ones_place <-- digit_parsed.digit.value;
          tens_place <-- ones_place.value;
        ][];

        answer_valid <-- (char_in.value ==: zero 8)
      ] [];
    ];
    { answer = { value = answer.value; valid = answer_valid.value } }
  ;;

  let hierarchical scope =
    let module Scoped = Hierarchy.In_scope (I) (O) in
    Scoped.hierarchical ~scope ~name:(if Config.is_part_1 then "day1_part1" else "day1_part2") create
  ;;
end

module Part1 = Make (struct let is_part_1 = true end)
module Part2 = Make (struct let is_part_1 = false end)
