#!/bin/bash

teams=(
  govuk-easier-finding
  govuk-infrastructure
  search-team
  content-tools
  servicemanual
)

for team in ${teams[*]} ; do
  ./bin/seal.rb $team quotes
done
