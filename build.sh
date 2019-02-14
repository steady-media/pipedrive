#!/usr/bin/env bash
  mix compile --force --warnings-as-errors && \
  mix credo && \
  mix dialyzer && \
  mix coveralls && \
  mix docs && \
  open doc/index.html