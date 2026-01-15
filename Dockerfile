# Dockerfile for development/testing environment

# syntax=docker/dockerfile:1
FROM ocaml/opam:ubuntu-24.04

WORKDIR /home/opam

RUN DEBIAN_FRONTEND=noninteractive sudo apt-get update && sudo apt-get install -y autoconf

# install OxCaml and Hardcaml
# OPAM docker image uses a local clone of repo by default, so update would do nothing unless updated
RUN opam repository set-url default https://opam.ocaml.org && opam update --all
RUN opam switch create 5.2.0+ox --repos ox=git+https://github.com/oxcaml/opam-repository.git,default
RUN eval $(opam env --switch 5.2.0+ox)
RUN opam switch set 5.2.0+ox

# see https://github.com/oxcaml/opam-repository/issues/28
ENV OPAMNOCHECKSUMS="true"

# from installation instructions for OxCaml
RUN opam install -y --no-checksums ocamlformat merlin ocaml-lsp-server utop parallel core_unix && \
	opam clean
# install hardcaml and deps of example repo
RUN opam install -y \
	hardcaml hardcaml_test_harness hardcaml_waveterm ppx_hardcaml \
	core ppx_jane rope re dune \
	&& opam clean