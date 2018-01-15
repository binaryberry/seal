#!/bin/bash

teams=(
  content-tools
  govuk-easier-finding
  reliability-engineering
  servicemanual
)

for team in ${teams[*]} ; do
  ./bin/seal.rb $team quotes
done
