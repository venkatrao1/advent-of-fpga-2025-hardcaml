"Hardcaml Template Project"
===========================


This repository provides a simple starter template for getting started with Hardcaml, including:

- An RTL design that accepts a stream of numbers and calculates the range of the values,
  including use of the Always DSL to construct a state-machine
- A testbench, including waveform printing and VCD export using `hardcaml_test_harness`
- A binary to generate RTL for synthesis

## Installing Hardcaml

A [Dockerfile](Dockerfile) is provided that installs OxCaml and Hardcaml.

Alternatively, see the Hardcaml template project's README section on installing Hardcaml [here](https://github.com/janestreet/hardcaml_template_project/blob/f27e421f20ff3c35b36d183199442c5260e5a4c7/README.md#installing-hardcaml).

## Building the Example Project

To build the project, clone this repository and then run the following command, which will
build the generator binary (note the exe prefix is standard for OCaml, even on Unix
systems), as well as building and running all of the tests.

```
dune build bin/generate.exe @runtest
```

To validate that the tests are running, try changing one of the input values in
`test_range_finder.ml` and re-running the tests, to see if the printed values change. Once
`dune` shows a diff in the tests, it can be accepted using the following command (this
will modify the file in-place, so you may need to close and re-open it):

```
dune promote
```

For more on how expect-tests work, see [this blog post](https://blog.janestreet.com/the-joy-of-expect-tests/)

### Viewing Waveforms

Hardcaml has two main ways to view waveforms:

- Exporting to a `.hardcamlwaveform` file, which, can be viewed using the Hardcaml
  terminal waveform viewer.
  - To try this, uncomment the `waves_config` definition that sets the format to
    `Hardcamlwaveform`, then run the tests again. The file should save into `/tmp/` by
    default.
  - To run the viewer, `hardcaml-waveform-viewer show file.hardcamlwaveform` (if the
    command isn't available, make sure you've activated the opam switch in the same shell
    you're trying to run in, see above)
  - Some more details on using the viewer are available [here](
    https://www.janestreet.com/web-app/hardcaml-docs/simulating-circuits/waveterm_interactive_viewer)

- Exporting to a `.vcd` file, which can be viewed using standard tools like
  [GTKWave](https://gtkwave.sourceforge.net/) and [Surfer](https://surfer-project.org/)
  - To try this, uncomment the `waves_config` definition that sets the format to
    `Vcd`, then run the tests again. The file should save into `/tmp/` by default.

For small tests, waveforms can also be printed inline (as shown in
`test_range_finder.ml`), which is useful for documenting and visualizing design behavior,
albeit not as useful for interactive debugging.

### Generating RTL

To generate RTL, run the compiled `generate.exe` binary, which will print the Verilog source:
```
bin/generate.exe range-finder
```

Note that dune should automatically copy the compiled binary into your source directory,
but if it does not, all build products can be found in `_build/default/`.

## Resources

- If you would like to run dune continuously to re-run tests every time a file is edited:

```
dune build --watch --terminal-persistence=clear-on-rebuild-and-flush-history bin/generate.exe @runtest
```

- Hardcaml documentation and further tutorials [can be found
  here](https://www.janestreet.com/web-app/hardcaml-docs/introduction/why/)

- Real World OCaml is a [free online book](https://dev.realworldocaml.org/toc.html) for learning OCaml

- The OCaml LSP and autoformatter can be used with VSCode, Emacs, and Vim, [see
  instructions here](https://dev.realworldocaml.org/install.html#editor-setup)
