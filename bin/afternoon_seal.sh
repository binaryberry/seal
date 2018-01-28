#!/bin/bash

teams=(
  data-informed-content
  modelling-services
  reliability-engineering
)

for team in ${teams[*]} ; do
  ./bin/seal.rb $team quotes
done
