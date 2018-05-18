#!/bin/bash

teams=(
  govuk-data-informed
  govuk-porg-pages
  govuk-licensing
)

for team in ${teams[*]} ; do
  ./bin/seal.rb $team quotes
done
