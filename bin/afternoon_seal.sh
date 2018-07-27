#!/bin/bash

teams=(
  govuk-data-informed
  govuk-licensing
  govuk-platform-health
)

for team in ${teams[*]} ; do
  ./bin/seal.rb $team quotes
done
