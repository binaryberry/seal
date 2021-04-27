#!/bin/bash

teams=(
  data-informed-content
  porg-pages
  reliability-engineering
  gov-uk-licensing-support
)

for team in ${teams[*]} ; do
  ./bin/seal.rb $team quotes
done
