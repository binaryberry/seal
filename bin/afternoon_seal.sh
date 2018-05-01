#!/bin/bash

teams=(
  govuk-data-informed
  govuk-porg-pages
  r20g-infra-internal
  govuk-licensing
)

for team in ${teams[*]} ; do
  ./bin/seal.rb $team quotes
done
