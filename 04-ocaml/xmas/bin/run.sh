#!/usr/bin/env bash
set -euxo pipefail

ocaml -I "str" main.ml
