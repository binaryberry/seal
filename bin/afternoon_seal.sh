#!/bin/bash

teams=(
  data-informed-content
  modelling-services
  reliability-engineering
  gov-uk-licensing-support
)

for team in ${teams[*]} ; do
  ./bin/seal.rb $team quotes
done
