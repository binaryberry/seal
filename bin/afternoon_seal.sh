#!/bin/bash

teams=(
  content-tools
  reliability-engineering
  servicemanual
)

for team in ${teams[*]} ; do
  ./bin/seal.rb $team quotes
done
