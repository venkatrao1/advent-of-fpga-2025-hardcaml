Advent of FPGA 2025
===========================

## Installing Hardcaml

A [Dockerfile](Dockerfile) is provided that installs OxCaml and Hardcaml.
If you use the VS Code dev containers extension, you should see a pop-up for automatic environment set up when opening the repository.
The container may take a long time to install all OCaml packages needed.

Alternatively, see the Hardcaml template project's README section on installing Hardcaml [here](https://github.com/janestreet/hardcaml_template_project/blob/f27e421f20ff3c35b36d183199442c5260e5a4c7/README.md#installing-hardcaml).

## Simulating

In order to run the solution on your own test input, a simulation binary (bin/sim.ml) is provided.
To build it:
```sh
dune build bin/sim.exe
```

To run against a custom input:
```sh
# bin/sim.exe <dut> <infile>
bin/sim.exe day1-part1 test_inputs/sample1.txt
```

## Building

To build the project, clone this repository and then run the following command, which will
build the generator binary (note the exe prefix is standard for OCaml, even on Unix
systems), as well as building and running all of the tests.

```sh
dune build bin/generate.exe @runtest
```

### Generating RTL

To generate RTL, run the compiled `generate.exe` binary, which will print the Verilog source:
```sh
bin/generate.exe part1-day1 # or part1-day2
```

Note that dune should automatically copy the compiled binary into your source directory,
but if it does not, all build products can be found in `_build/default/`.
