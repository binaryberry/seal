#!/bin/bash

teams=(
  content-tools
  modelling-services
  reliability-engineering
)

for team in ${teams[*]} ; do
  ./bin/seal.rb $team quotes
done
