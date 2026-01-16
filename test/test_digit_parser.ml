open! Core
open! Hardcaml
open! Hardcaml_test_harness
module Digit_parser = Hardcaml_demo_project.Digit_parser
module Harness = Cyclesim_harness.Make (Digit_parser.I) (Digit_parser.O)

let simple_testbench (sim : Harness.Sim.t) =
  let inputs = Cyclesim.inputs sim in
  let outputs = Cyclesim.outputs sim in
  let cycle ?n () = Cyclesim.cycle ?n sim in

  for ascii_value = 0 to 255 do
    inputs.char_in := Bits.of_int_trunc ~width:8 ascii_value;
    cycle ();
    let input_digit = Char.get_digit (Char.of_int_exn ascii_value) in
    let output_digit = if Bits.to_bool !(outputs.digit.valid) then
      Some (Bits.to_int_trunc !(outputs.digit.value))
    else
      None
    in
    assert (Option.equal Int.equal input_digit output_digit);
  done
;;

let%expect_test "Test" =
  Harness.run_advanced ~create:Digit_parser.hierarchical simple_testbench;
;;
