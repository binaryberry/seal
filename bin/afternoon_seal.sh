#!/bin/bash

teams=(
  content-tools
  govuk-easier-finding
  reliability-engineering
  search-team
  servicemanual
)

for team in ${teams[*]} ; do
  ./bin/seal.rb $team quotes
done
