#!/bin/bash

teams=(
  design-system-dev
  govuk-data-informed
  govuk-licensing
  govuk-platform-health
  govuk-pub-workflow
  govuk-content-pages
  govuk-single-taxonomy
  govuk-step-by-step
  re-infra-internal
  re-observe
)

for team in ${teams[*]}; do
  ./bin/seal.rb $team
done
