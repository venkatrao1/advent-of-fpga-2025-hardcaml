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

## Solution approaches

### Day 1 ([source](src/day1.ml))

For day 1, the main state to keep track of is our current position on the dial (from 0-99).
Our position wraps around at either end of this range - when rotating left, we underflow back to 99 after 0, and when rotating right, we overflow from 99 to 0.

Instead of handling both overflow cases, I chose to flip the current position whenever the current direction changes (this works because the problem is symmetric; rotating left by X is the same as mirroring our current position, then rotating right by X.)

For part 1, we simply check if the next position will be equal to zero, and add one to our answer if so.

For part 2, we need to also get the number of times that we pass zero:
1. If the input rotation is larger than 100, we can simply add the input, excluding the last two digits, to our answer. This adds floor(input / 100) to our answer, which is the number of full rotations on this line.
2. If the position is overflowing, we know that we must have crossed 0, so we add an additional 1 to our answer. (Underflow doesn't happen, because we flip our current position and then add instead of rotating counterclockwise, as described above.)