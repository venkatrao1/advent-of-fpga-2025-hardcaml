open! Core
open! Hardcaml
open! Hardcaml_demo_project

module type Synthesizable_circuit = sig
  module I : Hardcaml.Interface.S
  module O : Hardcaml.Interface.S

  val hierarchical : Scope.t -> (Signal.t I.t -> Signal.t O.t)
end

module Generate_rtl_functor (Circuit_module: Synthesizable_circuit) = struct
  let generate_rtl () =
    let module C = Circuit.With_interface (Circuit_module.I) (Circuit_module.O) in
    let scope = Scope.create ~auto_label_hierarchical_ports:true () in
    let circuit = C.create_exn ~name:"top" (Circuit_module.hierarchical scope) in
    let rtl_circuits =
      Rtl.create ~database:(Scope.circuit_database scope) Verilog [ circuit ]
    in
    let rtl = Rtl.full_hierarchy rtl_circuits |> Rope.to_string in
    print_endline rtl
  ;;

  let generate_rtl_command = Command.basic
    ~summary:""
    [%map_open.Command
      let () = return () in
      fun () -> generate_rtl ()]
  ;;
end

module Range_finder_gen = Generate_rtl_functor(Range_finder)
module Digit_parser_gen = Generate_rtl_functor(Digit_parser)
module Day1_part1_gen = Generate_rtl_functor(Day1.Part1)

let () =
  Command_unix.run
    (Command.group ~summary:""
      [ "range-finder", Range_finder_gen.generate_rtl_command
      ; "digit-parser", Digit_parser_gen.generate_rtl_command
      ; "day1-part1", Day1_part1_gen.generate_rtl_command
      ]
    )
;;
