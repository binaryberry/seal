#!/bin/bash

teams=(
  govuk-data-informed
  govuk-licensing
)

for team in ${teams[*]} ; do
  ./bin/seal.rb $team quotes
done
