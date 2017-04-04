#!/bin/bash

teams=(
  govuk-infrastructure
  search
  content-tools
  servicemanual
)

for team in ${teams[*]} ; do
  ./bin/seal.rb $team quotes
done
