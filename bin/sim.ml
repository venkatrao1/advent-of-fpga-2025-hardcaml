(** Simulate a design under test on an input file *)

open! Core
open! Hardcaml
open! Hardcaml_test_harness

module Day1 = Hardcaml_demo_project.Day1

(* TODO: If implementing more days, move circuit interface to a common module *)

let ( <--. ) = Bits.( <--. )

module type Sim_circuit = sig
  val hierarchical : Scope.t -> (Signal.t Day1.I.t -> Signal.t Day1.O.t)
end

let filename_param =
  let open Command.Param in
  anon ("filename" %: string)

module Sim_Make (Circuit_module: Sim_circuit) = struct
  module Harness = Cyclesim_harness.Make (Day1.I) (Day1.O)

  let simple_testbench (sample_input: string) (sim : Harness.Sim.t) =
    let inputs = Cyclesim.inputs sim in
    let outputs = Cyclesim.outputs sim in
    let cycle ?n () = Cyclesim.cycle ?n sim in
    (* Helper function for inputting one value *)
    let feed_input n =
      inputs.char_in.value <--. Char.to_int n;
      inputs.char_in.valid := Bits.vdd;
      cycle ();
      inputs.char_in.valid := Bits.gnd;
      cycle ()
    in
    (* Reset the design *)
    inputs.char_in.valid <--. 0;
    inputs.char_in.value <--. 0;
    inputs.clear := Bits.vdd;
    cycle ();
    inputs.clear := Bits.gnd;
    cycle ();
    (* Input sample file *)
    String.iter sample_input ~f:(fun x -> feed_input x);
    feed_input (Char.of_int_exn 0); (* null terminator *)

    (* Wait for result to become valid *)
    while not (Bits.to_bool !(outputs.answer.valid)) do
      cycle ()
    done;
    let answer = Bits.to_unsigned_int !(outputs.answer.value) in

    (* Just write answer to stdout *)
    print_endline (Int.to_string answer);
  ;;


  let run_sim (input: string) = Harness.run_advanced ~waves_config:Waves_config.no_waves ~create:Circuit_module.hierarchical (simple_testbench input)

  let sim_command = Command.basic
    ~summary:""
    (Command.Param.map filename_param ~f:(fun filename () -> run_sim(In_channel.read_all filename)))
  ;;
end

module Part1_Sim = Sim_Make(Day1.Part1)
module Part2_Sim = Sim_Make(Day1.Part2)


let () =
  Command_unix.run
    (Command.group ~summary:""
      [ "day1-part1", Part1_Sim.sim_command
      ; "day1-part2", Part2_Sim.sim_command
      ]
    )
;;