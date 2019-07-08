#!/bin/bash

teams=(
  govuk-frontend-a11y
  govuk-data-informed
  govuk-licensing
  govuk-platform-health
  govuk-step-by-step
)

for team in ${teams[*]} ; do
  ./bin/seal.rb $team quotes
done
